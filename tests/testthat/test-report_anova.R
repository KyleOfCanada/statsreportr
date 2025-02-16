results <- rstatix::anova_test(mtcars, mpg ~ cyl * carb)

test_that("report_anova works", {
  expect_equal(report_anova(results),
               "*F*~(1,28)~ = 47.2 *p* < 0.0001, $\\eta^2_G$ = 0.628")
})

test_that("report_anova accepts numeric effect argument", {
  expect_equal(report_anova(results, 2),
               "*F*~(1,28)~ = 1.55 *p* = 0.223, $\\eta^2_G$ = 0.052")
})

test_that("report_anova accepts string effect argument", {
  expect_equal(report_anova(results, "cyl"),
               "*F*~(1,28)~ = 47.2 *p* < 0.0001, $\\eta^2_G$ = 0.628")
})

test_that("report_anova accepts digits argument", {
  expect_equal(report_anova(results, 2, digits = 2),
               "*F*~(1,28)~ = 1.6 *p* = 0.22, $\\eta^2_G$ = 0.052")
})
