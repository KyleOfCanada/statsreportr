# Report a t test result in text

Report a t test result in text

## Usage

``` r
report_t(
  ttest,
  effect = 1,
  digits = 3,
  cohensd = NULL,
  cohens_magnitude = FALSE
)
```

## Arguments

- ttest:

  an rstatix::t_test object

- effect:

  The names or row number of the effect to report

- digits:

  The number of digits to round the p value to

- cohensd:

  An rstatix::cohens_d object to include the effect size in the report

- cohens_magnitude:

  A logical indicating if the effect size magnitude should be included
  in the report

## Value

A string with the formatted t test result for use inline in an R
Markdown or Quarto document

## Examples

``` r
library(rstatix)

results <- t_test(mtcars, mpg ~ am)

report_t(results)
#> [1] "*t*~(18.3)~ = -3.77, *p* = 0.00137"

results2 <- t_test(mtcars, mpg ~ cyl)

cohensd2 <- cohens_d(mtcars, mpg ~ cyl)

report_t(results2, cohensd = cohensd2, cohens_magnitude = TRUE)
#> [1] "*t*~(13)~ = 4.72, adjusted *p* < 0.001, *d* = 2.07, indicating a large effect"

report_t(results2, effect = c("4", "6"))
#> [1] "*t*~(13)~ = 4.72, adjusted *p* < 0.001"
```
