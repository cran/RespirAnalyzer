#' Function to plot the results of MFDFA analysis
#'
#' @description function to plot the results of MFDFA analysis: q-orde
#' fluctuation function, Hurst exponent,mass exponent and multifractal
#' spectrum. The fitting result of binomial multifratcal model can be also
#' shown by the fitting line
#'
#' @param Result a list of the MFDFA results.
#' @param scale a vector of scales used to calculate the MFDFA results.
#' @param q a vector, q-order of the moment used to calculate the MFDFA results.
#' @param cex.lab the size of the tick label numbers/text with a numeric value of length 1.The default value is 1.6.
#' @param cex.axis the size of the axis label text with a numeric value of length 1.The default value is 1.6.
#' @param col.line color of the line
#' @param col.points color of the and point.
#' @param pch points types.
#' @param lwd line width.
#' @param lty line types.
#' @param model whether to use the model to fit the results and draw a line of fit.
#' @param cex.legend the size of the legend text with a numeric value of length 1.The default value is 1.
#'
#' @return  No value returned
#' @references Zhang T, Dong X, Chen C, Wang D, Zhang XD. RespirAnalyzer: an R package for continuous monitoring of respiratory signals.
#'
#' @examples data("TestData")
#' Fs=50 ## sampling frequency is 50Hz
#' Peaks <- find.peaks(Data[,2],Fs,lowpass=TRUE,freq=1,MovingAv=FALSE,
#'                     W=FALSE,filter=TRUE,threshold=0.05)
#' PP_interval=diff(Peaks[,1])/Fs
#' exponents=seq(3, 9, by=1/4)
#' scale=2^exponents
#' q=-10:10
#' m=2
#' Result <- MFDFA(PP_interval, scale, m, q)
#' MFDFAplot.fn(Result,scale,q)
#'

MFDFAplot.fn <- function(Result,scale,q,cex.lab=1.6,cex.axis=1.6, col.points=1,
                      col.line = 1,lty=1,pch = 16,lwd = 2,model = TRUE,cex.legend=1){
  if(model){
    Coeff <- fit.model(Result$Hq,q)
    Model <- Result[1:4]
    Model$Hq <- (1/q)*(1-log(Coeff["a"]^q+Coeff["b"]^q)/log(2))
    Model$Hq[which(q==0)] <- -log(Coeff["a"]*Coeff["b"])/(2*log(2))
    Model$tau_q <- -log(Coeff["a"]^q+Coeff["b"]^q)/log(2)
    Model$hq <- diff(Model$tau_q)
    Model$Dq <- q[1:(length(q)-1)]*Model$hq - Model$tau_q[1:(length(q)-1)]
  }

  # layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE),heights=c(4, 4))
  # oldpar <- par(no.readonly = TRUE)
  # on.exit(par(oldpar))
  ## 1st plot: Scaling function order Fq (q-order RMS)
  # par(mai=c(0.8,1,0.8,0.4))
  xRange <- range(log2(scale))
  yRange <- range(log2(Result$Fqi))
  plot(xRange, yRange, type = "n", axes = FALSE, xlab = expression('log'[2]*'(Scale)'),
       ylab=expression('log'[2]*'(F'[q]*')'), cex.lab=cex.lab, cex.axis=cex.axis,
       main= "q-order Fluctuation function")
  Index<-c(1,which(q==0),which(q==q[length(q)]))
  axis(2)
  axis(1)
  box()
  for (i in 1:3){
    k<-Index[i]
    points(log2(scale), log2(Result$Fqi[,k]),  col=col.points+i-1,pch=pch)
    lines(log2(scale),Result$line[,k], type="l", col=col.points+i-1, lwd=lwd)
  }
  legend("bottomright", c(paste('q','=',q[Index] , sep=' ' )),cex=cex.legend,
         lwd=c(lwd,lwd,lwd),pch=c(pch,pch,pch),bty="n", col=col.points:(col.points+2))

  ## 2nd plot: q-order Hurst exponent
  # par(mai=c(0.8,1,0.8,0.4))
  plot(q, Result$Hq, col=col.points, axes= F, ylab=expression('h'[q]), pch=pch, cex.lab=cex.lab,
       cex.axis=cex.axis, main="Hurst exponent", ylim=range(Result$Hq))
  if(model){
    lines(q,Model$Hq,col=col.line, lwd=lwd, lty=lty)
    legend("topright", c("Data","Model"),cex=cex.legend,
           lwd=c(-1,lwd),pch=c(pch,-1),bty="n", col=c(col.points,col.line))
  }
  axis(1, cex=4)
  axis(2, cex=4)
  box()

  ## 3rd plot: q-order Mass exponent
  # par(mai=c(0.8,1,0.8,0.4))
  plot(q, Result$tau_q, col=col.points, axes=F,cex.lab=cex.lab, cex.axis=cex.axis,
       main="Mass exponent",pch=16,ylab=expression(tau[q]))
  # grid(col="midnightblue")
  if(model){
    lines(q,Model$tau_q,col=col.line, lwd=lwd,lty=lty)
    legend("bottom", c("Data","Model"),cex=cex.legend,
           lwd=c(-1,lwd),pch=c(pch,-1),bty="n", col=c(col.points,col.line))
  }
  axis(1, cex=4)
  axis(2, cex=4)
  box()

  ## 4th plot: Multifractal spectrum
  # par(mai=c(0.8,1,0.8,0.4))
  plot(Result$hq, Result$Dq, col=col.points, axes=F, pch=16,
       main="Multifractal spectrum",ylab=bquote("f ("~alpha~")"),
       cex.lab=cex.lab,cex.axis=cex.axis,xlab=bquote(~alpha))
  # grid(col="midnightblue")
  axis(1, cex=4)
  axis(2, cex=4)
  box()
  if(model){
    lines(Model$hq,Model$Dq,col=col.line, lwd=lwd,lty=lty)
    legend("bottom", c("Data","Model"),cex=cex.legend,
           lwd=c(-1,lwd),pch=c(pch,-1),bty="n", col=c(col.points,col.line))
  }
}

