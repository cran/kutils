% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mergeCheck.R
\name{mergeCheck}
\alias{mergeCheck}
\title{First draft of function to diagnose problems in merges and key variables}
\usage{
mergeCheck(
  x,
  y,
  by,
  by.x = by,
  by.y = by,
  incomparables = c(NULL, NA, NaN, Inf, "\\\\s+", "")
)
}
\arguments{
\item{x}{data frame}

\item{y}{data frame}

\item{by}{Commonly called the "key" variable. A column name to be
used for merging (common to both \code{x} and \code{y})}

\item{by.x}{Column name in \code{x} to be used for merging. If not
supplied, then \code{by.x} is assumed to be same as \code{by}.}

\item{by.y}{Column name in \code{y} to be used for merging. If not
supplied, then \code{by.y} is assumed to be same as \code{by}.}

\item{incomparables}{values in the key (by) variable that are
ignored for matching. We default to include these values as
incomparables: c(NULL, NA, NaN, Inf, "\\s+", ""). Note this is
a larger list of incomparables than assumed by R merge (which
assumes only NULL).}
}
\value{
A list of data structures that are displayed for keys and
    data sets.  The return is \code{list(keysBad, keysDuped,
    unmatched)}. \code{unmatched} is a list with 2 elements, the
    unmatched cases from \code{x} and \code{y}.
}
\description{
This is a first effort. It works with 2 data frames and 1 key
variable in each. It does not work if the by parameter includes
more than one column name (but may work in future). The return is
a list which includes full copies of the rows from the data frames
in which trouble is observed.
}
\examples{
df1 <- data.frame(id = 1:7, x = rnorm(7))
df2 <- data.frame(id = c(2:6, 9:10), x = rnorm(7))
mc1 <- mergeCheck(df1, df2, by = "id")
## Use mc1 objects mc1$keysBad, mc1$keysDuped, mc1$unmatched
df1 <- data.frame(id = c(1:3, NA, NaN, "", " "), x = rnorm(7))
df2 <- data.frame(id = c(2:6, 5:6), x = rnorm(7))
mergeCheck(df1, df2, by = "id")
df1 <- data.frame(idx = c(1:5, NA, NaN), x = rnorm(7))
df2 <- data.frame(idy = c(2:6, 9:10), x = rnorm(7))
mergeCheck(df1, df2, by.x = "idx", by.y = "idy")
}
\author{
Paul Johnson
}
