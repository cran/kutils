% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{writeCSV}
\alias{writeCSV}
\title{Write CSV files with quotes same as MS Excel 2013 or newer}
\usage{
writeCSV(x, file, row.names = FALSE)
}
\arguments{
\item{x}{a data frame}

\item{file}{character string for file name}

\item{row.names}{Default FALSE for row.names}
}
\value{
the return from write.table, using revised quotes
}
\description{
R's write.csv inserts quotes around all elements in a character
vector (if quote = TRUE).  In contrast, MS Excel CSV export no
longer inserts quotation marks on all elements in character
variables, except when the cells include commas or quotation
marks.  This function generates CSV files that are, so far as we
know, exactly the same "quoted style" as MS Excel CSV export
files.
}
\details{
This works by manually inserting quotation marks where necessary and
turning FALSE R's own method to insert quotation marks.
}
\examples{
set.seed(234)
x1 <- data.frame(x1 = c("a", "b,c", "b", "The \"Washington, DC\""),
      x2 = rnorm(4), stringsAsFactors = FALSE)
x1
fn <- tempfile(pattern = "testcsv", fileext = ".csv")
writeCSV(x1, file = fn)
readLines(fn)
x2 <- read.table(fn, sep = ",", header = TRUE, stringsAsFactors = FALSE)
all.equal(x1,x2)
}
\author{
Paul Johnson
}
