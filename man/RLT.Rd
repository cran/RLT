% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RLT.r
\name{RLT}
\alias{RLT}
\title{Reinforcement Learning Trees}
\usage{
RLT(
  x,
  y,
  censor = NULL,
  model = "regression",
  print.summary = 0,
  use.cores = 1,
  ntrees = if (reinforcement) 100 else 500,
  mtry = max(1, as.integer(ncol(x)/3)),
  nmin = max(1, as.integer(log(nrow(x)))),
  alpha = 0.4,
  split.gen = "random",
  nsplit = 1,
  resample.prob = 0.9,
  replacement = TRUE,
  npermute = 1,
  select.method = "var",
  subject.weight = NULL,
  variable.weight = NULL,
  track.obs = FALSE,
  importance = TRUE,
  reinforcement = FALSE,
  muting = -1,
  muting.percent = if (reinforcement) MuteRate(nrow(x), ncol(x), speed = "aggressive",
    info = FALSE) else 0,
  protect = as.integer(log(ncol(x))),
  combsplit = 1,
  combsplit.th = 0.25,
  random.select = 0,
  embed.n.th = 4 * nmin,
  embed.ntrees = max(1, -atan(0.01 * (ncol(x) - 500))/pi * 100 + 50),
  embed.resample.prob = 0.8,
  embed.mtry = 1/2,
  embed.nmin = as.integer(nrow(x)^(1/3)),
  embed.split.gen = "random",
  embed.nsplit = 1
)
}
\arguments{
\item{x}{A matrix or data.frame for features}

\item{y}{Response variable, a numeric/factor vector or a Surv object}

\item{censor}{The censoring indicator if survival model is used}

\item{model}{The model type: \code{regression}, \code{classification} or \code{survival}}

\item{print.summary}{Whether summary should be printed}

\item{use.cores}{Number of cores}

\item{ntrees}{Number of trees, \code{ntrees = 100} if use reinforcement, \code{ntrees = 1000} otherwise}

\item{mtry}{Number of variables used at each internal node, only for \code{reinforcement = FALSE}}

\item{nmin}{Minimum number of observations required in an internal node to perform a split. Set this to twice of the desired terminal node size.}

\item{alpha}{Minimum number of observations required for each child node as a portion of the parent node. Must be within \code{(0, 0.5]}.}

\item{split.gen}{How the cutting points are generated}

\item{nsplit}{Number of random cutting points to compare for each variable at an internal node}

\item{resample.prob}{Proportion of in-bag samples}

\item{replacement}{Whether the in-bag samples are sampled with replacement}

\item{npermute}{Number of imputations (currently not implemented, saved for future use)}

\item{select.method}{Method to compare different splits}

\item{subject.weight}{Subject weights}

\item{variable.weight}{Variable weights when randomly sample \code{mtry} to select the splitting rule}

\item{track.obs}{Track which terminal node the observation belongs to}

\item{importance}{Should importance measures be calculated}

\item{reinforcement}{If reinforcement splitting rules should be used. There are default values for all tuning parameters under this feature.}

\item{muting}{Muting method, \code{-1} for muting by proportion, positive for muting by count}

\item{muting.percent}{Only for \code{muting = -1} the proportion of muting}

\item{protect}{Number of protected variables that will not be muted. These variables are adaptively selected for each tree.}

\item{combsplit}{Number of variables used in a combination split. \code{combsplit = 1} gives regular binary split; \code{combsplit > 1} produces linear combination splits.}

\item{combsplit.th}{The minimum threshold (as a relative measurement compared to the best variable) for a variable to be used in the combination split.}

\item{random.select}{Randomly select a variable from the top variable in the linear combination as the splitting rule.}

\item{embed.n.th}{Number of observations to stop the embedded model and choose randomly from the current protected variables.}

\item{embed.ntrees}{Number of embedded trees}

\item{embed.resample.prob}{Proportion of in-bag samples for embedded trees}

\item{embed.mtry}{Number of variables used for embedded trees, as proportion}

\item{embed.nmin}{Terminal node size for embedded trees}

\item{embed.split.gen}{How the cutting points are generated in the embedded trees}

\item{embed.nsplit}{Number of random cutting points for embedded trees}
}
\value{
A \code{RLT} object; a list consisting of
\item{FittedTrees}{Fitted tree structure}
\item{FittedSurv, timepoints}{Terminal node survival estimation and all time points, if survival model is used}
\item{AllError}{All out-of-bag errors, if \code{importance = TRUE}}
\item{VarImp}{Variable importance measures, if \code{importance = TRUE}}
\item{ObsTrack}{Registration of each observation in each fitted tree}
\item{...}{All the tuning parameters are saved in the fitted \code{RLT} object}
}
\description{
Fit models for regression, classification and survival analysis using reinforced splitting rules
}
\examples{

N = 600
P = 100

X = matrix(runif(N*P), N, P)
Y = rowSums(X[,1:5]) + rnorm(N)

trainx = X[1:200,]
trainy = Y[1:200]
testx = X[-c(1:200),]
testy = Y[-c(1:200)]

# Regular ensemble trees (Extremely Randomized Trees, Geurts, et. al., 2006)

RLT.fit = RLT(trainx, trainy, model = "regression", use.cores = 6)

barplot(RLT.fit$VarImp)
RLT.pred = predict(RLT.fit, testx)
mean((RLT.pred$Prediction - testy)^2)

# Reinforcement Learning Trees, using an embedded model to find the splitting rule
\donttest{
Mark0 = proc.time()
RLT.fit = RLT(trainx, trainy, model = "regression", use.cores = 6, ntrees = 100,
              importance = TRUE, reinforcement = TRUE, combsplit = 3, embed.ntrees = 25)
proc.time() - Mark0

barplot(RLT.fit$VarImp)
RLT.pred = predict(RLT.fit, testx)
mean((RLT.pred$Prediction - testy)^2)
}
}
\references{
Zhu, R., Zeng, D., & Kosorok, M. R. (2015) "Reinforcement Learning Trees." Journal of the American Statistical Association. 110(512), 1770-1784.

Zhu, R., & Kosorok, M. R. (2012). Recursively imputed survival trees. Journal of the American Statistical Association, 107(497), 331-340.
}
