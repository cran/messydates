d <- as_messydate(c("2008-03-25", "-2012-02-27", "2001-01?", "2001",
                    "2001-01-01..2001-02-02", "{2001-01-01,2001-02-02}",
                    "..2002-02-03", "2001-01-03.."))
a <- as_messydate(c("2008-03-28", "-2012-02-24", "2001-01-04..2001-02-03",
                    "2001-01-04..2002-01-03", "2001-01-04..2001-02-05",
                    "{2001-01-04,2001-02-05}", "..2002-02-06",
                    "2001-01-06.."))
s <- as_messydate(c("2008-03-22", "-2012-03-01", "2000-12-29..2001-01-28",
                    "2000-12-29..2001-12-28", "2000-12-29..2001-01-30",
                    "{2000-12-29,2001-01-30} ", "..2002-01-31",
                    "2000-12-31.."))

test_that("operations works properly", {
  expect_equal(add(d, 3), a)
  expect_equal(d + 3, a)
  expect_equal(subtract(d, 3), s)
  expect_equal(d - 3, s)
  expect_equal(d + "3 days", a)
  expect_equal(d - "3 days", s)
})

test_that("operations between mdates work properly", {
  expect_equal(as_messydate("2001-01-01") +
                 as_messydate("2001-01-02..2001-01-04"),
               as_messydate("2001-01-01..2001-01-04"))
  expect_equal(as_messydate("2001-01-01") + as_messydate("2001-01-03"),
               as_messydate("{2001-01-01,2001-01-03}"))
  expect_equal(as_messydate("2001-01-01..2001-01-04") -
                 as_messydate("2001-01-02"),
               list(as_messydate("{2001-01-01,2001-01-03..2001-01-04}")))
  expect_message(as_messydate("2001-01-01") - as_messydate("2001-01-03"),
                 "First and second elements do not overlap.")
})
