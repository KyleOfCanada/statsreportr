test_that("report_anova works", {
  results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)

  expect_equal(
    report_anova(results),
    "*F*~(1,28)~ = 47.2 *p* < 0.0001, $\\eta^2_G$ = 0.628"
  )
})

test_that("report_anova accepts numeric effect argument", {
  results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)

  expect_equal(
    report_anova(results, 2),
    "*F*~(1,28)~ = 1.55 *p* = 0.223, $\\eta^2_G$ = 0.052"
  )
})

test_that("report_anova accepts string effect argument", {
  results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)

  expect_equal(
    report_anova(results, "cyl"),
    "*F*~(1,28)~ = 47.2 *p* < 0.0001, $\\eta^2_G$ = 0.628"
  )
})

test_that("report_anova accepts digits argument", {
  results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)

  expect_equal(
    report_anova(results, 2, digits = 2),
    "*F*~(1,28)~ = 1.6 *p* = 0.22, $\\eta^2_G$ = 0.052"
  )
})

test_that("report_anova throws errors with incorrect input", {
  results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)
  error_results <- aov(mpg ~ cyl * carb, data = mtcars)

  expect_error(
    report_anova(error_results),
    "The ANOVA input must be an rstatix::anova_test object"
  )

  expect_error(
    report_anova(results, effect = "test"),
    "The effect name is not in the ANOVA table"
  )

  expect_error(
    report_anova(results, effect = 100),
    "The effect number is greater than the number of effects in the ANOVA table"
  )
})
