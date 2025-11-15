# Changelog

## statsreportr (development version)

## statsreportr 0.0.0.9006

- [`report_pc()`](https://kyleofcanada.github.io/statsreportr/reference/report_pc.md)
  now takes into consideration the order of named `effect` argument to
  determine the direction of the effect size in the output.

## statsreportr 0.0.0.9005

- [`report_pc()`](https://kyleofcanada.github.io/statsreportr/reference/report_pc.md)
  fixed bug in data selection during effect size calculation.

## statsreportr 0.0.0.9004

- [`report_pc()`](https://kyleofcanada.github.io/statsreportr/reference/report_pc.md)
  now is able to report effect sizes for pairwise comparisons. The
  effect size is calculated using the
  [`emmeans::eff_size()`](https://rvlenth.github.io/emmeans/reference/eff_size.html)
  function.

## statsreportr 0.0.0.9003

- [`cor_test()`](https://kyleofcanada.github.io/statsreportr/reference/cor_test.md)
  and
  [`report_cor()`](https://kyleofcanada.github.io/statsreportr/reference/report_cor.md)
  added to the package. These functions are used to report the results
  of correlation tests.
  [`cor_test()`](https://kyleofcanada.github.io/statsreportr/reference/cor_test.md)
  is modified version of
  [`rstatix::cor_test()`](https://rpkgs.datanovia.com/rstatix/reference/cor_test.html)
  that will save the degrees of freedom of a Pearson correlation in the
  output, and
  [`report_cor()`](https://kyleofcanada.github.io/statsreportr/reference/report_cor.md)
  formats the results for reporting in R Markdown and Quarto documents.

## statsreportr 0.0.0.9002

- [`report_pc()`](https://kyleofcanada.github.io/statsreportr/reference/report_pc.md)
  added to the package. This function is used to report the results of a
  pairwise comparison test. It is designed to be used in conjunction
  with the function
  [`emmeans_test()`](https://rpkgs.datanovia.com/rstatix/reference/emmeans_test.html)
  from the ‘rstatix’ R package, and to be used in inline r code within R
  Markdown and Quarto documents.

## statsreportr 0.0.0.9001

- [`report_mean_sd()`](https://kyleofcanada.github.io/statsreportr/reference/report_mean_sd.md)
  and
  [`report_mean_sem()`](https://kyleofcanada.github.io/statsreportr/reference/report_mean_sem.md)
  added to the package. These functions are used to report the mean and
  standard deviation or standard error of a dataset, respectively. They
  are designed to be used in inline r code within R Markdown and Quarto
  documents.

## statsreportr 0.0.0.9000

- [`report_anova()`](https://kyleofcanada.github.io/statsreportr/reference/report_anova.md)
  and
  [`report_t()`](https://kyleofcanada.github.io/statsreportr/reference/report_t.md)
  added to the package. These functions are used to report the results
  of ANOVA and t-tests, respectively. They are designed to be used in
  conjunction with the functions
  [`anova_test()`](https://rpkgs.datanovia.com/rstatix/reference/anova_test.html)
  and
  [`t_test()`](https://rpkgs.datanovia.com/rstatix/reference/t_test.html)
  from the ‘rstatix’ R package, and to be used in inline r code within R
  Markdown and Quarto documents.
  [`report_anova()`](https://kyleofcanada.github.io/statsreportr/reference/report_anova.md)
  also works with [`aov()`](https://rdrr.io/r/stats/aov.html) objects by
  running
  [`rstatix::anova_summary()`](https://rpkgs.datanovia.com/rstatix/reference/anova_summary.html)
  on the object before reporting the results.

- [`format_p()`](https://kyleofcanada.github.io/statsreportr/reference/format_p.md)
  added to the package. This function is used to format p-values in a
  report-ready format. It is mainly used to format the p-values within
  the `report_*()` functions, but is available for use in other contexts
  as well.
