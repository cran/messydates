% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class_mdate.R
\name{class_create}
\alias{class_create}
\alias{new_messydate}
\alias{validate_messydate}
\title{A flexible date class for messy dates}
\usage{
new_messydate(x = character())

validate_messydate(x)
}
\arguments{
\item{x}{A character scalar or vector in the expected \code{"yyyy-mm-dd"} format
annotated, as necessary, according to ISO 8601-2_2019(E).}
}
\value{
Object of class \code{mdate}
}
\description{
Recent extensions to standardised date notation in
\href{https://www.iso.org/standard/70908.html}{ISO 8601-2_2019(E)}
create space for unspecified, uncertain, and approximate dates,
as well as succinct representation of ranges of dates.
These functions create and validate a new date class for R
that can contain and parse these annotations,
and are not typically user-facing.
Please see \code{as_messydate()} for the user-facing coercion function.
}
\section{Date annotations}{

\emph{Unspecified date components}, such as when the day is unknown,
can be represented by one or more \code{X}s in place of the digits.
The modifier \code{*} is recommended to indicate that the entire
time scale component value is unspecified, e.g. \code{X*-03-03},
however this is not implemented here.
Please be explicit about the digits that are unspecified,
e.g. \code{XXXX-03-03} expresses 3rd March in some unspecified year,
whereas \code{2003-XX-03} expresses the 3rd of some month in 2003.
If time components are not given, they are expanded to this.

\emph{Approximate date components}, modified by \code{~},
represent an estimate whose value is asserted
to be possibly correct.
For example, \code{2003~-03-03}
The degree of confidence in approximation
depends on the application.

\emph{Uncertain date components}, modified by \verb{?},
represent a date component whose source is considered
to be dubious and therefore not to be relied upon.
An additional modifier, \verb{\%}, is used to indicate
a value that is both uncertain and approximate.
}

\section{Date sets}{

These functions also introduce standard notation
for ranges of dates.
Rather than the typical R notation for ranges,
\code{:}, ISO 8601-2_2019(E) recommends \code{..}.
This then can be applied between two time scale
components to create a standard range between
these dates (inclusive), e.g. \verb{2009-01-01..2019-01-01}.
But it can also be used as an affix,
indicating "on or before" if used as a prefix,
e.g. \code{..2019-01-01},
or indicating "on or after" if used as a suffix,
e.g. \verb{2009-01-01..}.

And lastly, notation for sets of dates is also included.
Here braces, \code{{}}, are used to mean "all members of the set",
while brackets, \verb{[]}, are used to mean "one member of the set".
}

\seealso{
messydate
}
