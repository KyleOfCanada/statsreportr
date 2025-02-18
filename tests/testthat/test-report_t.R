results <- rstatix::t_test(mtcars, mpg ~ cyl)
cohensd2 <- rstatix::cohens_d(mtcars, mpg ~ cyl)

test_that("report_t works", {
  expect_equal(
    report_t(results),
    "*t*~(13)~ = 4.72, adjusted *p* < 0.001"
  )
})

test_that("report_t accepts numeric effect argument", {
  expect_equal(
    report_t(results, 2),
    "*t*~(15)~ = 7.6, adjusted *p* < 0.0001"
  )
})

test_that("report_t accepts string effect argument", {
  expect_equal(
    report_t(results, c("6", "8")),
    "*t*~(18.5)~ = 5.29, adjusted *p* < 0.0001"
  )
})

test_that("report_t accepts digits argument", {
  expect_equal(
    report_t(results, 2, digits = 1),
    "*t*~(15)~ = 8, adjusted *p* < 0.0001"
  )
})

test_that("report_t accepts cohens d argument", {
  expect_equal(
    report_t(results, 2, cohensd = cohensd2),
    "*t*~(15)~ = 7.6, adjusted *p* < 0.0001, *d* = 3.15"
  )
})

test_that("report_t accepts cohens d magnitude argument", {
  expect_equal(
    report_t(results, 2,
      cohensd = cohensd2,
      cohens_magnitude = TRUE
    ),
    "*t*~(15)~ = 7.6, adjusted *p* < 0.0001, *d* = 3.15, indicating a large effect"
  )
})
