#' Report an ANOVA result in text
#'
#' @param ANOVA an rstatix::anova_test object
#' @param effect The name or row number of the Effect to report
#' @param digits The number of digits to round the p value to
#'
#' @returns A string with the formatted ANOVA result for use in line in a R Markdown or Quarto document
#' @export
#'
#' @examples
#' library(rstatix)
#'
#' results <- anova_test(mtcars, mpg ~ cyl * carb)
#'
#' report_anova(results)
#' report_anova(results, effect = "cyl")
#' report_anova(results, effect = 2)

report_anova <- function(ANOVA, effect = 1, digits = 3) {
  if (!("rstatix_test" %in% attributes(ANOVA)$class) |
      !("anova_test" %in% attributes(ANOVA)$class)) {
    stop("The ANOVA input must be an rstatix::anova_test object")
  }

  if (is.character(effect)) {
    effect <- which(ANOVA$Effect == effect)

    if (length(effect) == 0) {
      stop("The effect name is not in the ANOVA table")
    }
  }

  if (effect > nrow(ANOVA)) {
    stop("The effect number is greater than the number of effects in the ANOVA table")
  }

  stringr::str_c("*F*~(",
                 ANOVA$DFn[effect],
                 ",",
                 ANOVA$DFd[effect],
                 ")~ = ",
                 format(ANOVA$F[effect], digits = digits),
                 " *p* ",
                 format_p(ANOVA$p[effect], digits = digits),
                 ", $",
                 "\\eta^2_G$ = ",
                 format(ANOVA$ges[effect], digits = digits))
}
