# Correlation Test

Provides a pipe-friendly framework to perform correlation test between
paired samples, using Pearson, Kendall or Spearman method. Wrapper
around the function
[`cor.test()`](https://rdrr.io/r/stats/cor.test.html).

Can also performs multiple pairwise correlation analyses between more
than two variables or between two different vectors of variables. Using
this function, you can also compute, for example, the correlation
between one variable vs many.

This is a slight modification of cor_test from the package rstatix.
Saves the degrees of freedom of a Pearson correlation in the output.

## Usage

``` r
cor_test(
  data,
  ...,
  vars = NULL,
  vars2 = NULL,
  alternative = "two.sided",
  method = "pearson",
  conf.level = 0.95,
  use = "pairwise.complete.obs"
)
```

## Arguments

- data:

  a data.frame containing the variables.

- ...:

  One or more unquoted expressions (or variable names) separated by
  commas. Used to select a variable of interest. Alternative to the
  argument `vars`.

- vars:

  optional character vector containing variable names for correlation
  analysis. Ignored when dot vars are specified.

  - If `vars` is NULL, multiple pairwise correlation tests is performed
    between all variables in the data.

  - If `vars` contain only one variable, a pairwise correlation analysis
    is performed between the specified variable vs either all the
    remaining numeric variables in the data or variables in `vars2` (if
    specified).

  - If `vars` contain two or more variables: i) if `vars2` is not
    specified, a pairwise correlation analysis is performed between all
    possible combinations of variables. ii) if `vars2` is specified,
    each element in `vars` is tested against all elements in `vars2`

  . Accept unquoted variable names: `c(var1, var2)`.

- vars2:

  optional character vector. If specified, each element in `vars` is
  tested against all elements in `vars2`. Accept unquoted variable
  names: `c(var1, var2)`.

- alternative:

  indicates the alternative hypothesis and must be one of `"two.sided"`,
  `"greater"` or `"less"`. You can specify just the initial letter.
  `"greater"` corresponds to positive association, `"less"` to negative
  association.

- method:

  a character string indicating which correlation coefficient is to be
  used for the test. One of `"pearson"`, `"kendall"`, or `"spearman"`,
  can be abbreviated.

- conf.level:

  confidence level for the returned confidence interval. Currently only
  used for the Pearson product moment correlation coefficient if there
  are at least 4 complete pairs of observations.

- use:

  an optional character string giving a method for computing covariances
  in the presence of missing values. This must be (an abbreviation of)
  one of the strings `"everything"`, `"all.obs"`, `"complete.obs"`,
  `"na.or.complete"`, or `"pairwise.complete.obs"`.

## Value

return a data frame with the following columns:

- `var1, var2`: the variables used in the correlation test.

- `cor`: the correlation coefficient.

- `statistic`: Test statistic used to compute the p-value.

- `p`: p-value.

- `conf.low,conf.high`: Lower and upper bounds on a confidence interval.

- `method`: the method used to compute the statistic.

## Functions

- `cor_test()`: correlation test between two or more variables.

## See also

