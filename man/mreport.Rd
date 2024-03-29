% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report.R
\name{mreport}
\alias{mreport}
\title{Data report for datasets with 'mdate' variables}
\usage{
mreport(data)
}
\arguments{
\item{data}{A \code{{tibble}} or a \code{{data.frame}}.}
}
\value{
A data report of class 'mreport'.
}
\description{
Create a properly formatted data report for datasets which contain 'mdate'
class objects, alongside other object classes.
}
\details{
'mreport' displays the variable's name,
the variable type, the number of observations per variable,
the number of missing observations for variable,
and the percentage of missing observations in variable.
}
\examples{
mreport(battles)
}
