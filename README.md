
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statsreportr <img src="man/figures/logo.png" align="right" height="139" alt="statsreportr hexsticker" />

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/KyleOfCanada/statsreportr/graph/badge.svg)](https://app.codecov.io/gh/KyleOfCanada/statsreportr)
[![R-CMD-check](https://github.com/KyleOfCanada/statsreportr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KyleOfCanada/statsreportr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of statsreportr is to make it easy to report the results of
statistical analyses in inline code of a R Markdown or Quarto document.

## Installation

You can install the development version of statsreportr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("KyleOfCanada/statsreportr")
```

## Example

Some basic examples which shows you how to generate reports for ANOVAs
and t-tests:

``` r
library(statsreportr)

# ANOVAs
results <- mtcars |>
  rstatix::anova_test(mpg ~ cyl)

format_p(results$p)
#> [1] "< 0.0001"

results2 <- mtcars |>
  rstatix::anova_test(mpg ~ cyl * carb)

results3 <- aov(mpg ~ cyl * carb, data = mtcars)

report_anova(results2)
#> [1] "*F*~(1,28)~ = 47.2, *p* < 0.0001, $\\eta^2_G$ = 0.628"
report_anova(results2, "carb")
#> [1] "*F*~(1,28)~ = 1.55, *p* = 0.223, $\\eta^2_G$ = 0.052"
report_anova(results2, 2)
#> [1] "*F*~(1,28)~ = 1.55, *p* = 0.223, $\\eta^2_G$ = 0.052"
report_anova(results3, 2)
#> [1] "*F*~(1,28)~ = 1.55, *p* = 0.223, $\\eta^2_G$ = 0.052"

# t-tests
results3 <- mtcars |>
  rstatix::t_test(mpg ~ am)

report_t(results3)
#> [1] "*t*~(18.3)~ = -3.77, *p* = 0.00137"

results4 <- mtcars |>
  rstatix::t_test(mpg ~ cyl)

cohensd4 <- mtcars |>
  rstatix::cohens_d(mpg ~ cyl)

report_t(results4,
  effect = c("6", "8"),
  cohensd = cohensd4, cohens_magnitude = TRUE
)
#> [1] "*t*~(18.5)~ = 5.29, adjusted *p* < 0.0001, *d* = 2.23, indicating a large effect"

# Descriptive stats

mtcars |> report_mean_sd(mpg, cyl, effect = "6")
#> [1] "19.7 ± 1.45"

mtcars |> report_mean_sem(mpg, cyl, effect = "6")
#> [1] "19.7 ± 0.549"
```

The intent of this package is to be used inline in a R Markdown or
Quarto document. For example, the following inline code:

> The results of the t test showed a significant difference in the mpg
> of 6 (\``r mtcars |> report_mean_sd(mpg, cyl, effect = "6")`\`) vs 8
> (\``r mtcars |> report_mean_sd(mpg, cyl, effect = "8")`\`) cylinder
> cars
> (\``r report_t(results4, effect = c("6", "8"), cohensd = cohensd4, cohens_magnitude = TRUE)`\`).

Will render as:

> The results of the t test showed a significant difference in the mpg
> of 6 (19.7 ± 1.45) vs 8 (15.1 ± 2.56) cylinder cars
> (*t*<sub>(18.5)</sub> = 5.29, adjusted *p* \< 0.0001, *d* = 2.23,
> indicating a large effect).
