% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{stringbreak}
\alias{stringbreak}
\title{Insert "\\n" after the k'th character in a string. This IS vectorized,
so can receive just one or many character strings in a vector.}
\usage{
stringbreak(x, k = 20)
}
\arguments{
\item{x}{Character string.}

\item{k}{Number of characters after which to insert "\\n". Default is 20}
}
\value{
Character with "\\n" inserted
}
\description{
If a string is long, insert linebreak "\\n"
}
\details{
If x is not a character string, x is returned without alteration. And
without a warning
}
\examples{
x <- "abcdef ghijkl mnopqrs tuvwxyz abc def ghi jkl mno pqr stv"
stringbreak(x, 10)
stringbreak(x, 20)
stringbreak(x, 25)
x <- c("asdf asdfjl asfdjkl asdfjklasdfasd", "qrweqwer qwerqwerjklqw erjqwe")
stringbreak(x, 5)
}
\author{
Paul Johnson <pauljohn@ku.edu>
}
