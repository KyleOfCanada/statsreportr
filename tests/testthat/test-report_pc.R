test_that("report_pc works", {
  results <- rstatix::emmeans_test(mtcars, mpg ~ cyl)
  results2 <- rstatix::emmeans_test(mtcars, mpg ~ am, p.adjust.method = "none")
  results3 <- mtcars |>
    dplyr::mutate(test = rep(c("a", "b"), each = 16)) |>
    rstatix::emmeans_test(mpg ~ test, p.adjust.method = "none")

  expect_equal(
    report_pc(results, effect_size = FALSE),
    "*t*~(29)~ = 4.44, adjusted *p* < 0.001"
  )

  expect_equal(
    report_pc(results, effect_size = TRUE),
    "*t*~(29)~ = 4.44, adjusted *p* < 0.001, *d* = 1.88"
  )

  expect_equal(
    report_pc(results, effect = c("4", "6")),
    "*t*~(29)~ = 4.44, adjusted *p* < 0.001, *d* = 1.88"
  )

  expect_equal(
    report_pc(results, effect = c("6", "4")),
    "*t*~(29)~ = 4.44, adjusted *p* < 0.001, *d* = -1.88"
  )

  expect_equal(
    report_pc(results2, effect_size = FALSE),
    "*t*~(30)~ = -4.11, *p* < 0.001"
  )

  expect_equal(
    report_pc(results3),
    "*t*~(30)~ = -1.84, *p* = 0.075, *d* = -0.651"
  )
})

test_that("report_pc accepts numeric effect argument", {
  results <- rstatix::emmeans_test(mtcars, mpg ~ cyl)

  expect_equal(
    report_pc(results, 2, effect_size = FALSE),
    "*t*~(29)~ = 8.9, adjusted *p* < 0.0001"
  )
})

test_that("report_pc accepts string effect argument", {
  results <- rstatix::emmeans_test(mtcars, mpg ~ cyl)

  expect_equal(
    report_pc(results, c("4", "6"), effect_size = FALSE),
    "*t*~(29)~ = 4.44, adjusted *p* < 0.001"
  )
})

test_that("report_pc accepts digits argument", {
  results <- rstatix::emmeans_test(mtcars, mpg ~ cyl)

  expect_equal(
    report_pc(results, 2, digits = 1, effect_size = FALSE),
    "*t*~(29)~ = 9, adjusted *p* < 0.0001"
  )

  expect_error(
    report_pc(results, 2, digits = "test", effect_size = FALSE),
    "The digits argument must be a single positive number"
  )
})

test_that("report_pc throws errors with incorrect input", {
  results <- rstatix::emmeans_test(mtcars, mpg ~ cyl)
  results2 <- rstatix::emmeans_test(mtcars, mpg ~ am)
  errortest <- t.test(mtcars$mpg ~ mtcars$am)

  expect_error(
    report_pc(errortest),
    "The pairwise comparison input must be an rstatix::emmeans_test object"
  )

  expect_error(
    report_pc(results, "cyl"),
    "The effect must be a vector of length 2 corresponding to the group1 and group2 columns in the emmeans test"
  )

  expect_error(
    report_pc(results, c("test", "test2")),
    "The pair of effects are not in the emmeans_test table"
  )

  expect_error(
    report_pc(results, 100),
    "The effect number is greater than the number of effects in the emmeans_test table"
  )

  expect_error(
    report_pc(results, -1),
    "The effect number must be greater than 0"
  )

  expect_error(
    report_pc(results, TRUE),
    "The effect must be a single numeric value or a vector of length 2 corresponding to the group1 and group2 columns in the emmeans test"
  )

  expect_error(
    report_pc(results, 1:3),
    "The effect must be a single numeric value or a vector of length 2 corresponding to the group1 and group2 columns in the emmeans test"
  )

  expect_error(
    report_pc(results, effect_size = "test"),
    "The effect_size argument must be TRUE or FALSE"
  )
})
