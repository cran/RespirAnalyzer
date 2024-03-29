#' Function to compute the multiscale entropy(MSE)
#'
#' @description function to perform a multiscale entropy (MSE) analysis of a regularly spaced time series.
#' Return the results as an R data frame. Methods derived from Madalena Costa(2002) "Multiscale entropy analysis of complex physiologic time series" <doi:10.1103/PhysRevLett.89.068102>.
#'
#' @param x a numeric vector, with data for a regularly spaced time series. NA's are not allowed (because the C program is not set up to handle them).
#' @param tau a vector of scale factors to use for MSE.  Scale factors are positive integers that specify bin size for the MSE algorithm:
#' the number ofconsecutive observations in 'x' that form a bin and are averaged in the first step of the algorithm.
#' Must be a sequence of equally-spaced integers starting at 1. The largest value must still leave a sufficient number of bins to estimate entropy.
#' @param m a positive integers giving the window size for the entropy calculations in the second step of the algorithm, Typical values are 1, 2, or 3.
#' @param r a positive value of coefficients for similarity thresholds, such as r=0.15, r*sd(y) must be in the same units as 'x'.
#' Averages in two bins are defined to be similar if they differ by 'r*sd(y)' or less. NOTE: Currently only a single threshold is allowed per run; i.e.,'r' must be a scalar.
#' @param I  the maximal number of points to be used for calculating MSE
#'
#' @return  A data frame with with one row for each combination of 'tau', 'm' and 'rSD'. Columns are "tau", "m", "rSD", and "SampEn" (the calculated sample entropy).
#' The data frame will also have an attribute "SD", the standard deviation of 'x'. rSD = r*sd(y)
#' @references Zhang T, Dong X, Chen C, Wang D, Zhang XD. RespirAnalyzer: an R package for continuous monitoring of respiratory signals.
#'
#' @examples data("TestData") # load Data from TestData dataset
#' oldoptions <- options(scipen=999)
#' Fs <- 50 # sampling frequency
#' scale_raw <- seq(1,90,by=2)
#' MSER <-  MSE(Data[1:10000,2], tau=scale_raw, m=2,
#'             r=0.15, I=40000)
#' print(MSER)
#' options(oldoptions)
#'


MSE <- function(x, tau, m, r, I)
{
  if (anyNA(x))  stop("'NA' values in 'x' are not allowed")
  if (anyNA(tau) || anyNA(m) || anyNA(r))  stop(
    "NAs are not allowed in 'tau', 'm', or 'r'")
  if (length(tau) < 1 || any(tau < 1) || any(tau != round(tau)))  stop(
    "'tau' must be a vector of positive integers")
  N <- length(x)
  if (any(tau > N/2))  stop(
    "'tau' must not be more than half the length of 'x'")

  SD <- sd(x, na.rm=TRUE)
  # Temporary files for input and output to the C program:
  tempin <- tempfile("temp", tmpdir=getwd(), fileext=".txt")
  tempout <- tempfile("temp", tmpdir=getwd(), fileext=".txt")
  write(x, file=tempin, ncolumns=1, sep="\t")
  on.exit(unlink(tempin))

  oldoptions <- options()
  on.exit(options(oldoptions),add = TRUE)
  options(scipen=999) #999
  # Construct command line arguments for the C program.
  args <- character(0)
  #.. tau = scale = number of observations per bin for coarse graining.
  if (tau[1] != 1)  stop("Values for 'tau' must start at 1")
  args <- c(args, paste("-n", max(tau)))
  if (length(tau) > 1) {
    incr <- unique(diff(tau))
    if (length(incr) > 1)  stop("'tau' values must be equally spaced")
    args <- c(args, paste("-a", incr))
  }
  #.. m = window size
  args <- c(args, paste("-m", min(m), "-M", max(m)))
  if (length(m) > 1) {
    incr <- unique(diff(m))
    if (length(incr) > 1)  stop("'m' values must be equally spaced")
    args <- c(args, paste("-b", incr))
  }
  #.. r = similarity threshold, in units of the SD of 'x'
  args <- c(args, paste("-r", min(r), "-R", max(r)))
  if (length(r) > 1) {
    # For some reason the '-c' command line argument (specifying the spacing
    # between values of 'r' to use) causes 'lrg_mse2.exe' to fail silently.
    # (Although the default value of 0.05 does work.)  Therefore only allow
    # a single 'r' value to used per run.
    stop("Only a single 'r' value per run is currently allowed.")
    rseq <- seq(from=r[1], to=tail(r, 1), length.out=length(r))
    if (!isTRUE(all.equal(r, rseq)))   stop("'r' values must be equally spaced")
    incr <- mean(diff(r))
    args <- c(args, paste("-c", incr))
  }
  # maximal number of points for calculating MSE
  args <- c(args, paste("-I", I))

  # Run the C program.
  cmd <- paste("exe", paste(args, collapse=" "), "-z", tempin, "-Z", tempout)
  on.exit(unlink(tempout), add=TRUE)
  # shell(cmd, wait=TRUE, intern=FALSE, invisible=TRUE)
  Mse(cmdstrp = cmd)

  # Read results back into R.
  txt <- readLines(tempout)
  # Format consists of 4 header lines (of no interest), followed by one block
  # of output per (m, r) combination, with blocks separated by blank lines.
  # Each block consists of a label line ("m = <m>,  r = <r>"), a blank line,
  # and then one line per tau (scale) value:  <scale>\t<entropy value>\t.
  # (If there was more than one data file (i.e., "-F" option was used),
  # additional columns would contain their entropy values.)
  txt <- txt[-(1:4)]
  txt <- txt[txt != ""]
  start_block <- grep("^m =", txt)
  end_block <- c(tail(start_block, -1) - 1, length(txt))
  rslt <- vector("list", length(start_block))
  for (i in seq_along(start_block)) {
    lbl <- txt[start_block[i]]
    mr <- eval(parse(text=paste0("c(", lbl, ")")))
    # Convert 'r' back to units of 'x', to be consistent with input argument.
    mr["r"] <- mr["r"] * SD
    con <- textConnection(txt[(start_block[i]+1):(end_block[i])])
    te <- read.table(con, header=FALSE, sep="\t", row.names=NULL,
                     col.names=c("tau", "SampEn", "junk"),
                     colClasses="numeric", comment.char="")
    te$junk <- NULL  # 'junk' just deals with trailing "\t" on each line
    close(con)
    rslt[[i]] <- data.frame("m"=rep(mr["m"], nrow(te)),
                            "rSD"=rep(mr["r"], nrow(te)), te)
  }
  # Combine all blocks into a single data frame.
  rslt <- do.call("rbind", rslt)

  structure(rslt[, c("tau", "m", "rSD", "SampEn")], "SD"=SD)
}
