# Format a p value for presentation in a R Markdown or Quarto document

Format a p value for presentation in a R Markdown or Quarto document

## Usage

``` r
format_p(p_value, digits = 3)
```

## Arguments

- p_value:

  The p value to format

- digits:

  The number of digits to round the p value to

## Value

A string with the formatted p value

## Examples

``` r
p <- 0.00445463
format_p(p)
#> [1] "= 0.00445"
```