[`cor_mat()`](https://rpkgs.datanovia.com/rstatix/reference/cor_mat.html),
[`as_cor_mat()`](https://rpkgs.datanovia.com/rstatix/reference/as_cor_mat.html)

## Examples

``` r
# Correlation between the specified variable vs
# the remaining numeric variables in the data
#:::::::::::::::::::::::::::::::::::::::::
mtcars |> cor_test(mpg)
#> # A tibble: 10 × 9
#>    var1  var2    cor statistic    df        p conf.low conf.high method 
#>  * <chr> <chr> <dbl>     <dbl> <int>    <dbl>    <dbl>     <dbl> <chr>  
#>  1 mpg   cyl   -0.85     -8.92    30 6.11e-10  -0.926     -0.716 Pearson
#>  2 mpg   disp  -0.85     -8.75    30 9.38e-10  -0.923     -0.708 Pearson
#>  3 mpg   hp    -0.78     -6.74    30 1.79e- 7  -0.885     -0.586 Pearson
#>  4 mpg   drat   0.68      5.10    30 1.78e- 5   0.436      0.832 Pearson
#>  5 mpg   wt    -0.87     -9.56    30 1.29e-10  -0.934     -0.744 Pearson
#>  6 mpg   qsec   0.42      2.53    30 1.71e- 2   0.0820     0.670 Pearson
#>  7 mpg   vs     0.66      4.86    30 3.42e- 5   0.410      0.822 Pearson
#>  8 mpg   am     0.6       4.11    30 2.85e- 4   0.318      0.784 Pearson
#>  9 mpg   gear   0.48      3.00    30 5.4 e- 3   0.158      0.710 Pearson
#> 10 mpg   carb  -0.55     -3.62    30 1.08e- 3  -0.755     -0.250 Pearson

# Correlation test between two variables
#:::::::::::::::::::::::::::::::::::::::::
mtcars |> cor_test(wt, mpg)
#> # A tibble: 1 × 9
#>   var1  var2    cor statistic    df        p conf.low conf.high method 
#> * <chr> <chr> <dbl>     <dbl> <int>    <dbl>    <dbl>     <dbl> <chr>  
#> 1 wt    mpg   -0.87     -9.56    30 1.29e-10   -0.934    -0.744 Pearson

# Pairwise correlation between multiple variables
#:::::::::::::::::::::::::::::::::::::::::
mtcars |> cor_test(wt, mpg, disp)
#> # A tibble: 9 × 9
#>   var1  var2    cor    statistic    df         p conf.low conf.high method 
#> * <chr> <chr> <dbl>        <dbl> <int>     <dbl>    <dbl>     <dbl> <chr>  
#> 1 wt    wt     1    367570386.      30 2.27e-236    1         1     Pearson
#> 2 wt    mpg   -0.87        -9.56    30 1.29e- 10   -0.934    -0.744 Pearson
#> 3 wt    disp   0.89        10.6     30 1.22e- 11    0.781     0.944 Pearson
#> 4 mpg   wt    -0.87        -9.56    30 1.29e- 10   -0.934    -0.744 Pearson
#> 5 mpg   mpg    1          Inf       30 0            1         1     Pearson
#> 6 mpg   disp  -0.85        -8.75    30 9.38e- 10   -0.923    -0.708 Pearson
#> 7 disp  wt     0.89        10.6     30 1.22e- 11    0.781     0.944 Pearson
#> 8 disp  mpg   -0.85        -8.75    30 9.38e- 10   -0.923    -0.708 Pearson
#> 9 disp  disp   1          Inf       30 0            1         1     Pearson

# Grouped data
#:::::::::::::::::::::::::::::::::::::::::
iris |>
  dplyr::group_by(Species) |>
  cor_test(Sepal.Width, Sepal.Length)
#> # A tibble: 3 × 10
#>   Species   var1  var2    cor statistic    df        p conf.low conf.high method
#> * <fct>     <chr> <chr> <dbl>     <dbl> <int>    <dbl>    <dbl>     <dbl> <chr> 
#> 1 setosa    Sepa… Sepa…  0.74      7.68    48 6.71e-10    0.585     0.846 Pears…
#> 2 versicol… Sepa… Sepa…  0.53      4.28    48 8.77e- 5    0.290     0.702 Pears…
#> 3 virginica Sepa… Sepa…  0.46      3.56    48 8.43e- 4    0.205     0.653 Pears…

# Multiple correlation test
#:::::::::::::::::::::::::::::::::::::::::
# Correlation between one variable vs many
mtcars |> cor_test(
  vars = "mpg",
  vars2 = c("disp", "hp", "drat")
 )
#> # A tibble: 3 × 9
#>   var1  var2    cor statistic    df        p conf.low conf.high method 
#> * <chr> <chr> <dbl>     <dbl> <int>    <dbl>    <dbl>     <dbl> <chr>  
#> 1 mpg   disp  -0.85     -8.75    30 9.38e-10   -0.923    -0.708 Pearson
#> 2 mpg   hp    -0.78     -6.74    30 1.79e- 7   -0.885    -0.586 Pearson
#> 3 mpg   drat   0.68      5.10    30 1.78e- 5    0.436     0.832 Pearson

# Correlation between two vectors of variables
# Each element in vars is tested against all elements in vars2
mtcars |> cor_test(
  vars = c("mpg", "wt"),
  vars2 = c("disp", "hp", "drat")
 )
#> # A tibble: 6 × 9
#>   var1  var2    cor statistic    df        p conf.low conf.high method 
#> * <chr> <chr> <dbl>     <dbl> <int>    <dbl>    <dbl>     <dbl> <chr>  
#> 1 mpg   disp  -0.85     -8.75    30 9.38e-10   -0.923    -0.708 Pearson
#> 2 mpg   hp    -0.78     -6.74    30 1.79e- 7   -0.885    -0.586 Pearson
#> 3 mpg   drat   0.68      5.10    30 1.78e- 5    0.436     0.832 Pearson
#> 4 wt    disp   0.89     10.6     30 1.22e-11    0.781     0.944 Pearson
#> 5 wt    hp     0.66      4.80    30 4.15e- 5    0.403     0.819 Pearson
#> 6 wt    drat  -0.71     -5.56    30 4.78e- 6   -0.850    -0.484 Pearson

```
