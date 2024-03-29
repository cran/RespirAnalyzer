#' Function to calculate Moving Average of a series
#'
#' @description  function to calculate Moving Average of a series
#'
#' @param y a numeric vector, with respiratory data for a regularly spaced time series.
#' @param W a Positive integer, the windows of Moving Average.
#'
#' @return A new numeric vector after calculate the moving average.
#' @references Zhang T, Dong X, Chen C, Wang D, Zhang XD. RespirAnalyzer: an R package for continuous monitoring of respiratory signals.
#'
#' @examples data("TestData")
#' W <- 50
#' y <- MovingAverage(Data[,2],W)


MovingAverage<-function(y,W){
  if (W != round(W)|W<0)  stop( "'W' must be a positive integer")
  N <- length(y)
  index <- floor(W/2)
  shuchu <- vector(length=N)
  for (i in 1:index){
    shuchu[i] <- mean(y[1:i])
  }
  for (i in (index+1):(N-index)){
    shuchu[i] <- mean(y[(i-index):(i+index)])
  }
  for(i in (N-index+1):N){
    shuchu[i] <- mean(y[i:N])
  }
  return(shuchu)
}
