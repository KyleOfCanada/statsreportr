# Report correlation result in text

Report correlation result in text

## Usage

``` r
report_cor(cor_test, effect = 1, digits = 3)
```

## Arguments

- cor_test:

  an rstatix::cor_test object

- effect:

  the names or row number of the Effect to report

- digits:

  the number of digits to round the p value to

## Value

a string with the formatted correlation result for use inline in an R
Markdown or Quarto document

## Examples

``` r
results <- mtcars |> cor_test(mpg, wt)
report_cor(results)
#> Warning: Unknown or uninitialised column: `df`.
#> [1] "*r*~()~ = -0.87, *p* < 0.0001"

results2 <- mtcars |>
 dplyr::group_by(cyl) |>
 cor_test(mpg, wt, method = "spearman")

report_cor(results2, effect = 2)
#> [1] "$\\rho$ = -0.65, *S* = 92.7, *p* = 0.111"

results3 <- mtcars |>
  cor_test(
    vars = "mpg",
    vars2 = c("disp", "hp", "drat"),
    method = "kendall"
  )

 report_cor(results3, effect = c("mpg", "disp"))
#> [1] "*$\\tau$* = -0.77, *T* = -6.11, *p* < 0.0001"
```
