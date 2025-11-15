# statsreportr

The goal of statsreportr is to make it easy to report the results of
statistical analyses in inline code of a R Markdown or Quarto document.
It is designed to work with the `rstatix` package, but can also use some
other inputs, and when rendering to a pdf. The envisioned usecase is to
use `rstatix` to perform the statistical tests, and then use
`statsreportr` to format the results in a way that is easy to include in
a scientific or statistical report.

## Installation

You can install the development version of statsreportr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("KyleOfCanada/statsreportr")
```

## Examples

Here are examples of the functions in `statsreportr`. In these examples
they are outputing to the R console, but they are intended to be used
inline in a R Markdown or Quarto document.

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

When used with inline code in a R Markdown or Quarto document, the
following inline code:

> The results of the t test showed a significant difference in the mpg
> of 6 (\``r mtcars |> report_mean_sd(mpg, cyl, effect = "6")`\`) vs 8
> (\``r mtcars |> report_mean_sd(mpg, cyl, effect = "8")`\`) cylinder
> cars
> (\``r report_t(results4, effect = c("6", "8"), cohensd = cohensd4, cohens_magnitude = TRUE)`\`).

Will render as:

> The results of the t test showed a significant difference in the mpg
> of 6 (19.7 ± 1.45) vs 8 (15.1 ± 2.56) cylinder cars (*t*_((18.5)) =
> 5.29, adjusted *p* \< 0.0001, *d* = 2.23, indicating a large effect).

## Functions

The following functions are available in the package:

- [`format_p()`](https://kyleofcanada.github.io/statsreportr/reference/format_p.md):
  Format p-values to be more readable.
- [`report_mean_sd()`](https://kyleofcanada.github.io/statsreportr/reference/report_mean_sd.md):
  Report the mean and standard deviation of a variable.
- [`report_mean_sem()`](https://kyleofcanada.github.io/statsreportr/reference/report_mean_sem.md):
  Report the mean and standard error of the mean of a variable.
- [`report_anova()`](https://kyleofcanada.github.io/statsreportr/reference/report_anova.md):
  Report the results of an ANOVA test.
- [`report_t()`](https://kyleofcanada.github.io/statsreportr/reference/report_t.md):
  Report the results of a t-test.
- [`report_pc()`](https://kyleofcanada.github.io/statsreportr/reference/report_pc.md):
  Report the results of a pairwise comparisons test.
- [`cor_test()`](https://kyleofcanada.github.io/statsreportr/reference/cor_test.md):
  Conduct a correlation test.
- [`report_cor()`](https://kyleofcanada.github.io/statsreportr/reference/report_cor.md):
  Report the results of a correlation test.
