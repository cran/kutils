##' Delete trailing slash
##'
##' This function cleans up a path string by removing the trailing
##' slash.  This is necessary on MS Windows, \code{file.exists(fn)} fails
##' if "/" is on end of file name. Deleting the trailing slash is thus
##' required on Windows and it is not harmful on other platforms.
##'
##' All usages of \code{file.exists(fn)} in R should be revised
##' to be multi-platform safe by writing \code{file.exists(dts(fn))}.
##'
##' This version also removes repeated adjacent slashes, so that
##' \code{"/tmp///paul//test/"} becomes \code{"/tmp/paul/test"}.
##' @param name A path
##' @return Same path with trailing "/" removed.
##' @export
##' @author Paul Johnson <pauljohn@@ku.edu>
dts <- function(name) gsub("/$", "", dms(name))
NULL

##' Delete multiple slashes, replace with one
##'
##' Sometimes paths end up with "/too//many//slashes".
##' While harmless, this is untidy. Clean it up.
##' @param name A character string to clean
##' @export
##' @author Paul Johnson <pauljohn@@ku.edu>
dms <- function(name) gsub("(/)\\1+", "/", name)
NULL


##' How many stars would we need for this p value?
##'
##' Regression table makers need to know how many stars
##' to attach to parameter estimates. This takes
##' p values and a vector which indicates how many stars
##' are deserved.  It returns a required number of asterixes.
##' Was named "stars" in previous version, but renamed due to
##' conflict with R base function \code{stars}
##'
##' Recently, we have requests for different symbols. Some people want
##' a "+" symbol if the p value is smaller than 0.10 but greater than
##' 0.05, while some want tiny smiley faces if p is smaller than
##' 0.001. We accomodate that by allowing a user specified vector of
##' symbols, which defaults to c("*", "**", "***")
##' @param pval P value
##' @param alpha alpha vector, defaults as c(0.05, 0.01, 0.001).
##' @param symbols The default is c("*", "**", "***"), corresponding
##'     to mean that p values smaller than 0.05 receive one star,
##'     values smaller than 0.01 get two stars, and so forth.  Must be
##'     same number of elements as alpha. These need not be asterixes,
##'     could be any character strings that users desire. See example.
##' @return a character vector of asterixes, same length as pval
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @export
##' @examples
##' starsig(0.06)
##' starsig(0.021)
##' starsig(0.001)
##' alpha.ex <- c(0.10, 0.05, 0.01, 0.001)
##' symb.ex <- c("+", "*", "**", ":)!")
##' starsig(0.07, alpha = alpha.ex, symbols = symb.ex)
##' starsig(0.04, alpha = alpha.ex, symbols = symb.ex)
##' starsig(0.009, alpha = alpha.ex, symbols = symb.ex)
##' starsig(0.0009, alpha = alpha.ex, symbols = symb.ex)
##' 
starsig <-
    function(pval, alpha = c(0.05, 0.01, 0.001),
             symbols = c("*", "**", "***"))
{
    if (length(alpha) != length(symbols)) {
        messg <- "alpha vector must have same number of elements as symbols vector"
        stop(messg)
    }
    nstars <- sapply(pval, function(x) sum(abs(x) < alpha))
    sapply(nstars, function(y) symbols[y])
}
NULL 


##' Remove elements if they are in a target vector, possibly replacing with NA
##'
##' If a vector has c("A", "b", "c") and we want to remove "b" and
##' "c", this function can do the work. It can also replace "b" and
##' "c" with the NA symbol.
##'
##' If elements in y are not members of x, they are silently ignored.
##' 
##' The code for this is not complicated, but it is
##' difficult to remember.  Here's the recipe to remove
##' elements y from x: \code{x <- x[!x \%in\% y[y \%in\% x]]}. It is
##' easy to get that wrong when in a hurry, so we use this function
##' instead.  The \code{padNA} was an afterthought, but it helps sometimes.
##' 
##' @param x vector from which elements are to be removed
##' @param y shorter vector of elements to be removed
##' @param padNA Default FALSE, Should removed items be replaced with NA values?
##' @return a vector with elements in y removed
##' @author Ben Kite <bakite@@ku.edu> and Paul Johnson <pauljohn@@ku.edu>
##' @export
##' @examples
##' x <- c("a", "b", "c", "d", "e", "f")
##' y <- c("e", "a")
##' removeMatches(x, y)
##' y <- c("q", "r", "s")
##' removeMatches(x, y)
removeMatches <- function(x, y, padNA = FALSE){
    if (padNA) {
        x[x %in% y] <- NA
    } else {
        x <- x[!x %in% y[y %in% x]]
    }
    x
}


