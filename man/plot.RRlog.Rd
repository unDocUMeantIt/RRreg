% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RRlog.R
\name{plot.RRlog}
\alias{plot.RRlog}
\title{Plot Logistic RR Regression}
\usage{
\method{plot}{RRlog}(x, predictor = NULL, center.preds = T, plot.mean = T,
  ci = 0.95, xlim = NULL, steps = 50, ...)
}
\arguments{
\item{x}{a fitted \link{RRlog} object}

\item{predictor}{character name of a predictor of the model to be fitted}

\item{center.preds}{whether to compute predictions by assuming that all other predictors are at their respective mean values (if FALSE: all other predictors set to zero)}

\item{plot.mean}{whether to plot mean of predictor as vertical line}

\item{ci}{level for confidence intervals. Set to 0 to omit.}

\item{xlim}{if provided, these boundaries are used for the predictor on the x-axis}

\item{steps}{number of steps for plotting}

\item{...}{other arguments passed to the function \link{plot}}
}
\description{
Plot the predictions of a fitted  logistic RR regression model. Data are not included directly, as these are not directly interpretable due to the RR design.
}
\examples{
 # generate data
 n <- 500
 x <- data.frame(x1=rnorm(n))
 pi.true <- 1/(1+exp(.3+1.5*x$x1))
 dat <- RRgen(n, pi.true=pi.true, model="Warner", p=.1)
 x$response <- dat$response
 # fit and plot model
 mod <- RRlog(response ~ x1, data=x, model="Warner", p=.1)
 plot(mod, "x1" ,ci=.95)
 
}

