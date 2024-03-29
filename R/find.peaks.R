#' Function to find the peak-to-peak intervals of a respiratory signal.
#'
#' @description  function to find the peak-to-peak intervals of a respiratory signal.
#'
#' @param y a numeric vector, with respiratory data for a regularly spaced time series..
#' @param Fs a positive value. sampling frequency of airflow signal.
#' @param lowpass logical. Whether to use low-pass filtering to preprocess the airflow signal.
#' @param freq an optional values. Cut-off frequency of low-pass filter. The default value is 1.
#' @param MovingAv logical.Whether to use Moving Average to preprocess the airflow signal.
#' @param W an optional values. the windows of Moving Average.  The default value is equal to the sampling frequency Fs.
#' @param filter logical.Whether to filter the points of peaks.
#' @param threshold an optional value. A threshold is the minimum height difference between the wave crest and wave trough. The default value is 0.2.
#'
#' @return a dataframe for the information of peaks. "PeakIndex" is the position of the peaks and "PeakHeight" is the height of the peaks
#' @references Zhang T, Dong X, Chen C, Wang D, Zhang XD. RespirAnalyzer: an R package for continuous monitoring of respiratory signals.
#'
#' @examples data("TestData") # load Data from TestData dataset
#' Fs=50 ## sampling frequency is 50Hz
#' Peaks <- find.peaks(Data[,2],Fs,lowpass=TRUE,freq=1,MovingAv=FALSE,
#'                     W=FALSE,filter=TRUE,threshold=0.05)
#' Peaks
#'
#'

find.peaks<-function(y,Fs,lowpass=TRUE,freq=1,MovingAv=FALSE,W=FALSE,
                       filter=TRUE,threshold=0.2){

  if (W != round(W)|W<0)  stop( "'W' must be a positive integer")
  if (Fs != round(Fs)|Fs<0)  stop( "'Fs' must be a positive integer")
  if (anyNA(y))  stop("'NA' values in 'y' are not allowed")
  if (lowpass){
    bf <- signal::butter(2, freq*2/Fs, type="low")
    y <- signal::filtfilt(bf,y)
  }
  if (!W){
    W <- Fs
  }
  if (MovingAv){
    y <- MovingAverage(y,W)
  }
  A <- pracma::findpeaks(y,zero = "0", nups=floor(Fs/20),ndowns=floor(Fs/20),
                         sortstr=F,minpeakdistance=floor(Fs/10))
  B <- A[order(A[,2]),]
  PeakIndex <- B[,2]; PeakHeight <- B[,1]
  if(filter){
    C <- B[union(which((y[B[,2]]-y[B[,3]])>threshold),which((y[B[,2]]-y[B[,4]])>threshold)),]
    PeakIndex <- C[,2]; PeakHeight <- C[,1]
  }
  result <- data.frame(PeakIndex,PeakHeight)
  result <- result[order(result[,1]),]
  return(result)
}

