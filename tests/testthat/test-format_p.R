test_that("formt_p() formats high p value", {
  expect_equal(format_p(.5678), "= 0.568")
})

test_that("formt_p() formats low p value", {
  expect_equal(format_p(.000000005678), "< 0.0001")
})

test_that("format_p() errors if input is character", {
  expect_error(format_p(".5564"))
})

test_that("format_p() errors if input is > 1", {
  expect_error(format_p(c(.5564, .0054)))
})
