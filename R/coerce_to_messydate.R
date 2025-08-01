#' Coercion from regular date classes to mdate
#' @description
#'   These methods coerce various date classes into the `mdate` class.
#'   They represent the main user-facing class-creating functions in the package.
#'   In addition to the typical date classes in R (`Date`, `POSIXct`, and `POSIXlt`),
#'   there is also a direct method for converting text or character strings to `mdate`.
#'   The function can also extract dates from text,
#'   though this is a work-in-progress and currently only works in English.
#' @param x A scalar or vector of a class that can be coerced into `mdate`,
#'   such as `Date`, `POSIXct`, `POSIXlt`, or character.
#' @param resequence Users have the option to choose the order for
#'   ambiguous dates with or without separators (e.g. "11-01-12" or "20112112").
#'   `NULL` by default.
#'   Other options include: 'dmy', 'ymd', 'mdy', 'ym', 'my' and 'interactive'
#'   If 'dmy', dates are converted from DDMMYY format for 6 digit dates,
#'   or DDMMYYYY format for 8 digit dates.
#'   If 'ymd', dates are converted from YYMMDD format for 6 digit dates,
#'   or YYYYMMDD format for 8 digit dates.
#'   If 'mdy', dates are converted from MMDDYY format for 6 digit dates
#'   or MMDDYYYY format for 8 digit dates.
#'   For these three options, ambiguous dates are converted to YY-MM-DD format
#'   for 6 digit dates, or YYYY-MM-DD format for 8 digit dates.
#'   If 'my', ambiguous 6 digit dates are converted from MM-YYYY format
#'   to YYYY-MM.
#'   If 'ym', ambiguous 6 digit dates are converted to YYYY-MM format.
#'   If 'interactive', it prompts users to select the existing
#'   component order of ambiguous dates,
#'   based on which the date is reordered into YYYY-MM-DD format
#'   and further completed to YYYY-MM-DD format if they choose to do so.
#' @return A `mdate` class object
#' @name coerce_to
NULL

#' @describeIn coerce_to Core `mdate` class coercion function
#' @examples
#' as_messydate("2021")
#' as_messydate("2021-02")
#' as_messydate("2021-02-01")
#' as_messydate("01-02-2021")
#' as_messydate("1 February 2021")
#' as_messydate("First of February, two thousand and twenty-one")
#' as_messydate("2021-02-01?")
#' as_messydate("2021-02-01~")
#' as_messydate("2021-02-01%")
#' as_messydate("2021-02-01..2021-02-28")
#' as_messydate("{2021-02-01,2021-02-28}")
#' as_messydate(c("-2021", "2021 BC", "-2021-02-01"))
#' as_messydate(c("210201", "20210201"), resequence = "ymd")
#' as_messydate(c("010221", "01022021"), resequence = "dmy")
#' # as_messydate(c("01-02-21", "01-02-2021", "01-02-91", "01-02-1991"),
#' # resequence = "interactive")
#' @export
as_messydate <- function(x, resequence = FALSE)
  UseMethod("as_messydate")

#' @describeIn coerce_to Coerce from `Date` to `mdate` class
#' @export
as_messydate.Date <- function(x, resequence = FALSE) {
  x <- as.character(x)
  new_messydate(x)
}

#' @describeIn coerce_to Coerce from `POSIXct` to `mdate` class
#' @export
as_messydate.POSIXct <- function(x, resequence = FALSE) {
  if(any(is.infinite(x))) x[is.infinite(x)] <- "9999-12-31"
  x <- as.character(as.Date(x))
  new_messydate(x)
}

#' @describeIn coerce_to Coerce from `POSIXlt` to `mdate` class
#' @export
as_messydate.POSIXlt <- function(x, resequence = FALSE) {
  if(any(is.infinite(x))) x[is.infinite(x)] <- "9999-12-31"
  x <- as.character(as.Date(x))
  new_messydate(x)
}

