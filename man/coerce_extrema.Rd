% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coerce_extrema.R
\name{coerce_extrema}
\alias{coerce_extrema}
\alias{vmin}
\alias{vmin.mdate}
\alias{min.mdate}
\alias{vmax}
\alias{vmax.mdate}
\alias{max.mdate}
\title{Resolves messy dates into an extrema}
\usage{
vmin(..., na.rm = FALSE)

\method{vmin}{mdate}(..., na.rm = TRUE)

\method{min}{mdate}(..., na.rm = TRUE)

vmax(..., na.rm = FALSE)

\method{vmax}{mdate}(..., na.rm = TRUE)

\method{max}{mdate}(..., na.rm = TRUE)
}
\arguments{
\item{...}{a mdate object}

\item{na.rm}{Should NAs be removed? True by default.}
}
\value{
A single scalar or vector of dates
}
\description{
This collection of S3 methods 'resolve' messy dates into a single date
according to some explicit bias,
such as returning the minimum or maximum date,
the mean, median, or modal date,
or a random date from among the possible resolutions for each messy date.
If the date is not 'messy' (i.e. has no annotations)
then just that precise date is returned.
This can be useful for various descriptive or inferential projects.
}
\examples{
d <- as_messydate(c("2008-03-25", "?2012-02-27", "2001-01?", "2001~",
  "2001-01-01..2001-02-02", "{2001-01-01,2001-02-02}",
  "{2001-01,2001-02-02}", "2008-XX-31", "-0050-01-01"))
d
vmin(d)
min(d)
vmax(d)
max(d)
}
