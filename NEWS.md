# statsreportr (development version)

# statsreportr 0.0.0.9001

* `report_mean_sd()` and `report_mean_sem()` added to the package. These functions are used to report the mean and standard deviation or standard error of a dataset, respectively. They are designed to be used in inline r code within R Markdown and Quarto documents.

# statsreportr 0.0.0.9000

* `report_anova()` and `report_t()` added to the package. These functions are used to report the results of ANOVA and t-tests, respectively. They are designed to be used in conjunction with the functions `anova_test()` and `t_test()` from the 'rstatix' R package, and to be used in inline r code within R Markdown and Quarto documents. `report_anova()` also works with `aov()` objects by running `rstatix::anova_summary()` on the object before reporting the results.

* `format_p()` added to the package. This function is used to format p-values in a report-ready format. It is mainly used to format the p-values within the `report_*()` functions, but is available for use in other contexts as well.
