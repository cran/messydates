% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proportional.R
\name{proportional}
\alias{proportional}
\alias{\%l\%}
\alias{\%l\%.mdate}
\alias{\%g\%}
\alias{\%g\%.mdate}
\alias{\%ge\%}
\alias{\%ge\%.mdate}
\alias{\%le\%}
\alias{\%le\%.mdate}
\alias{\%><\%}
\alias{\%><\%.mdate}
\alias{\%>=<\%}
\alias{\%>=<\%.mdate}
\title{Proportion of messy dates meeting logical test}
\usage{
e1 \%l\% e2

\method{\%l\%}{mdate}(e1, e2)

e1 \%g\% e2

\method{\%g\%}{mdate}(e1, e2)

e1 \%ge\% e2

\method{\%ge\%}{mdate}(e1, e2)

e1 \%le\% e2

\method{\%le\%}{mdate}(e1, e2)

e1 \%><\% e2

\method{\%><\%}{mdate}(e1, e2)

e1 \%>=<\% e2

\method{\%>=<\%}{mdate}(e1, e2)
}
\arguments{
\item{e1, e2}{\code{mdate} or other class objects}
}
\value{
The proportion that the comparison is true.

A logical vector the same length as the \code{mdate} passed.
}
\description{
These functions provide various proportional tests for messy date objects.
}
\section{Functions}{
\itemize{
\item \code{ \%l\% }: Tests proportion of dates in the first vector
that precede the minimum in the second vector.

\item \code{ \%g\% }: Tests proportion of dates in the first vector
that follow the maximum in the second vector.

\item \code{ \%ge\% }: Tests proportion of dates in the first vector
that follow or are equal to the maximum in the second vector.

\item \code{ \%le\% }: Tests proportion of dates in the first vector
that precede or are equal to the minimum in the second vector.

\item \code{ \%><\% }: Tests proportion of dates in the first vector
that are between the minimum and maximum dates in the second vector.

\item \code{ \%>=<\% }: Tests proportion of dates in the first vector that
are between the minimum and maximum dates in the second vector, inclusive.

}}
\examples{
  as_messydate("2012-06") < as.Date("2012-06-02")
  as_messydate("2012-06") \%l\% as_messydate("2012-06-02")
  as_messydate("2012-06") > as.Date("2012-06-02")
  as_messydate("2012-06") \%g\% as_messydate("2012-06-02")
  as_messydate("2012-06") >= as.Date("2012-06-02")
  as_messydate("2012-06") \%ge\% as_messydate("2012-06-02")
  as_messydate("2012-06") <= as.Date("2012-06-02")
  as_messydate("2012-06") \%le\% "2012-06-02"
  as_messydate("2012-06") \%><\% as_messydate("2012-06-15..2012-07-15")
  as_messydate("2012-06") \%>=<\% as_messydate("2012-06-15..2012-07-15")
}
