# Report the mean and standard deviation in text

Report the mean and standard deviation in text

## Usage

``` r
report_mean_sd(.data, value_var, group_var = NULL, effect = 1, digits = 3)
```

## Arguments

- .data:

  A data frame

- value_var:

  The name of the variable to report

- group_var:

  The name of the grouping variable

- effect:

  The name or row number of the effect to report

- digits:

  The number of digits to round the p value to

## Value

A string with the mean and standard deviation of the variable in the
format: "mean ± sd"

## Examples

``` r
mtcars |> report_mean_sd(value_var = mpg)
#> [1] "20.1 ± 6.03"
mtcars |> report_mean_sd(mpg, cyl, effect = "6")
#> [1] "19.7 ± 1.45"
```