#' @export
as_messydate.mdate <- function(x, resequence = FALSE) {
  x <- as.character(x) # For updating 'mdate' variables
  new_messydate(x)
}

#' @describeIn coerce_to Coerce character date objects to `mdate` class
#' @export
as_messydate.character <- function(x, resequence = NULL) {
  if(any(is.infinite(x))) x[is.infinite(x)] <- "9999-12-31"
  d <- standardise_text(x)
  d <- standardise_date_separators(d)
  if (!is.null(resequence)) {
    if (resequence == "dmy") {
      d <- daymonthyear(d)
    } else if (resequence == "ymd") {
      d <- yearmonthday(d)
    } else if (resequence == "ym") {
      d <- yearmonth(d)
    } else if (resequence == "my") {
      d <- monthyear(d)
    } else if (resequence == "mdy") {
      d <- monthdayyear(d)
    } else if (isTRUE(resequence == "interactive")) {
      d <- ask_user(d)
    }
  }
  d <- standardise_date_order(d)
  d <- standardise_unspecifieds(d)
  d <- standardise_date_input(d)
  d <- standardise_widths(d)
  new_messydate(d)
}

#' @describeIn coerce_to Coerce numeric objects to `mdate` class
#' @export
as_messydate.numeric <- function(x, resequence = NULL) {
  if(any(is.infinite(x))) x[is.infinite(x)] <- "9999-12-31"
  d <- as.character(x)
  new_messydate(d)
}

#' @describeIn coerce_to Coerce list date objects to the most concise
#' representation of `mdate` class
#' @examples
#' as_messydate(list(c("2012-06-01", "2012-06-02", "2012-06-03")))
#' as_messydate(list(c("2012-06-01", "2012-06-02", "2012-06-03",
#' "{2012-06-01, 2012-06-02, 2012-06-03}", "2012-06-01", "2012-06-03")))
#' @export
as_messydate.list <- function(x, resequence = FALSE) {
  lapply(x, function (y) {
    suppressMessages(contract(paste(new_messydate(as.character(y)),
                                    collapse = ",")))
  })
}

#' @rdname coerce_to
#' @export
mdate <- as_messydate

# Helper functions ####
#' @importFrom stringi stri_detect_regex
standardise_text <- function(v) {
  dates <- ifelse(stringi::stri_detect_regex(v, "([:alpha:]{4})") &
                    !grepl("bce$|^XXXX|XXXX$", v, ignore.case = TRUE),
                  extract_from_text(v), v)
  dates <- ifelse(grepl("Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec",
                        dates, ignore.case = TRUE),
                  written_month(dates), dates)
  dates
}

#' @importFrom stringi stri_replace_all_regex
standardise_date_separators <- function(dates) {
  dates <- stringi::stri_replace_all_regex(dates,
                                    "(?<=[:digit:])\\.(?=[:digit:])", "-")
  dates <- stringi::stri_replace_all_regex(dates, "\\/", "-")
  dates <- stringi::stri_replace_all_regex(dates, "\\(|\\)|\\{|\\}|\\[|\\]", "")
  dates <- stringi::stri_trim_both(dates)
  # Adds zero padding to days, months, sets, and ranges
  dates <- stringi::stri_replace_all_regex(dates, "-([:digit:])-", "-0$1-")
  dates <- stringi::stri_replace_all_regex(dates, "([:digit:]{2})-([:digit:])$",
                                    "$1-0$2")
  dates <- stringi::stri_replace_all_regex(dates, "^([:digit:])-([:digit:]{2})",
                                    "0$1-$2")
  dates <- stringi::stri_replace_all_regex(dates, "\\_|\\:", "..") # range separators
  dates <- stringi::stri_replace_all_regex(dates, "-([:digit:])\\.\\.", "-0$1\\.\\.")
  dates <- stringi::stri_replace_all_regex(dates, "\\.\\.([:digit:])-", "\\.\\.0$1-")
  dates <- stringi::stri_replace_all_regex(dates, " \\, |\\, | \\,", ",") # set separators
  dates <- stringi::stri_replace_all_regex(dates, "-([:digit:]),", "-0$1,")
  dates <- stringi::stri_replace_all_regex(dates, ",([:digit:])-", "\\,0$1-")
  dates
}

