## ----data, warning=FALSE------------------------------------------------------
library(messydates)
battles <- messydates::battles
battles

## ----messy, warning=FALSE, message=FALSE--------------------------------------
battles$Date <- as_messydate(battles$Date)
battles$Date

## ----censored, warning=FALSE--------------------------------------------------
battles$Date <- as_messydate(ifelse(battles$Battle == "Battle of Herat", on_or_before(battles$Date), battles$Date))
battles$Date <- as_messydate(ifelse(battles$Battle == "Operation Vaksince", on_or_after(battles$Date), battles$Date))
tibble::tibble(battles)

## ----approximate, warning=FALSE-----------------------------------------------
battles$Date <- as_messydate(ifelse(battles$Battle == "Battle of Shawali Kowt", as_uncertain(battles$Date), battles$Date))
battles$Date <- as_messydate(ifelse(battles$Battle == "Battle of Sayyd Alma Kalay", as_approximate(battles$Date), battles$Date))
tibble::tibble(battles)

## ----expand, warning=FALSE----------------------------------------------------
expand(battles$Date)

## ----expand_approx, eval=FALSE------------------------------------------------
#  expand(battles$Date, approx_range = 1)

## ----contract, warning=FALSE--------------------------------------------------
tibble::tibble(contract = contract(expand(battles$Date)))

## ----coerce, warning=FALSE----------------------------------------------------
tibble::tibble(min = as.Date(battles$Date, min),
               max = as.Date(battles$Date, max),
               median = as.Date(battles$Date, median),
               mean = as.Date(battles$Date, mean),
               modal = as.Date(battles$Date, modal),
               random = as.Date(battles$Date, random))

## ----logical, warning=FALSE---------------------------------------------------
is_messydate(battles$Date)
is_intersecting(as_messydate(battles$Date[1]), as_messydate(battles$Date[2]))
is_element(as_messydate("2001-04-17"), as_messydate(battles$Date[2]))
is_similar(as_messydate("2001-08-03"), as_messydate(battles$Date[1]))
is_precise(as_messydate(battles$Date[2]))

## ----set, warning=FALSE-------------------------------------------------------
md_intersect(as_messydate(battles$Date[9]), as_messydate(battles$Date[10]))
md_union(as_messydate(battles$Date[17]), as_messydate(battles$Date[18]))
md_multiset(as_messydate(battles$Date[1]), as_messydate(battles$Date[2]))

## ----operate------------------------------------------------------------------
tibble::tibble("one day more" = battles$Date + 1,
               "one day less" = battles$Date - "1 day")

