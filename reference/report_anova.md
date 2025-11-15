# Report an ANOVA result in text

Report an ANOVA result in text

## Usage

``` r
report_anova(ANOVA, effect = 1, digits = 3)
```

## Arguments

- ANOVA:

  an rstatix::anova_test object or a stats::aov object

- effect:

  The name or row number of the Effect to report

- digits:

  The number of digits to round the p value to

## Value

A string with the formatted ANOVA result for use inline in an R Markdown
or Quarto document

## Examples

``` r
library(rstatix)
#> 
#> Attaching package: ‘rstatix’
#> The following object is masked from ‘package:statsreportr’:
#> 
#>     cor_test
#> The following object is masked from ‘package:stats’:
#> 
#>     filter

results <- anova_test(mtcars, mpg ~ cyl * carb)

report_anova(results)
#> [1] "*F*~(1,28)~ = 47.2, *p* < 0.0001, $\\eta^2_G$ = 0.628"
report_anova(results, effect = "cyl")
#> [1] "*F*~(1,28)~ = 47.2, *p* < 0.0001, $\\eta^2_G$ = 0.628"
report_anova(results, effect = 2)
#> [1] "*F*~(1,28)~ = 1.55, *p* = 0.223, $\\eta^2_G$ = 0.052"
```
