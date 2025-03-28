#' Proportion of messy dates meeting logical test
#' @description
#'   These functions provide various proportional tests for messy date objects.
#' @name operate_proportional
#' @param e1,e2 `mdate` or other class objects
#' @return The proportion that the comparison is true.
#' @return A logical vector the same length as the `mdate` passed.
NULL

#' @rdname operate_proportional
#' @export
`%l%` <- function(e1, e2) UseMethod("%l%")

#' @describeIn operate_proportional Tests proportion of dates in the first vector
#'   that precede the minimum in the second vector.
#' @examples
#'   as_messydate("2012-06") < as.Date("2012-06-02")
#'   as_messydate("2012-06") %l% as_messydate("2012-06-02")
#' @export
`%l%.mdate` <- function(e1, e2) {
  if(length(e1)!=length(e2))
    stop("Can only compare vectors of equal length.")
  # Need to fix this for element wise on vectors...
  suppressMessages(purrr::map2_dbl(expand(e1), expand(e2),
                                   ~ mean(.x < min(.y))))
}

evalqOnLoad({
  registerS3method("%l%", "Date", `%l%.mdate`)
  registerS3method("%l%", "POSIXt", `%l%.mdate`)
})

#' @rdname operate_proportional
#' @export
`%g%` <- function(e1, e2) UseMethod("%g%")

#' @describeIn operate_proportional Tests proportion of dates in the first vector
#'   that follow the maximum in the second vector.
#' @export
#' @examples
#'   as_messydate("2012-06") > as.Date("2012-06-02")
#'   as_messydate("2012-06") %g% as_messydate("2012-06-02")
`%g%.mdate` <- function(e1, e2) {
  if(length(e1)!=length(e2))
    stop("Can only compare vectors of equal length.")
  # Need to fix this for element wise on vectors...
  suppressMessages(purrr::map2_dbl(expand(e1), expand(e2),
                                   ~ mean(.x > max(.y))))
}

evalqOnLoad({
  registerS3method("%g%", "Date", `%g%.mdate`)
  registerS3method("%g%", "POSIXt", `%g%.mdate`)
})

#' @rdname operate_proportional
#' @export
`%ge%` <- function(e1, e2) UseMethod("%ge%")

#' @describeIn operate_proportional Tests proportion of dates in the first vector
#'   that follow or are equal to the maximum in the second vector.
#' @export
#' @examples
#'   as_messydate("2012-06") >= as.Date("2012-06-02")
#'   as_messydate("2012-06") %ge% as_messydate("2012-06-02")
`%ge%.mdate` <- function(e1, e2) {
  if(length(e1)!=length(e2))
    stop("Can only compare vectors of equal length.")
  # Need to fix this for element wise on vectors...
  suppressMessages(purrr::map2_dbl(expand(e1), expand(e2),
                                   ~ mean(.x >= max(.y))))
}

evalqOnLoad({
  registerS3method("%ge%", "Date", `%ge%.mdate`)
  registerS3method("%ge%", "POSIXt", `%ge%.mdate`)
})

#' @rdname operate_proportional
#' @export
`%le%` <- function(e1, e2) UseMethod("%le%")

#' @describeIn operate_proportional Tests proportion of dates in the first vector
#'   that precede or are equal to the minimum in the second vector.
#' @export
#' @examples
#'   as_messydate("2012-06") <= as.Date("2012-06-02")
#'   as_messydate("2012-06") %le% "2012-06-02"
`%le%.mdate` <- function(e1, e2) {
  if(length(e1)!=length(e2))
    stop("Can only compare vectors of equal length.")
  # Need to fix this for element wise on vectors...
  suppressMessages(purrr::map2_dbl(expand(e1), expand(e2),
                                   ~ mean(.x <= min(.y))))
}

evalqOnLoad({
  registerS3method("%le%", "Date", `%le%.mdate`)
  registerS3method("%le%", "POSIXt", `%le%.mdate`)
})

#' @rdname operate_proportional
#' @export
`%><%` <- function(e1, e2) UseMethod("%><%")

#' @describeIn operate_proportional Tests proportion of dates in the first vector
#'   that are between the minimum and maximum dates in the second vector.
#' @export
#' @examples
#'   as_messydate("2012-06") %><% as_messydate("2012-06-15..2012-07-15")
`%><%.mdate` <- function(e1, e2) {
  if(length(e1)!=length(e2))
    stop("Can only compare vectors of equal length.")
  # Need to fix this for element wise on vectors...
  # Need to create fast way to trim ranges or just get dates within the range
  suppressMessages(purrr::map2_dbl(e1, e2,
                  ~ length(.x %intersect% .y)/
                    (length(unlist(expand(.x)))+1)))
}

evalqOnLoad({
  registerS3method("%><%", "Date", `%><%.mdate`)
  registerS3method("%><%", "POSIXt", `%><%.mdate`)
})

#' @rdname operate_proportional
#' @export
`%>=<%` <- function(e1, e2) UseMethod("%>=<%")

#' @describeIn operate_proportional Tests proportion of dates in the first vector that
#'   are between the minimum and maximum dates in the second vector, inclusive.
#' @export
#' @examples
#'   as_messydate("2012-06") %>=<% as_messydate("2012-06-15..2012-07-15")
`%>=<%.mdate` <- function(e1, e2) {
  if(length(e1)!=length(e2))
    stop("Can only compare vectors of equal length.")
  # Need to fix this for element wise on vectors...
  suppressMessages(purrr::map2_dbl(e1, e2, ~ length(.x %intersect% .y)/
                                     length(unlist(expand(.x)))))
}

evalqOnLoad({
  registerS3method("%>=<%", "Date", `%>=<%.mdate`)
  registerS3method("%>=<%", "POSIXt", `%>=<%.mdate`)
})
