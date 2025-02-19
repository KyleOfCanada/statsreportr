test_that("report_anova works", {
  aov_results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)

  expect_equal(
    report_anova(aov_results),
    "*F*~(1,28)~ = 47.2 *p* < 0.0001, $\\eta^2_G$ = 0.628"
  )
})

test_that("report_anova works with aov object", {
  results <- aov(mpg ~ cyl * carb, data = mtcars)

  expect_equal(
    report_anova(results),
    "*F*~(1,28)~ = 78.4 *p* < 0.0001, $\\eta^2_G$ = 0.737"
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

test_that("report_anova works with partial eta squared", {
  results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb,
    effect.size = "pes"
  )

  expect_equal(
    report_anova(results),
    "*F*~(1,28)~ = 47.2 *p* < 0.0001, $\\eta^2_p$ = 0.628"
  )
})

test_that("report_anova works with mixed factor anovas", {
  n <- 30
  dat <- data.frame(
    id = rep(1:n, each = 3),
    wthn = rep(c("A", "B", "C"), n),
    btwn = rep(c("X", "Y"), each = 1.5 * n),
    score = c(
      -0.190756852337017, -1.34955887575366,
      -0.00416131453571523, 0.228652318246206, 1.8915205698228, 0.605885998456574, -1.74266255554016,
      1.25332876746243, -2.82496706598169, -0.616259891332444, -0.553720170737741,
      -0.426709214623118, -1.228520753203, -0.190740068314312, 0.370798549321187,
      -0.260502247705621, 1.63569001018678, 0.633796814075423, 0.505278504043964,
      -0.285002233443955, 0.82158699266505, -1.31125912401413, 1.03306445000369,
      -1.54787168667056, 1.08241542953367, 0.783924595766602, 0.209009174211206,
      -0.892635517128209, 0.0830738954739145, 0.21072066363281, 0,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0,
      0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
    )
  )
  results <- dat |>
    rstatix::anova_test(dv = score, wid = id, within = wthn, between = btwn)

  expect_equal(
    report_anova(results, 2),
    "*F*~(1.62,45.46)~ = 1.34 *p* = 0.268, $\\eta^2_G$ = 0.019"
  )
})

test_that("report_anova throws errors with incorrect input", {
  results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)
  error_results <- t.test(mpg ~ vs, data = mtcars)

  expect_error(
    report_anova(error_results),
    "The ANOVA input must be an aov or rstatix::anova_test object"
  )

  expect_error(
    report_anova(results, effect = "test"),
    "The effect name is not in the ANOVA table"
  )

  expect_error(
    report_anova(results, effect = 100),
    "The effect number is greater than the number of effects in the ANOVA table"
  )

  colnames(results) <- c("Effect", "DFn", "DFd", "F", "p", "p<.05", "test")
  expect_error(
    report_anova(results),
    "The ANOVA table does not contain effect size information"
  )
})
