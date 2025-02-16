
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statsreportr

<!-- badges: start -->

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

This is a basic example which shows you how to solve a common problem:

``` r
library(statsreportr)

results <- mtcars |> 
  rstatix::anova_test(mpg ~ cyl)

format_p(results$p)
#> [1] "< 0.0001"

results2 <- mtcars |> 
  rstatix::anova_test(mpg ~ cyl * carb)

report_anova(results2)
#> [1] "*F*~(1,28)~ = 47.2 *p* < 0.0001, $\\eta^2_G$ = 0.628"
report_anova(results2, "carb")
#> [1] "*F*~(1,28)~ = 1.55 *p* = 0.223, $\\eta^2_G$ = 0.052"
report_anova(results2, 2)
#> [1] "*F*~(1,28)~ = 1.55 *p* = 0.223, $\\eta^2_G$ = 0.052"
```