##' apply a vector of replacements, one after the other.
##'
##' This is multi-gsub.  Use it when it is necessary to process
##' many patterns and replacements in a given order on a vector.
##' 
##' @param pattern vector of values to be replaced. A vector filled
##'     with patterns as documented in the \code{gsub} pattern
##'     argument
##' @param replacement vector of replacements, otherwise same as
##'     \code{gsub}.  Length of replacement must be either 1 or same
##'     as pattern, otherwise an error results.
##' @param x the vector in which elements are to be replaced, same as
##'     \code{gsub}
##' @param ... Additional arguments to be passed to gsub
##' @return vector with pattern replaced by replacement
##' @author Jared Harpole <jared.harpole@@gmail.com> and Paul Johnson
##'     <pauljohn@@ku.edu>
##' @export
##' @examples
##' x <- c("Tom", "Jerry", "Elmer", "Bugs")
##' pattern <- c("Tom", "Bugs")
##' replacement <- c("Thomas", "Bugs Bunny")
##' (y <- mgsub(pattern, replacement, x))
##' x[1] <- "tom"
##' (y <- mgsub(pattern, replacement, x, ignore.case = TRUE))
##' (y <- mgsub(c("Elmer", "Bugs"), c("Looney Characters"), x, ignore.case = TRUE))
mgsub <- function(pattern, replacement, x, ... ){
    if (length(pattern) != length(replacement)) {
        if (length(replacement) == 1) {
            replacement <- rep(replacement, length(pattern))
        } else {
            messg <- paste("replacement must either be 1 element or the same number of elements as pattern")
            stop(messg)
        }
    }
    for (i in seq_along(pattern)){
        x <- gsub(pattern[i], replacement[i], x, ...)
    }
    x
}
    


##' Reduce each in a vector of strings to a given length
##'
##' This is a simple "chop" at k characters, no fancy truncation at
##' spaces or such. Optionally, this will make unique the resulting
##' truncated strings. That way, truncation at character 4 of
##' "Washington" and "Wash" and "Washingham" will not result in 3
##' values of "Wash", but rather "Wash", "Wash.1", and "Wash.2"
##' @param x character string
##' @param k integer limit on length of string. Default is 20
##' @param unique Default FALSE
##' @return vector of character variables no longer than k
##' @author Paul Johnson
##' @export
##' @examples
##' x <- c("Washington", "Washingham", "Washmylaundry")
##' shorten(x, 4)
##' shorten(x, 4, unique = TRUE)
shorten <- function(x, k = 20, unique = FALSE){
    if(!is.character(x)) stop("shorten: x must be a character variable")
    y <- substr(x, 1, k)
    if (unique) y <- make.unique(y)
    y
}


