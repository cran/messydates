## ----data, warning=FALSE------------------------------------------------------
battles <- tibble::tribble(~Battle, ~Date,
                           "Operation MH-2", "2001 March 8",
                           "2001 Bangladesh–India border clashes", "2001-04-16..2001-04-20",
                           "Operation Vaksince", "25-5-2001",
                           "Alkhan-Kala operation", "2001-6-22..2001-6-28",
                           "Battle of Vedeno", "2001-8-13..2001-8-26",
                           "Operation Crescent Wind", "2001-10-7..2001-12?",
                           "Operation Rhino", "2001-10-19..2001-10-20",
                           "Battle of Mazar-e-Sharif","2001-11-9",
                           "Siege of Kunduz", "2001-11-11..2001-11-23",
                           "Battle of Herat", "Twelve of November of two thousand and twenty-one", 
                           "Battle of Kabul", "2001-11-13..2001-11-14",
                           "Battle of Tarin Kowt", "2001-11-13:2001-11-14",
                           "Operation Trent", "2001-11-15~..2001-11-30~",
                           "Battle of Kandahar", "2001-11-22..2001-12-07",
                           "Battle of Qala-i-Jangi", "2001-11-25:2001-12-01",
                           "Battle of Tora Bora", "2001-12-12..2001-12-17",
                           "Battle of Shawali Kowt", "2001-12-3",
                           "Battle of Sayyd Alma Kalay", "2001-12-4",
                           "Battle of Amami-Oshima", "2001-12-22",
                           "Tsotsin-Yurt operation", "2001-12-30:2002-01-03")

## ----messy, warning=FALSE, message=FALSE--------------------------------------
library(messydates)
battles$Date <- as_messydate(battles$Date)
tibble::tibble(battles)

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