daymonthyear <- function(dates) {
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "^[:digit:]{2}-"))) < 32 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}-"))) < 32 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "[:digit:]{2}$"))) < 32,
                  stringi::stri_replace_all_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2}$)",
                                           "$3-$2-$1"), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{8})$"),
                  paste0(substr(dates, 5, 8), "-", substr(dates, 3, 4), "-",
                         substr(dates, 1, 2)), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{6})$"),
                  paste0(substr(dates, 5, 6), "-", substr(dates, 3, 4), "-",
                         substr(dates, 1, 2)), dates)
  dates
}

yearmonthday <- function(dates) {
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{8})$"),
                  paste0(substr(dates, 1, 4), "-", substr(dates, 5, 6), "-",
                         substr(dates, 7, 8)), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{6})$"),
                  paste0(substr(dates, 1, 2), "-", substr(dates, 3, 4), "-",
                         substr(dates, 5, 6)), dates)
  dates
}

yearmonth <- function(dates) {
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{6})$"),
                  paste0(substr(dates, 1, 4), "-", substr(dates, 5, 6)), dates)
  dates
}

monthyear <- function(dates) {
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{6})$"),
                  paste0(substr(dates, 3, 6), "-", substr(dates, 1, 2)), dates)
  dates
}

monthdayyear <- function(dates) {
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "^[:digit:]{2}-"))) < 32 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}-"))) < 32 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "[:digit:]{2}$"))) < 32,
                  stringi::stri_replace_all_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2}$)",
                                           "$3-$1-$2"), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{8})$"),
                  paste0(substr(dates, 5, 8), "-", substr(dates, 1, 2), "-",
                         substr(dates, 3, 4)), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{6})$"),
                  paste0(substr(dates, 5, 6), "-", substr(dates, 1, 2), "-",
                         substr(dates, 3, 4)), dates)
  dates
}

standardise_date_order <- function(dates) {
  # if resequence argument is not specified, assumes ymd format
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{8})$"),
                  paste0(substr(dates, 1, 4), "-", substr(dates, 5, 6), "-",
                         substr(dates, 7, 8)), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{6})$"),
                  paste0(substr(dates, 1, 2), "-", substr(dates, 3, 4), "-",
                         substr(dates, 5, 6)), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{4})-([:digit:]{2})-([:digit:]{2}$)") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}-"))) > 12,
                  stringi::stri_replace_all_regex(dates, "^([:digit:]{4})-([:digit:]{2})-([:digit:]{2}$)",
                                           "$1-$3-$2"), dates)
  # detects and reorders inconsistencies
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{4}$)") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}-"))) > 12,
                  stringi::stri_replace_all_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{4}$)",
                                           "$3-$1-$2"),
                  stringi::stri_replace_all_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{4}$)",
                                           "$3-$2-$1"))
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2}$)") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}-"))) < 13 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}$"))) > 31,
                  stringi::stri_replace_all_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2}$)",
                                           "$3-$2-$1"), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2}$)") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}-"))) > 12 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}$"))) > 31,
                  stringi::stri_replace_all_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2}$)",
                                           "$3-$1-$2"), dates)
  dates
}

ask_user <- function(dates) {
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "^[:digit:]{2}-"))) < 32 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "-[:digit:]{2}-"))) < 32 &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "[:digit:]{2}$"))) < 32,
                  reorder_ambiguous(dates), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "^[:digit:]{2}-"))) < 23,
                  complete_ambiguous_20(dates), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$") &
                    as.numeric(gsub("-", "", stringi::stri_extract_first_regex(dates, "^[:digit:]{2}-"))) > 22,
                  complete_ambiguous_19(dates), dates)
  dates
}

