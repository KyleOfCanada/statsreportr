# Report a pairwise comparison result in text

Report a pairwise comparison result in text

## Usage

``` r
report_pc(
  pairwise_comparison,
  effect = 1,
  group = NULL,
  digits = 3,
  effect_size = TRUE
)
```

## Arguments

- pairwise_comparison:

  An rstatix::emmeans_test object

- effect:

  The names or row number of the effect to report

- group:

  A named vector of grouping variables to filter the pairwise comparison
  results by

- digits:

  The number of digits to round the p value to

- effect_size:

  Whether to include the effect size in the report

## Value

A string with the formatted pairwise comparison result for use inline in
an R Markdown or Quarto document

## Examples

``` r
library(rstatix)

results <- emmeans_test(mtcars, mpg ~ am)

report_pc(results)
#> [1] "*t*~(30)~ = -4.11, adjusted *p* < 0.001, *d* = -1.48"

results2 <- emmeans_test(mtcars, mpg ~ cyl, p.adjust.method = "none")

report_pc(results2, effect = 3)
#> [1] "*t*~(29)~ = 3.11, *p* = 0.00415, *d* = 2.05"

report_pc(results2, effect = c("4", "6"))
#> [1] "*t*~(29)~ = 4.44, *p* < 0.001, *d* = 1.88"
```
