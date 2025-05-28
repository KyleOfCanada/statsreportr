#' Report correlation result in text
#'
#' @param cor_test an rstatix::cor_test object
#' @param effect the names or row number of the Effect to report
#' @param digits the number of digits to round the p value to
#'
#' @returns a string with the formatted correlation result for use inline in an R Markdown or Quarto document
#' @export
#'
#' @examples
#' results <- mtcars |> cor_test(mpg, wt)
#' report_cor(results)
#'
#' results2 <- mtcars |>
#'  dplyr::group_by(cyl) |>
#'  cor_test(mpg, wt, method = "spearman")
#'
#' report_cor(results2, effect = 2)
#'
#' results3 <- mtcars |>
#'   cor_test(
#'     vars = "mpg",
#'     vars2 = c("disp", "hp", "drat"),
#'     method = "kendall"
#'   )
#'
#'  report_cor(results3, effect = c("mpg", "disp"))

report_cor <- function(
  cor_test,
  effect = 1,
  digits = 3
) {
  if (!("cor_test" %in% attributes(cor_test)$class)) {
    stop(
      "The cor_test input must be an rstatix::cor_test object"
    )
  }

  if (is.character(effect)) {
    if (length(effect) != 2) {
      stop(
        "The effect must be a vector of length 2 corresponding to the var1 and var2 columns in the cor test"
      )
    }

    effect <- which(
      cor_test$var1 == effect[1] & cor_test$var2 == effect[2]
    )

    if (length(effect) == 0) {
      stop("The pair of effects are not in the cor_test table")
    }
  }

  if (effect > nrow(cor_test)) {
    stop(
      "The effect number is greater than the number of effects in the cor_test table"
    )
  }

  if (!is.numeric(digits)) {
    stop("The digits argument must be a number")
  }

  if (!(cor_test$method[effect] %in% c("Pearson", "Spearman", "Kendall"))) {
    stop("The correlation method is not supported")
  }

  p_value <- cor_test$p[effect]

  p_report <- stringr::str_c(
    ", *p* ",
    format_p(p_value, digits = digits)
  )

  if (cor_test$method[effect] == "Pearson") {
    stringr::str_c(
      "*r*",
      "~(",
      cor_test$df[effect],
      ")~",
      " = ",
      format(cor_test$cor[effect], digits = digits),
      p_report
    )
  } else if (cor_test$method[effect] == "Spearman") {
    stringr::str_c(
      "$\\rho$",
      " = ",
      format(cor_test$cor[effect], digits = digits),
      ", *S* = ",
      format(cor_test$statistic[effect], digits = digits),
      p_report
    )
  } else if (cor_test$method[effect] == "Kendall") {
    stringr::str_c(
      "*$\\tau$*",
      " = ",
      format(cor_test$cor[effect], digits = digits),
      ", *T* = ",
      format(cor_test$statistic[effect], digits = digits),
      p_report
    )
  }
}
