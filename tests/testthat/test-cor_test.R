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
    structure(list(var1 = "mpg", var2 = "wt", cor = c(rho = -0.89), 
    statistic = c(S = 10292.3186135227), p = 1.49e-11, method = "Spearman"), row.names = c(NA, 
-1L), class = c("cor_test", "statsreportr_test", "tbl_df", "tbl", 
"data.frame"), args = list(data = structure(list(mpg = c(21, 
21, 22.8, 21.4, 18.7, 18.1, 14.3, 24.4, 22.8, 19.2, 17.8, 16.4, 
17.3, 15.2, 10.4, 10.4, 14.7, 32.4, 30.4, 33.9, 21.5, 15.5, 15.2, 
13.3, 19.2, 27.3, 26, 30.4, 15.8, 19.7, 15, 21.4), cyl = c(6, 
6, 4, 6, 8, 6, 8, 4, 4, 6, 6, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 8, 
8, 8, 8, 4, 4, 4, 8, 6, 8, 4), disp = c(160, 160, 108, 258, 360, 
225, 360, 146.7, 140.8, 167.6, 167.6, 275.8, 275.8, 275.8, 472, 
460, 440, 78.7, 75.7, 71.1, 120.1, 318, 304, 350, 400, 79, 120.3, 
95.1, 351, 145, 301, 121), hp = c(110, 110, 93, 110, 175, 105, 
245, 62, 95, 123, 123, 180, 180, 180, 205, 215, 230, 66, 52, 
65, 97, 150, 150, 245, 175, 66, 91, 113, 264, 175, 335, 109), 
    drat = c(3.9, 3.9, 3.85, 3.08, 3.15, 2.76, 3.21, 3.69, 3.92, 
    3.92, 3.92, 3.07, 3.07, 3.07, 2.93, 3, 3.23, 4.08, 4.93, 
    4.22, 3.7, 2.76, 3.15, 3.73, 3.08, 4.08, 4.43, 3.77, 4.22, 
    3.62, 3.54, 4.11), wt = c(2.62, 2.875, 2.32, 3.215, 3.44, 
    3.46, 3.57, 3.19, 3.15, 3.44, 3.44, 4.07, 3.73, 3.78, 5.25, 
    5.424, 5.345, 2.2, 1.615, 1.835, 2.465, 3.52, 3.435, 3.84, 
    3.845, 1.935, 2.14, 1.513, 3.17, 2.77, 3.57, 2.78), qsec = c(16.46, 
    17.02, 18.61, 19.44, 17.02, 20.22, 15.84, 20, 22.9, 18.3, 
    18.9, 17.4, 17.6, 18, 17.98, 17.82, 17.42, 19.47, 18.52, 
    19.9, 20.01, 16.87, 17.3, 15.41, 17.05, 18.9, 16.7, 16.9, 
    14.5, 15.5, 14.6, 18.6), vs = c(0, 0, 1, 1, 0, 1, 0, 1, 1, 
    1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 
    0, 0, 0, 1), am = c(1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1), 
    gear = c(4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 
    3, 4, 4, 4, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5, 5, 4), carb = c(4, 
    4, 1, 1, 2, 1, 4, 2, 2, 4, 4, 3, 3, 3, 4, 4, 4, 1, 2, 1, 
    1, 2, 2, 4, 2, 1, 2, 2, 4, 6, 8, 2)), row.names = c("Mazda RX4", 
"Mazda RX4 Wag", "Datsun 710", "Hornet 4 Drive", "Hornet Sportabout", 
"Valiant", "Duster 360", "Merc 240D", "Merc 230", "Merc 280", 
"Merc 280C", "Merc 450SE", "Merc 450SL", "Merc 450SLC", "Cadillac Fleetwood", 
"Lincoln Continental", "Chrysler Imperial", "Fiat 128", "Honda Civic", 
"Toyota Corolla", "Toyota Corona", "Dodge Challenger", "AMC Javelin", 
"Camaro Z28", "Pontiac Firebird", "Fiat X1-9", "Porsche 914-2", 
"Lotus Europa", "Ford Pantera L", "Ferrari Dino", "Maserati Bora", 
"Volvo 142E"), class = "data.frame"), vars = c("mpg", "cyl", 
"disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb"
), vars2 = c("mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", 
"vs", "am", "gear", "carb"), alternative = "two.sided", method = "spearman", 
    conf.level = 0.95, use = "pairwise.complete.obs"))
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
