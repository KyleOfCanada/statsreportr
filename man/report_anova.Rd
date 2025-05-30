% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_anova.R
\name{report_anova}
\alias{report_anova}
\title{Report an ANOVA result in text}
\usage{
report_anova(ANOVA, effect = 1, digits = 3)
}
\arguments{
\item{ANOVA}{an rstatix::anova_test object or a stats::aov object}

\item{effect}{The name or row number of the Effect to report}

\item{digits}{The number of digits to round the p value to}
}
\value{
A string with the formatted ANOVA result for use inline in an R Markdown or Quarto document
}
\description{
Report an ANOVA result in text
}
\examples{
library(rstatix)

results <- anova_test(mtcars, mpg ~ cyl * carb)

report_anova(results)
report_anova(results, effect = "cyl")
report_anova(results, effect = 2)
}