standardise_unspecifieds <- function(dates) {
  dates <- stringi::stri_replace_all_regex(dates, "^NA", "XXXX")
  dates <- stringi::stri_replace_all_regex(dates, "-NA", "-XX")
  dates <- stringi::stri_replace_all_regex(dates, "0000", "XXXX")
  dates <- stringi::stri_replace_all_regex(dates, "-00-|-0-|-0$|-00$|-\\?\\?-", "-XX-")
  dates <- stringi::stri_replace_all_regex(dates, "\\?\\?\\?\\?", "XXXX")
  dates <- stringi::stri_replace_all_regex(dates, "^(XX)-([:digit:]{4}$)", "$2")
  dates <- stringi::stri_replace_all_regex(dates, "^(XX)-(XX)-([:digit:]{4}$)", "$3")
  dates <- stringi::stri_replace_all_regex(dates, "^(XX)-([:digit:]{2})-([:digit:]{4}$)",
                                    "$3-$2")
  dates <- stringi::stri_replace_all_regex(dates, "^([:digit:]{2})-([:digit:]{2})-(XXXX$)",
                                    "$3-$2-$1")
  dates <- stringi::stri_replace_all_regex(dates, "-X-X$|-XX-XX$|-XX$|-XX-\\?\\?$|
                                    |-\\?-\\?$|-\\?\\?$|-\\?\\?-\\?\\?$", "")
  dates <- stringi::stri_replace_all_regex(dates, "-XX\\,", ",")
  dates <- stringi::stri_replace_all_regex(dates, "-XX\\.\\.", "..")
  dates <- ifelse(stringi::stri_detect_regex(dates, "^[:digit:]{4}\\~$"),
                  paste0("~", stringi::stri_replace_all_regex(dates, "\\~", "")), dates)
  dates
}

# BC/AD ####

standardise_date_input <- function(dates) {
  dates <- ifelse(stringi::stri_detect_regex(dates, "(BCE|Bce|bce|bc|BC|Bc|bC)"),
                  as_bc_dates(dates), dates)
  dates <- stringi::stri_replace_all_regex(dates, "(ad|AD|Ad|aD|CE|Ce|ce|AC|ac|Ac|aC)", "")
  dates <- stringi::stri_trim_both(dates)
  dates
}

as_bc_dates <- function(dates) {
  dates <- ifelse(stringi::stri_count_regex(dates, "(BCE|Bce|bce|bc|BC|Bc|bC)") == 2,
                  st_negative_range(dates), dates)
  dates <- ifelse(stringi::stri_count_regex(dates, "(BCE|Bce|bce|bc|BC|Bc|bC)") > 2,
                  st_negative_sets(dates), dates)
  dates <- ifelse(stringi::stri_count_regex(dates, "(BCE|Bce|bce|bc|BC|Bc|bC)") == 1,
                  st_negative(dates), dates)
}

st_negative_range <- function(dates) {
  dates <- stringi::stri_replace_all_regex(dates, "(BCE|Bce|bce|bc|BC|Bc|bC)", "")
  dates <- gsub(" ", "", dates)
  dates <- paste0("-", strsplit(dates, "\\.\\.")[[1]][1],
                  "..-", strsplit(dates, "\\.\\.")[[1]][2])
}

st_negative_sets <- function(dates) {
  dates <- stringi::stri_replace_all_regex(dates, "(BCE|Bce|bce|bc|BC|Bc|bC)", "")
  dates <- gsub(" ", "", dates)
  dates <- unlist(strsplit(dates, "\\,"))
  dates <- ifelse(length(dates) > 1,
                  paste0("-", paste(dates, collapse = ", -")),
                  paste0("-", dates))
}

st_negative <- function(dates) {
  dates <- stringi::stri_replace_all_regex(dates, "(BCE|Bce|bce|bc|BC|Bc|bC)", "")
  dates <- stringi::stri_trim_both(dates)
  dates <- paste0("-", dates)
}

# Widths ####

standardise_widths <- function(dates) {
  dates <- add_zero_padding(dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "([:digit:]{1})\\.\\.([:digit:]{1})|([:digit:]{1})\\.\\.-"),
                  add_zero_range(dates), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "\\,"),
                  add_zero_set(dates), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates, "\\,"),
                  paste0("{", dates, "}"), dates)
  dates <- stringi::stri_replace_all_regex(dates, "-([:digit:])$", "-0$1")
  dates <- stringi::stri_replace_all_regex(dates, "^([:digit:])-", "0$1-")
  dates <- stringi::stri_trim_both(dates)
  dates
}

