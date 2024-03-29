#' Function to plot the mean and error bar by group
#'
#' @description function to plot the mean and error bar of sample entropy
#' or the MFDFA results by group
#'
#' @param  x a vector for x axis.
#' @param  Average Matrix for average in each group
#' @param  GroupName a vector of names for each group
#' @param  errorbar matrix for value of erorr bar
#' @param  xRange range for the x-axis
#' @param  yRange range for the y-axis
#' @param  col a vector for the colors to indicate groups
#' @param  pch a vector for points types to indicate groups
#' @param  Position position for the legend
#' @param  cex.legend cex for legend
#' @param  xlab a title for the x axis
#' @param  ylab a title for the y axis
#' @param  main main title for the plot
#'
#' @return No value returned
#' @references Zhang T, Dong X, Chen C, Wang D, Zhang XD. RespirAnalyzer: an R package for continuous monitoring of respiratory signals.
#'
#' @examples data("HqData")
#' PP_Hq <- HqData
#' filenames <- row.names(PP_Hq)
#' q <- -10:10
#' ClassNames <- c(substr(filenames[1:19], start = 1, stop = 3),
#'                 substr(filenames[20:38], start = 1, stop = 5))
#' Class <- unique(ClassNames)
#' for (i in 1:length(q)){
#'   Data <- GroupComparison.fn(PP_Hq[,i],ClassNames)
#'   Result_mean_vec <- Data[,"Mean"]
#'   Result_sd_vec <- Data[,"SE"]
#'   if( i == 1 ) {
#'     Result_mean_mat <- Result_mean_vec
#'     Result_sd_mat <- Result_sd_vec
#'   } else {
#'     Result_mean_mat <- rbind(Result_mean_mat, Result_mean_vec)
#'     Result_sd_mat <- rbind(Result_sd_mat, Result_sd_vec)
#'  }
#' }
#' Groupplot.fn (q[1:10],Result_mean_mat[1:10,],Class,errorbar = Result_sd_mat[1:10,],
#'               xRange = NA, yRange = NA, col = NA, pch = rep(16,4), Position = "topright",
#'               cex.legend = 1, xlab="q",ylab="Hurst exponent",main = "")
#' Groupplot.fn (q[11:21],Result_mean_mat[11:21,],Class,errorbar = Result_sd_mat[11:21,],
#'               xRange = NA, yRange = NA, col = NA, pch = rep(16,4), Position = "topright",
#'               cex.legend = 1, xlab="q",ylab="Hurst exponent",main = "")
#'
Groupplot.fn <- function(x,Average,GroupName,errorbar = NA,xRange = NA,
                         yRange = NA, col = NA, pch = NA, Position = "topright",
                         cex.legend = 0.75, xlab="",ylab="",main = "")
{

  stopifnot(is.vector(x, mode = "numeric") || length(is.na(x)) == 0)
  N_Group <- dim(Average)[2]
  if (is.na(xRange[1]))
    xRange <- range(x)
  if (is.na(col[1]))
    col <- 1:N_Group
  if (is.na(pch[1]))
    pch <- 1:N_Group
  if (is.na(yRange[1]))
    yRange <- range(Average)
  plot(xRange, yRange, type = "n", axes = FALSE, xlab = xlab, ylab = ylab, cex.lab=1.6)
  axis(1)
  axis(2, las=2)
  box()

  for (i in 1:N_Group) {
    points(x, Average[, i], col = col[i], pch = pch[i])
    lines(x, Average[, i], col = col[i])
    y1.vec <- Average[, i] - errorbar[,i]
    y2.vec <- Average[, i] + errorbar[,i]
    segments(x, y1.vec, x, y2.vec, col = col[i])
  }
  legend(Position, legend = GroupName, col = col, cex = cex.legend,
         lty = 1, pch = pch)
  title(main = main)
}
