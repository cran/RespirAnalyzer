#' Function to plot multiscale entropy or MFDFA results by individual.
#'
#' @description function to plot multiscale entropy or MFDFA results by individual.
#'
#' @param x a vector for x-axis coordinate.
#' @param y Matrix for response values.
#' @param Name vector of names for each line.
#' @param xRange range for the x-axis.
#' @param yRange range for the y-axis.
#' @param col vector for the colors to indicate groups.
#' @param pch vector for points types to indicate groups.
#' @param Position position for the legend.
#' @param cex.legend cex for legend.
#' @param xlab a title for x axis.
#' @param ylab a title for y axis.
#' @param main main title for the picture.
#'
#' @return No value returned
#' @references Zhang T, Dong X, Chen C, Wang D, Zhang XD. RespirAnalyzer: an R package for continuous monitoring of respiratory signals.
#'
#' @examples data("HqData")
#' PP_Hq <- HqData
#' filenames <- row.names(PP_Hq)
#' q=-10:10
#' ClassNames <- c(substr(filenames[1:19], start = 1, stop = 3),
#'                 substr(filenames[20:38], start = 1, stop = 5))
#' Class <- unique(ClassNames)
#' col_vec <- rep(NA, nrow(PP_Hq) )
#' pch_vec <- rep(16, nrow(PP_Hq) )
#' for( i in 1:length(Class) ) { col_vec[ ClassNames == Class[i] ] <- i }
#' Individualplot.fn(q,PP_Hq,Name=Class,col=col_vec,pch=pch_vec, xlab="q",ylab="Hurst exponent")
#' legend("topright", legend=paste0(Class, "(N=", table( ClassNames ), ")"),
#'       col=1:4, cex=1, lty=1, pch=16)
#'
Individualplot.fn <- function(x,y, Name = NA, xRange = NA, yRange = NA,
                              col = NA, pch = NA, Position = "topright",
                              cex.legend = 0.75, xlab="",ylab="",main = "")
{

  stopifnot(is.vector(x, mode = "numeric") || length(is.na(x)) == 0)
  N <- dim(y)[1]
  if (is.na(xRange[1]))
    xRange <- range(x)
  if (is.na(col[1]))
    col <- 1:N
  if (is.na(pch[1]))
    pch <- 1:N
  if (is.na(yRange[1]))
    yRange <- range(y)

  plot(xRange, yRange, type = "n", axes = FALSE, xlab = xlab, ylab = ylab, cex.lab=1.6)
  axis(1)
  axis(2, las=2)
  box()

  for (i in 1:N){
    points(x, y[i,], col = col[i], pch = pch[i])
    lines(x, y[i,], col = col[i])
  }
  legend(Position, legend = Name, col = col, cex = cex.legend,
         lty = 1, pch = pch)
  title(main = main)
}