add_zero_padding <- function(dates) {
  # Year padding (positive or negative)
  dates <- stringi::stri_replace_all_regex(dates, "^(-?)([:digit:]{1})($|-)", "$1000$2$3")
  dates <- stringi::stri_replace_all_regex(dates, "^(-?)([:digit:]{2})($|-)", "$100$2$3")
  dates <- stringi::stri_replace_all_regex(dates, "^(-?)([:digit:]{3})($|-)", "$10$2$3")
  # Uncertain and approximate year only
  dates <- stringi::stri_replace_all_regex(dates, "^~([:digit:]{1})$", "000$1~")
  dates <- stringi::stri_replace_all_regex(dates, "^~([:digit:]{2})$", "00$1~")
  dates <- stringi::stri_replace_all_regex(dates, "^~([:digit:]{3})$", "0$1~")
  dates <- stringi::stri_replace_all_regex(dates, "^\\?([:digit:]{1})$", "000$1?")
  dates <- stringi::stri_replace_all_regex(dates, "^\\?([:digit:]{2})$", "00$1?")
  dates <- stringi::stri_replace_all_regex(dates, "^\\?([:digit:]{3})$", "0$1?")
  dates <- ifelse(stringi::stri_detect_regex(dates,
                                      "^([:digit:]{1})~$|^([:digit:]{1})\\?$"),
                  paste0("000", dates), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates,
                                      "^([:digit:]{2})~$|^([:digit:]{2})\\?$"),
                  paste0("00", dates), dates)
  dates <- ifelse(stringi::stri_detect_regex(dates,
                                      "^([:digit:]{3})~$|^([:digit:]{3})\\?$|^([:digit:]{3})-([:digit:]{2}$)"),
                  paste0("0", dates), dates)
  # Year only
  dates <- stringi::stri_replace_all_regex(dates, "^([:digit:]{1})$", "000$1")
  dates <- stringi::stri_replace_all_regex(dates, "^([:digit:]{2})$", "00$1")
  dates <- stringi::stri_replace_all_regex(dates, "^([:digit:]{3})$", "0$1")
  dates
}

add_zero_range <- function(dates) {
  dates <- strsplit(dates, "\\.\\.")
  dates <- lapply(dates, function(x) {
    x <- gsub(" ", "", x)
    x <- stringi::stri_replace_all_regex(x, "^-([:digit:]{1})$", "-000$1")
    x <- stringi::stri_replace_all_regex(x, "^-([:digit:]{2})$", "-00$1")
    x <- stringi::stri_replace_all_regex(x, "^-([:digit:]{3})$", "-0$1")
    x <- stringi::stri_replace_all_regex(x, "^~([:digit:]{1})$", "000$1~")
    x <- stringi::stri_replace_all_regex(x, "^~([:digit:]{2})$", "00$1~")
    x <- stringi::stri_replace_all_regex(x, "^~([:digit:]{3})$", "0$1~")
    x <- stringi::stri_replace_all_regex(x, "^\\?([:digit:]{1})$", "000$1?")
    x <- stringi::stri_replace_all_regex(x, "^\\?([:digit:]{2})$", "00$1?")
    x <- stringi::stri_replace_all_regex(x, "^\\?([:digit:]{3})$", "0$1?")
    x <- stringi::stri_replace_all_regex(x, "^([:digit:]{1})$", "000$1")
    x <- stringi::stri_replace_all_regex(x, "^([:digit:]{2})$", "00$1")
    x <- stringi::stri_replace_all_regex(x, "^([:digit:]{3})$", "0$1")
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{1})~$|^([:digit:]{1})\\?$"),
                paste0("000", x), x)
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{2})~$|^([:digit:]{2})\\?$"),
                paste0("00", x), x)
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{3})~$|^([:digit:]{3})\\?$"),
                paste0("0", x), x)
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{1})~$|^([:digit:]{1})\\?$"),
                paste0("000", x), x)
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{2})~$|^([:digit:]{2})\\?$"),
                paste0("00", x), x)
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{3})~$|^([:digit:]{3})\\?$|^([:digit:]{3})-([:digit:]{2}$)"),
                paste0("0", x), x)
  })
  dates <- purrr::map_chr(dates, paste, collapse = "..")
  dates
}

