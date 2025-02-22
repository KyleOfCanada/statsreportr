test_that("report_mean_sd works", {
  expect_equal(report_mean_sd(mtcars, mpg), "20.1 ± 6.03")
  expect_equal(report_mean_sd(mtcars, mpg, cyl), "26.7 ± 4.51")
  expect_equal(report_mean_sd(mtcars, mpg, cyl, effect = 2), "19.7 ± 1.45")
  expect_equal(
    report_mean_sd(mtcars, mpg, cyl, effect = "6", digits = 1),
    "20 ± 1"
  )
})

test_that("report_mean_sd throws errors", {
  expect_error(
    report_mean_sd(mtcars, mpg, cyl, effect = 12),
    "The effect number is greater than the number of effects in the data table"
  )
  expect_error(
    report_mean_sd(mtcars, mpg, cyl, effect = "12"),
    "The effect name is not in the data table"
  )
  expect_error(report_mean_sd(1:99, mpg), "The data must be a data frame")
  expect_error(report_mean_sd(data.frame(NULL), mpg), "The data frame is empty")
  expect_error(
    report_mean_sd(mtcars, mpg, digits = "one"),
    "The digits must be a number"
  )
})

test_that("report_mean_sem works", {
  expect_equal(report_mean_sem(mtcars, mpg), "20.1 ± 1.07")
  expect_equal(report_mean_sem(mtcars, mpg, cyl), "26.7 ± 1.36")
  expect_equal(report_mean_sem(mtcars, mpg, cyl, effect = 2), "19.7 ± 0.549")
  expect_equal(
    report_mean_sem(mtcars, mpg, cyl, effect = "6", digits = 1),
    "20 ± 0.5"
  )
})

test_that("report_mean_sem throws errors", {
  expect_error(
    report_mean_sem(mtcars, mpg, cyl, effect = 12),
    "The effect number is greater than the number of effects in the data table"
  )
  expect_error(
    report_mean_sem(mtcars, mpg, cyl, effect = "12"),
    "The effect name is not in the data table"
  )
  expect_error(report_mean_sem(1:99, mpg), "The data must be a data frame")
  expect_error(
    report_mean_sem(data.frame(NULL), mpg),
    "The data frame is empty"
  )
  expect_error(
    report_mean_sem(mtcars, mpg, digits = "one"),
    "The digits must be a number"
  )
})
