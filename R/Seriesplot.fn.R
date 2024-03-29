#'  Function to plot series data
#'
#' @description  function to plot series data. including Respiration data and
#' Peak-to-Peak intervals series.
#'
#' @param x a vector for the x-axis coordinate of a sequence.
#' @param y a vector for the y-axis coordinates of a sequence.
#' @param xRange range for the x-axis.
#' @param yRange range for the y-axis.
#' @param points whether to draw the points of the sequence. If points = TRUE, a sequence of points will be plotted. otherwise, will not plot the points.
#' @param pch points types.
#' @param col.point color code or name of the points.
#' @param cex.point cex of points
#' @param line whether to draw a line of the sequence. If line = TRUE, a line of sequence will be plotted. otherwise, will not plot the line.
#' @param lty line types.
#' @param col.line color code or name of the line.
#' @param lwd line width.
#' @param xlab a title for the x axis.
#' @param ylab a title for the y axis.
#' @param main main title for the picture.
#'
#' @return No value return
#' @references Zhang T, Dong X, Chen C, Wang D, Zhang XD. RespirAnalyzer: an R package for continuous monitoring of respiratory signals.
#'
#' @examples data("TestData")
#' oldpar <- par(mfrow=c(1,2))
#' Seriesplot.fn(Data[1:10000,1],Data[1:10000,2],points=FALSE,xlab="Time(s)",ylab="Respiration")
#' Fs=50 ## sampling frequency is 50Hz
#' Peaks <- find.peaks(Data[,2],Fs,lowpass=TRUE,freq=1,MovingAv=FALSE,
#'                     W=FALSE,filter=TRUE,threshold=0.05)
#' PP_interval=diff(Peaks[,1])/Fs
#' Seriesplot.fn(1:length(PP_interval),PP_interval,points=FALSE,xlab="Count",ylab="Interval(s)")
#' par(oldpar)
#'

Seriesplot.fn <- function (x, y, xRange = NA, yRange = NA,
                           points = TRUE, pch = 1, col.point = 1,  cex.point = 1,
                           line = TRUE, lty = 1, col.line = 1, lwd = 1,
                           xlab = "x", ylab = "y", main="")
{
  if (is.na(xRange[1]))
    xRange <- range(x, na.rm = TRUE)
  if (is.na(yRange[1]))
    yRange <- range(y, na.rm = TRUE)
  plot(xRange, yRange, type = "n",
       axes = F, xlab = xlab, ylab = ylab)
  axis(1)
  axis(2)
  box()
  if (points){
    points(x, y, pch = pch, col = col.point, cex = cex.point)
  }
  if (line){
    lines(x, y, lty = lty, col = col.line, lwd = lwd)
  }
}

