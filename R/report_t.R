#' Report a t test result in text
#'
#' @param ttest an rstatix::t_test object
#' @param effect The names or row number of the effect to report
#' @param digits The number of digits to round the p value to
#' @param cohensd An rstatix::cohens_d object to include the effect size in the report
#' @param cohens_magnitude A logical indicating if the effect size magnitude should be included in the report
#'
#' @returns A string with the formatted t test result for use in line in an R Markdown or Quarto document
#' @export
#'
#' @examples
#' library(rstatix)
#'
#' results <- t_test(mtcars, mpg ~ am)
#'
#' report_t(results)
#'
#' results2 <- t_test(mtcars, mpg ~ cyl)
#'
#' cohensd2 <- cohens_d(mtcars, mpg ~ cyl)
#'
#' report_t(results2, cohensd = cohensd2, cohens_magnitude = TRUE)
#'
#' report_t(results2, effect = c("4", "6"))

report_t <- function(ttest, effect = 1, digits = 3, cohensd = NULL, cohens_magnitude = FALSE) {
  if (!("rstatix_test" %in% attributes(ttest)$class) |
      !("t_test" %in% attributes(ttest)$class)) {
    stop("The t test input must be an rstatix::t_test object")
  }

  if (is.character(effect)) {
    if (length(effect) != 2) {
      stop("The effect must be a vector of length 2 corresponding to the group1 and group2 columns in the t test")
    }

    effect <- which(ttest$group1 == effect[1] & ttest$group2 == effect[2])

    if (length(effect) == 0) {
      stop("The pair of effects are not in the t_test table")
    }
  }

  if (effect > nrow(ttest)) {
    stop("The effect number is greater than the number of effects in the t_test table")
  }

  if (!is.null(cohensd)) {

    if (!("rstatix_test" %in% attributes(cohensd)$class) |
        !("cohens_d" %in% attributes(cohensd)$class)) {
      stop("The cohens d input must be an rstatix::cohens_d object")
    }

    if (!all(cohensd$.y. == ttest$.y.) & !all(cohensd$group1 == ttest$group1) & !all(cohensd$group2 == ttest$group2)) {
      stop("The cohens_d must analyze the same effects as the t_test")
    }

    if (!("cohens_d" %in% attributes(cohensd)$class)) {
      stop("The cohens_d input must be an rstatix::cohens_d object")
    }

    if (!is.logical(cohens_magnitude)) {
      stop("The cohens_magnitude input must be a logical")
    }
  }

  if ("p.adj" %in% colnames(ttest)) {
    p_value <- ttest$p.adj[effect]

    p_report <- stringr::str_c(", adjusted *p* ",
                               format_p(p_value, digits = digits))
  } else {
    p_value <- ttest$p[effect]

    p_report <- stringr::str_c(", *p* ",
                               format_p(p_value, digits = digits))
  }

  cohens_report <- NULL

  if (!is.null(cohensd)) {
    cohens_report <- stringr::str_c(", *d* = ",
                                    format(cohensd$effsize[effect],
                                           digits = digits))

    if (cohens_magnitude) {
      cohens_report <- stringr::str_c(cohens_report,
                                      ", indicating a ",
                                      cohensd$magnitude[effect],
                                      " effect")
    }
  }

  stringr::str_c("*t*~(",
                 format(ttest$df[effect], digits = digits),
                 ")~ = ",
                 format(ttest$statistic[effect], digits = digits),
                 p_report,
                 cohens_report)
}
