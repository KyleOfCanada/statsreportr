test_that("report_t works", {
  results <- rstatix::t_test(mtcars, mpg ~ cyl)
  results2 <- rstatix::t_test(mtcars, mpg ~ am)

  expect_equal(
    report_t(results),
    "*t*~(13)~ = 4.72, adjusted *p* < 0.001"
  )

  expect_equal(
    report_t(results2),
    "*t*~(18.3)~ = -3.77, *p* = 0.00137"
  )
})

test_that("report_t accepts numeric effect argument", {
  results <- rstatix::t_test(mtcars, mpg ~ cyl)

  expect_equal(
    report_t(results, 2),
    "*t*~(15)~ = 7.6, adjusted *p* < 0.0001"
  )
})

test_that("report_t accepts string effect argument", {
  results <- rstatix::t_test(mtcars, mpg ~ cyl)

  expect_equal(
    report_t(results, c("6", "8")),
    "*t*~(18.5)~ = 5.29, adjusted *p* < 0.0001"
  )
})

test_that("report_t accepts digits argument", {
  results <- rstatix::t_test(mtcars, mpg ~ cyl)

  expect_equal(
    report_t(results, 2, digits = 1),
    "*t*~(15)~ = 8, adjusted *p* < 0.0001"
  )
})

test_that("report_t accepts cohens d argument", {
  results <- rstatix::t_test(mtcars, mpg ~ cyl)
  cohensd <- rstatix::cohens_d(mtcars, mpg ~ cyl)

  expect_equal(
    report_t(results, 2, cohensd = cohensd),
    "*t*~(15)~ = 7.6, adjusted *p* < 0.0001, *d* = 3.15"
  )
})

test_that("report_t accepts cohens d magnitude argument", {
  results <- rstatix::t_test(mtcars, mpg ~ cyl)
  cohensd <- rstatix::cohens_d(mtcars, mpg ~ cyl)

  expect_equal(
    report_t(results, 2,
      cohensd = cohensd,
      cohens_magnitude = TRUE
    ),
    "*t*~(15)~ = 7.6, adjusted *p* < 0.0001, *d* = 3.15, indicating a large effect"
  )
})

test_that("report_t throws errors with incorrect input", {
  results <- rstatix::t_test(mtcars, mpg ~ cyl)
  results2 <- rstatix::t_test(mtcars, mpg ~ am)
  cohensd <- rstatix::cohens_d(mtcars, mpg ~ cyl)
  errortest <- t.test(mtcars$mpg ~ mtcars$am)

  expect_error(
    report_t(errortest),
    "The t test input must be an rstatix::t_test object"
  )

  expect_error(
    report_t(results, "cyl"),
    "The effect must be a vector of length 2 corresponding to the group1 and group2 columns in the t test"
  )

  expect_error(
    report_t(results, c("test", "test2")),
    "The pair of effects are not in the t_test table"
  )

  expect_error(
    report_t(results, 100),
    "The effect number is greater than the number of effects in the t_test table"
  )

  expect_error(
    report_t(results, 2, cohensd = results2),
    "The cohens d input must be an rstatix::cohens_d object"
  )

  expect_error(
    report_t(results2, cohensd = cohensd),
    "The cohens_d must analyze the same effects as the t_test"
  )

  expect_error(
    report_t(results, 2, cohensd = cohensd, cohens_magnitude = "test"),
    "The cohens_magnitude input must be a logical"
  )
})
