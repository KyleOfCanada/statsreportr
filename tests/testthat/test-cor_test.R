test_that("cor_test works", {
  results1 <- mtcars |>
    cor_test(mpg)

  expect_equal(
    results1$var1,
    c("mpg", "mpg", "mpg", "mpg", "mpg", "mpg", "mpg", "mpg", "mpg", "mpg")
  )
  expect_equal(
    results1$var2,
    c("cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")
  )
  expect_equal(
    results1$cor,
    c(
      cor = -0.85,
      cor = -0.85,
      cor = -0.78,
      cor = 0.68,
      cor = -0.87,
      cor = 0.42,
      cor = 0.66,
      cor = 0.6,
      cor = 0.48,
      cor = -0.55
    )
  )
  expect_equal(
    results1$statistic,
    c(
      t = -8.91969884745751,
      t = -8.74715153409391,
      t = -6.74238854270679,
      t = 5.09604206124754,
      t = -9.55904414697211,
      t = 2.52521325924085,
      t = 4.86438495612278,
      t = 4.10612698310069,
      t = 2.99919062830252,
      t = -3.61574965763902
    )
  )
  expect_equal(
    results1$df,
    c(
      df = 30L,
      df = 30L,
      df = 30L,
      df = 30L,
      df = 30L,
      df = 30L,
      df = 30L,
      df = 30L,
      df = 30L,
      df = 30L
    )
  )
  expect_equal(
    results1$p,
    c(
      6.11e-10,
      9.38e-10,
      1.79e-07,
      1.78e-05,
      1.29e-10,
      0.0171,
      3.42e-05,
      0.000285,
      0.0054,
      0.00108
    )
  )
  expect_equal(
    results1$conf.low,
    c(
      -0.925769361912065,
      -0.923359365005218,
      -0.885268613495523,
      0.436048383960751,
      -0.933826413284994,
      0.0819548679090096,
      0.410363014099787,
      0.317558303512231,
      0.15806177122949,
      -0.754647962257035
    )
  )
  expect_equal(
    results1$conf.high,
    c(
      -0.716317141481634,
      -0.70813760294697,
      -0.586099412685315,
      0.83220104009279,
      -0.744087196460113,
      0.669618639209138,
      0.822326236635468,
      0.78445202183514,
      0.710062806006305,
      -0.250318316585151
    )
  )
  expect_equal(
    results1$method,
    rep("Pearson", 10L)
  )
})

test_that("spearman cor works", {
  results1 <- mtcars |>
    cor_test(method = "spearman")

  expect_equal(
    results1 |> nrow(),
    121
  )
  expect_equal(
    results1[6, ],
    structure(
      list(
        var1 = "mpg",
        var2 = "wt",
        cor = c(rho = -0.89),
        statistic = c(S = 10292.3186135227),
        p = 1.49e-11,
        method = "Spearman"
      ),
      row.names = c(NA, -1L),
      class = c("cor_test", "statsreportr_test", "tbl_df", "tbl", "data.frame")
    )
  )
})

test_that("kendall cor works", {
  results1 <- mtcars |>
    dplyr::group_by("cyl") |>
    cor_test(mpg, method = "kendall")

  expect_equal(
    results1 |> nrow(),
    10L
  )
  expect_equal(
    results1$statistic,
    c(
      z = -5.59131059034044,
      z = -6.10830465348699,
      z = -5.87100527184417,
      z = 3.67467399945172,
      z = -5.79813189498173,
      z = 2.5165206486462,
      z = 3.93416444705128,
      z = 3.12911527096917,
      z = 3.02389901824257,
      z = -3.68525397432815
    )
  )
})

test_that("cor_test with vars and vars2 works", {
  results1 <- mtcars |>
    cor_test(vars = "mpg", vars2 = c("disp", "hp", "drat"), method = "kendall")

  expect_equal(
    results1 |> nrow(),
    3L
  )
  expect_equal(
    results1$var1,
    rep("mpg", 3L)
  )
  expect_equal(
    results1$var2,
    c("disp", "hp", "drat")
  )
})

test_that("cor_test with vars and vars2 works with two vectors", {
  results1 <- mtcars |>
    cor_test(vars = c("mpg", "wt"), vars2 = c("disp", "hp", "drat"))

  expect_equal(
    results1 |> nrow(),
    6L
  )
  expect_equal(
    results1$var1,
    c("mpg", "mpg", "mpg", "wt", "wt", "wt")
  )
  expect_equal(
    results1$var2,
    c("disp", "hp", "drat", "disp", "hp", "drat")
  )
})

test_that("cor_test with grouped data works", {
  results1 <- iris |>
    dplyr::group_by(Species) |>
    cor_test(Sepal.Width, Sepal.Length)

  expect_equal(
    results1 |> nrow(),
    3L
  )
  expect_equal(
    results1$var1,
    rep("Sepal.Width", 3L)
  )
  expect_equal(
    results1$var2,
    rep("Sepal.Length", 3L)
  )
})

test_that("cor_test with no vars works", {
  results1 <- mtcars |>
    cor_test()

  expect_equal(
    results1 |> nrow(),
    121L
  )
})
