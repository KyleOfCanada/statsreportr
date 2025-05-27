test_that("report_cor works", {
  results1 <- mtcars |>
    cor_test(mpg, wt, disp, method = "pearson")
  report1 <- results1 |>
    report_cor(effect = c("mpg", "wt"))
  report2 <- results1 |>
    report_cor(effect = 9)
  results2 <- mtcars |>
    cor_test(mpg, wt, disp, method = "spearman")
  report3 <- results2 |>
    report_cor(effect = c("wt", "disp"))
  results3 <- mtcars |>
    cor_test(mpg, wt, method = "kendall")
  report4 <- results3 |>
    report_cor()

  expect_equal(report1, "*r*~(30)~ = -0.87, *p* < 0.0001")
  expect_equal(report2, "*r*~(30)~ = 1, *p* < 0.0001")
  expect_equal(report3, "$\\rho$ = 0.9, *S* = 558, *p* < 0.0001")
  expect_equal(report4, "*$\\tau$* = -0.73, *T* = -5.8, *p* < 0.0001")
})

test_that("report_cor throws errors with incorrect input", {
  results <- mtcars |>
    cor_test(mpg, wt, disp, method = "pearson")
  results2 <- cor.test(mtcars$mpg, mtcars$wt)

  expect_error(
    report_cor(results2),
    "The cor_test input must be an rstatix::cor_test object"
  )

  expect_error(
    report_cor(results, effect = "cyl"),
    "The effect must be a vector of length 2 corresponding to the var1 and var2 columns in the cor test"
  )

  expect_error(
    report_cor(results, effect = c("mpg", "wt", "disp")),
    "The effect must be a vector of length 2 corresponding to the var1 and var2 columns in the cor test"
  )

  expect_error(
    report_cor(results, effect = c("test", "test2")),
    "The pair of effects are not in the cor_test table"
  )

  expect_error(
    report_cor(results, effect = 100),
    "The effect number is greater than the number of effects in the cor_test table"
  )

  expect_error(
    report_cor(results, digits = "test"),
    "The digits argument must be a number"
  )

  expect_error(
    report_cor(results |> dplyr::mutate(method = "test")),
    "The correlation method is not supported"
  )
})
