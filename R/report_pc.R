#' Report a pairwise comparison result in text
#'
#' @param pairwise_comparison an rstatix::emmeans_test object
#' @param effect The names or row number of the effect to report
#' @param digits The number of digits to round the p value to
#'
#' @returns A string with the formatted pairwise comparison result for use inline in an R Markdown or Quarto document
#' @export
#'
#' @examples
#' library(rstatix)
#'
#' results <- emmeans_test(mtcars, mpg ~ am)
#'
#' report_pc(results)
#'
#' results2 <- emmeans_test(mtcars, mpg ~ cyl, p.adjust.method = "none")
#'
#' report_pc(results2)
#'
#' report_pc(results2, effect = c("4", "6"))
report_pc <- function(
  pairwise_comparison,
  effect = 1,
  digits = 3
) {
  if (
    !("rstatix_test" %in% attributes(pairwise_comparison)$class) |
      !("emmeans_test" %in% attributes(pairwise_comparison)$class)
  ) {
    stop(
      "The pairwise comparison input must be an rstatix::emmeans_test object"
    )
  }

  if (is.character(effect)) {
    if (length(effect) != 2) {
      stop(
        "The effect must be a vector of length 2 corresponding to the group1 and group2 columns in the emmeans test"
      )
    }

    effect <- which(
      pairwise_comparison$group1 == effect[1] &
        pairwise_comparison$group2 == effect[2]
    )

    if (length(effect) == 0) {
      stop("The pair of effects are not in the emmeans_test table")
    }
  }

  if (effect > nrow(pairwise_comparison)) {
    stop(
      "The effect number is greater than the number of effects in the emmeans_test table"
    )
  }

  if (!is.numeric(digits)) {
    stop("The digits argument must be a number")
  }

  if (attributes(pairwise_comparison)$args$p.adjust.method == "none") {
    p_value <- pairwise_comparison$p[effect]

    p_report <- stringr::str_c(
      ", *p* ",
      format_p(p_value, digits = digits)
    )
  } else {
    p_value <- pairwise_comparison$p.adj[effect]

    p_report <- stringr::str_c(
      ", adjusted *p* ",
      format_p(p_value, digits = digits)
    )
  }

  stringr::str_c(
    "*t*~(",
    format(pairwise_comparison$df[effect], digits = digits),
    ")~ = ",
    format(pairwise_comparison$statistic[effect], digits = digits),
    p_report
  )
}