##' Insert "\\n" after the k'th character in a string. This IS vectorized,
##' so can receive just one or many character strings in a vector.
##'
##' If a string is long, insert linebreak "\\n"
##'
##' If x is not a character string, x is returned without alteration. And
##' without a warning
##' @param x Character string.
##' @param k Number of characters after which to insert "\\n". Default is 20
##' @return Character with "\\n" inserted
##' @author Paul Johnson
##' @export
##' @examples
##' x <- "abcdef ghijkl mnopqrs tuvwxyz abc def ghi jkl mno pqr stv"
##' stringbreak(x, 10)
##' stringbreak(x, 20)
##' stringbreak(x, 25)
##' x <- c("asdf asdfjl asfdjkl asdfjklasdfasd", "qrweqwer qwerqwerjklqw erjqwe")
##' stringbreak(x, 5)
stringbreak <- function(x, k = 20){
    if (!is.character(x)) return(x)
    breakOneString <- function(y, k){
        ylength <- nchar(y)
        if (ylength <= k) return (y)
        
        yseq <- seq(1, ylength, by = k)
        
        ## iterate on successive pairs of yseq, but exclude last one
        res <- ""
        for(i in seq_along(yseq[-length(yseq)])){
            res <- paste0(res, paste0(substr(y, yseq[i], (yseq[i+1] - 1)), "\n"))
        }
        if (yseq[i] < ylength) res <- paste0(res, substr(y, yseq[i + 1], ylength))
        res
    }
    vapply(x, breakOneString, k = k, character(1))
}



##' Insert 0's in the front of existing digits or characters so that
##' all elements of a vector have the same number of characters.
##'
##' The main purpose was to correct ID numbers in studies that are
##' entered as integers with leading 0's as in 000001 or 034554.  R's
##' default coercion of integers will throw away the preceding 0's,
##' and reduce that to 1 or 34554. The user might want to re-insert
##' the 0's, thereby creating a character vector with values "000001" 
##' and "045665".
##'
##' If x is an integer or a character vector, the result is the
##' more-or-less expected outcome (see examples). If x is numeric,
##' but not an integer, then x will be rounded to the lowest integer.
##' 
##' The previous versions of this function failed when there were
##' missing values (NA) in the vector x.  This version returns NA for
##' those values.
##'
##' One of the surprises in this development was that sprintf() in R
##' does not have a known consequence when applied to a character
##' variable. It is platform-dependent (unredictable). On Ubuntu Linux
##' 16.04, for example \code{sprintf("\%05s", 2)} gives back
##' \code{" 2"}, rather than (what I expected) \code{"00002"}. The
##' problem is mentioned in the documentation for \code{sprintf}. The
##' examples show this does work now, but please test your results.
##' @param x vector to be converted to a character variable by
##'     inserting 0's at the front. Should be integer or character,
##'     floating point numbers will be rounded down. All other
##'     variable types will return errors.
##' @param n Optional parameter.  The desired final length of
##'     character vector.  This parameter is a guideline to determine
##'     how many 0's must be inserted.  This will be ignored if
##'     \code{n} is smaller than the number of characters in the
##'     longest element of \code{x}.
##' @return A character vector
##' @export
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @examples
##' x1 <- c(0001, 0022, 3432, NA)
##' padW0(x1)
##' padW0(x1, n = 10)
##' x2 <- c("1", "22", "3432", NA)
##' padW0(x2)
##' ## There's been a problem with strings, but this works now.
##' ## It even preserves non-leading spaces. Hope that's what you want.
##' x3 <- c("1", "22 4", "34323  42", NA)
##' padW0(x3)
##' x4 <- c(1.1, 334.52, NA)
##' padW0(x4)
padW0 <- function (x, n = 0) {
    if (!is.numeric(x) && !is.character(x))
        stop("padW0 only accepts integer or character values for x")

    xismiss <- is.na(x)
    ## springf trouble with characters, not platform independent
    if(is.numeric(x)) {
        if (is.double(x)) x <- as.integer(x)
        maxlength <- max(nchar(x), n, na.rm = TRUE)
        vtype <- "d"
        res <- sprintf(paste0("%0", maxlength, vtype), x)
    } else {
        maxlength <- max(nchar(x), n, na.rm = TRUE)
        xlength <- vapply(x, nchar, integer(1))
        padcount <- maxlength - xlength
        pads <- vapply(padcount, function(i){paste0(rep("0", max(0, i, na.rm=TRUE)), collapse = "")}, character(1))
        res <- paste0(pads, x)
    }

    res[xismiss] <- NA
    res
}
 