add_zero_set <- function(dates) {
  dates <- strsplit(dates, "\\,")
  dates <- lapply(dates, function(x) {
    x <- gsub(" ", "", x)
    x <- stringi::stri_replace_all_regex(x, "^-([:digit:]{1})$", "-000$1")
    x <- stringi::stri_replace_all_regex(x, "^-([:digit:]{2})$", "-00$1")
    x <- stringi::stri_replace_all_regex(x, "^-([:digit:]{3})$", "-0$1")
    x <- stringi::stri_replace_all_regex(x, "^~([:digit:]{1})$", "000$1~")
    x <- stringi::stri_replace_all_regex(x, "^~([:digit:]{2})$", "00$1~")
    x <- stringi::stri_replace_all_regex(x, "^~([:digit:]{3})$", "0$1~")
    x <- stringi::stri_replace_all_regex(x, "^\\?([:digit:]{1})$", "000$1?")
    x <- stringi::stri_replace_all_regex(x, "^\\?([:digit:]{2})$", "00$1?")
    x <- stringi::stri_replace_all_regex(x, "^\\?([:digit:]{3})$", "0$1?")
    x <- stringi::stri_replace_all_regex(x, "^([:digit:]{1})$", "000$1")
    x <- stringi::stri_replace_all_regex(x, "^([:digit:]{2})$", "00$1")
    x <- stringi::stri_replace_all_regex(x, "^([:digit:]{3})$", "0$1")
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{1})~$|^([:digit:]{1})\\?$"),
                paste0("000", x), x)
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{2})~$|^([:digit:]{2})\\?$"),
                paste0("00", x), x)
    x <- ifelse(stringi::stri_detect_regex(x, "^([:digit:]{3})~$|^([:digit:]{3})\\?$|^([:digit:]{3})-([:digit:]{2}$)"),
                paste0("0", x), x)
  })
  dates <- purrr::map_chr(dates, paste, collapse = ",")
  dates
}

