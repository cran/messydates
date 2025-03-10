% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/operate_statements.R
\name{operate_statements}
\alias{operate_statements}
\alias{is_messydate}
\alias{is_intersecting}
\alias{is_subset}
\alias{is_similar}
\alias{is_precise}
\alias{is_uncertain}
\alias{is_approximate}
\alias{is_bce}
\title{Logical statements on messy dates}
\usage{
is_messydate(x)

is_intersecting(x, y)

is_subset(x, y)

is_similar(x, y)

is_precise(x)

is_uncertain(x)

is_approximate(x)

is_bce(x)
}
\arguments{
\item{x, y}{\code{mdate} or other class objects}
}
\value{
A logical vector the same length as the \code{mdate} passed.
}
\description{
These functions provide various logical statements about messy date objects.
}
\section{Functions}{
\itemize{
\item \code{is_messydate()}: tests whether the object inherits the \code{mdate} class.
If more rigorous validation is required, see \code{validate_messydate()}.

\item \code{is_intersecting()}: tests whether there is any intersection between
two messy dates, leveraging \code{intersect()}.

\item \code{is_subset()}: tests whether one or more messy date can be found
within a messy date range or set.

\item \code{is_similar()}: tests whether two dates contain similar components.
This can be useful for identifying dates that may be typos of one another.

\item \code{is_precise()}: tests whether a date is precise (i.e. an 8 digit date).
Non-precise dates contain markers that they are approximate (i.e. ~),
unreliable (i.e. ?), are incomplete dates (i.e. year only),
or date ranges and sets.

\item \code{is_uncertain()}: tests whether a date is uncertain (i.e. contains ?).

\item \code{is_approximate()}: tests whether a date is approximate (i.e. contains ~).

\item \code{is_bce()}: tests whether one or more messy dates are found
before the common era.

}}
\examples{
is_messydate(as_messydate("2012-01-01"))
is_messydate(as.Date("2012-01-01"))
is_intersecting(as_messydate("2012-01"),
as_messydate("2012-01-01..2012-02-22"))
is_intersecting(as_messydate("2012-01"),
as_messydate("2012-02-01..2012-02-22"))
is_subset(as_messydate("2012-01-01"), as_messydate("2012-01"))
is_subset(as_messydate("2012-01-01..2012-01-03"), as_messydate("2012-01"))
is_subset(as_messydate("2012-01-01"), as_messydate("2012-02"))
is_similar(as_messydate("2012-06-02"), as_messydate("2012-02-06"))
is_similar(as_messydate("2012-06-22"), as_messydate("2012-02-06"))
is_precise(as_messydate(c("2012-06-02", "2012-06")))
is_uncertain(as_messydate(c("2012-06-02", "2012-06-02?")))
is_approximate(as_messydate(c("2012-06-02~", "2012-06-02")))
is_bce(as_messydate(c("2012-06-02", "-2012-06-02")))
}
