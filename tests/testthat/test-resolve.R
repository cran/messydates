test_that("Resolve dates works properly for date ranges", {
  range <- as_messydate("2014-01-01..2014-01-31")
  range2 <- as_messydate("2014-01-01..2014-01-30")
  expect_equal(as.character(min(range)), "2014-01-01")
  expect_equal(as.character(max(range)), "2014-01-31")
  expect_equal(as.character(median(range)), "2014-01-16")
  expect_equal(as.character(median(range2)), "2014-01-16")
  expect_equal(as.character(mean(range)), "2014-01-16")
  expect_equal(as.character(modal(range)), "2014-01-01")
  expect_length(random(range), 1)
})

test_that("Resolve dates works properly for unspecified dates", {
  unspecified <- as_messydate("1999")
  expect_equal(as.character(min(unspecified)), "1999-01-01")
  expect_equal(as.character(max(unspecified)), "1999-12-31")
  expect_equal(as.character(median(unspecified)), "1999-07-02")
  expect_equal(as.character(mean(unspecified)), "1999-07-02")
  expect_equal(as.character(modal(unspecified)), "1999-01-01")
  expect_length(random(unspecified), 1)
})

test_that("Resolve dates works properly for negative dates", {
  negative <- as_messydate("1000 BC")
  expect_equal(as.character(min(negative)), "-1000-01-01")
  expect_equal(as.character(as.Date(negative, min)), "-1000-01-01")
  expect_equal(as.character(max(negative)), "-1000-12-31")
  expect_equal(as.character(as.Date(negative, max)), "-1000-12-31")
  expect_equal(as.character(median(negative)), "-1000-07-02")
  expect_equal(as.character(as.Date(negative, median)), "-1000-07-02")
  expect_equal(as.character(mean(negative)), "-1000-07-02")
  expect_equal(as.character(as.Date(negative, mean)), "-1000-07-02")
  expect_equal(as.character(modal(negative)), "-1000-01-01")
  expect_equal(as.character(as.Date(negative, modal)), "-1000-01-01")
  expect_length(random(negative), 1)
})

test_that("resolve adds zero padding when appropriate", {
  expect_equal(as_messydate(min(as_messydate("209-12-31"))),
                            as_messydate("0209-12-31"))
  expect_equal(as_messydate(max(as_messydate("-29-12-31"))),
                            as_messydate("-0029-12-31"))
  expect_equal(as_messydate(mean(as_messydate(c("-29-12-31", "193-02-02", "2010-10-10")))),
               as_messydate(c("-0029-12-31", "0193-02-02", "2010-10-10")))
})