extract_from_text <- function(v) {
  # get ordinal and numeric dates spelled and replace in text
  out <- stri_squish(stringi::stri_replace_all_regex(v, "\\,|\\.|of | on | and|the | this|
                                  | day|year|month", " "))
  #reorder American dates
  if(length(out)==1 && grepl("^[A-z]", out)){
    out <- paste(stringi::stri_split_fixed(out, " ")[[1]][c(2,1,3)],
             collapse = " ")
  }

  for (k in seq_len(nrow(text_to_number))) {
    out <- gsub(paste0(text_to_number$text[k]),
                paste0(text_to_number$numeric[k]),
                out, ignore.case = TRUE,
                perl = T)
  }
  # get the months into date form
  months <- data.frame(months = c("january", "february", "march", "april",
                                  "may", "june", "july", "august", "september",
                                  "october", "november", "december"),
                       numeric = c("-01-", "-02-", "-03-", "-04-", "-05-",
                                   "-06-", "-07-", "-08-", "-09-", "-10-",
                                   "-11-", "-12-"))
  for (k in seq_len(nrow(months))) {
    out <- gsub(paste0(months$months[k]),
                paste0(months$numeric[k]),
                out, ignore.case = TRUE,
                perl = T)
  }
  # correct double white space left and standardize separators
  out <- stri_squish(stringi::stri_replace_all_regex(out, "- -| -|- |/", "-"))
  # get the first date per row
  out <- stringi::stri_extract_first_regex(out,
                              "^[:digit:]{2}-[:digit:]{2}-[:digit:]{2}$|
                              |^[:digit:]{1}-[:digit:]{2}-[:digit:]{2}$|
                              |^[:digit:]{2}-[:digit:]{1}-[:digit:]{2}$|
                              |^[:digit:]{1}-[:digit:]{1}-[:digit:]{2}$|
                              |[:digit:]{4}-[:digit:]{2}-[:digit:]{2}|
                              |[:digit:]{4}-[:digit:]{2}-[:digit:]{1}|
                              |[:digit:]{4}-[:digit:]{1}-[:digit:]{2}|
                              |[:digit:]{4}-[:digit:]{1}-[:digit:]{1}|
                              |[:digit:]{2}-[:digit:]{2}-[:digit:]{4}|
                              |[:digit:]{1}-[:digit:]{2}-[:digit:]{4}|
                              |[:digit:]{2}-[:digit:]{1}-[:digit:]{4}|
                              |[:digit:]{1}-[:digit:]{1}-[:digit:]{4}")
  out
}

written_month <- function(dates) {
  dates <- stri_squish(stringi::stri_replace_all_regex(tolower(dates),
                                                        ",|-", " "))
  dates <- stringi::stri_replace_all_regex(dates,
                                    "([:alpha:]{3}) ([:digit:]{1,2}) ([:digit:]{4})",
                                    "$3 $1 $2")
  dates <- stringi::stri_replace_all_regex(dates,
                                    "([:digit:]{4}) ([:digit:]{1,2}) ([:alpha:]{3})",
                                    "$1 $3 $2")
  dates <- stringi::stri_replace_all_regex(dates, " jan ", "-01-")
  dates <- stringi::stri_replace_all_regex(dates, " feb ", "-02-")
  dates <- stringi::stri_replace_all_regex(dates, " mar ", "-03-")
  dates <- stringi::stri_replace_all_regex(dates, " apr ", "-04-")
  dates <- stringi::stri_replace_all_regex(dates, " may ", "-05-")
  dates <- stringi::stri_replace_all_regex(dates, " jun ", "-06-")
  dates <- stringi::stri_replace_all_regex(dates, " jul ", "-07-")
  dates <- stringi::stri_replace_all_regex(dates, " aug ", "-08-")
  dates <- stringi::stri_replace_all_regex(dates, " sep ", "-09-")
  dates <- stringi::stri_replace_all_regex(dates, " oct ", "-10-")
  dates <- stringi::stri_replace_all_regex(dates, " nov ", "-11-")
  dates <- stringi::stri_replace_all_regex(dates, " dec ", "-12-")
  # 6 digit my or ym dates
  dates <- stringi::stri_replace_all_regex(dates,
                                    "([:alpha:]{3}) ([:digit:]{4})",
                                    "$2 $1")
  dates <- stringi::stri_replace_all_regex(dates, " jan$", "-01")
  dates <- stringi::stri_replace_all_regex(dates, " feb$", "-02")
  dates <- stringi::stri_replace_all_regex(dates, " mar$", "-03")
  dates <- stringi::stri_replace_all_regex(dates, " apr$", "-04")
  dates <- stringi::stri_replace_all_regex(dates, " may$", "-05")
  dates <- stringi::stri_replace_all_regex(dates, " jun$", "-06")
  dates <- stringi::stri_replace_all_regex(dates, " jul$", "-07")
  dates <- stringi::stri_replace_all_regex(dates, " aug$", "-08")
  dates <- stringi::stri_replace_all_regex(dates, " sep$", "-09")
  dates <- stringi::stri_replace_all_regex(dates, " oct$", "-10")
  dates <- stringi::stri_replace_all_regex(dates, " nov$", "-11")
  dates <- stringi::stri_replace_all_regex(dates, " dec$", "-12")
  dates
}

reorder_ambiguous <- function(d) {
  examples <- ifelse(as.numeric(gsub("-", "", stringi::stri_extract_first_regex(d, "^[:digit:]{2}-"))) < 32 &
                       as.numeric(gsub("-", "", stringi::stri_extract_first_regex(d, "-[:digit:]{2}-"))) < 32 &
                       as.numeric(gsub("-", "", stringi::stri_extract_first_regex(d, "-[:digit:]{2}$"))) < 32,
                     d, NA_character_)
  input <- utils::menu(c("YMD (Year-Month-Day)", "DMY (Day-Month-Year)",
                         "MDY (Month-Day-Year)", "Ambiguous/Not sure"),
                       title = paste0("What is the component order of ambiguous 6 digit dates in vector
                                      (e.g. ", dplyr::first(examples[stats::complete.cases(examples)]), ")?"))
  if (input == 1) {
    out <- d
    message("Ambiguous 6 digit dates already in standard YMD format")
  }
  if (input == 2) {
    out <- stringi::stri_replace_all_regex(d, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$", "$3-$2-$1")
    message("Ambiguous 6 digit dates have been changed to standard YMD format")
  }
  if (input == 3) {
    out <- stringi::stri_replace_all_regex(d, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$", "$3-$1-$2")
    message("Ambiguous 6 digit dates have been changed to standard YMD format")
  }
  if (input == 4) {
    out <- stringi::stri_replace_all_regex(d, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$",
                                    "$1-$2-$3,$3-$2-$1,$3-$1-$2")
    message("Ambiguous 6 digit dates have been changed to a set of possible dates")
  }
  out
}

complete_ambiguous_20 <- function(d) {
  examples <- ifelse(as.numeric(gsub("-", "", stringi::stri_extract_first_regex(d, "^[:digit:]{2}-"))) < 23, d, NA_character_)
  examples <- dplyr::first(examples[stats::complete.cases(examples)])
  input <- utils::menu(c("Yes", "No"),
                       title = paste0("Are all ambiguous 6 digit dates for which the year is between 0 and 23
                       in the 21st century (e.g. ", examples, " is equal to 20", examples, ")?"))
  if (input == 1) {
    out <- stringi::stri_replace_all_regex(d, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$", "20$1-$2-$3")
    message("Ambiguous 6 digit dates for which the year is smaller than 23 were completed.")
  }
  if (input == 2) {
    out <- d
    message("No changes were made to ambiguous 6 digit dates for which the year is smaller than 23.")
  }
  out
}

complete_ambiguous_19 <- function(d) {
  examples <- ifelse(as.numeric(gsub("-", "", stringi::stri_extract_first_regex(d, "^[:digit:]{2}-"))) > 22, d, NA_character_)
  examples <- dplyr::first(examples[stats::complete.cases(examples)])
  input <- utils::menu(c("Yes", "No"),
                       title = paste0("Are all ambiguous 6 digit dates for which the year is larger than 22
                       in the 20th century (e.g. ", examples, " is equal to 19", examples, ")?"))
  if (input == 1) {
    out <- stringi::stri_replace_all_regex(d, "^([:digit:]{2})-([:digit:]{2})-([:digit:]{2})$", "19$1-$2-$3")
    message("6 digit dates for which the year is larger than 22 were completed.")
  }
  if (input == 2) {
    out <- d
    message("No changes were made to 6 digit dates for which the year is larger than 22.")
  }
  out
}

stri_squish <- function(charvec){
  stringi::stri_trim_both(stringi::stri_replace_all_regex(charvec, "\\s+", " "))
}
