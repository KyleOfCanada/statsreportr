#' Report a pairwise comparison result in text
#'
#' @param pairwise_comparison an rstatix::emmeans_test object
#' @param effect The names or row number of the effect to report
#' @param digits The number of digits to round the p value to
#' @param effect_size Whether to include the effect size in the report
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
#' report_pc(results2, effect = 3)
#'
#' report_pc(results2, effect = c("4", "6"))
report_pc <- function(
  pairwise_comparison,
  effect = 1,
  digits = 3,
  effect_size = TRUE
) {
  if (
    !("rstatix_test" %in% attributes(pairwise_comparison)$class) |
      !("emmeans_test" %in% attributes(pairwise_comparison)$class)
  ) {
    stop(
      "The pairwise comparison input must be an rstatix::emmeans_test object"
    )
  }

  if (!is.logical(effect_size)) {
    stop("The effect_size argument must be TRUE or FALSE")
  }

  reverse_effect_size <- FALSE

  if (is.character(effect)) {
    if (length(effect) != 2) {
      stop(
        "The effect must be a vector of length 2 corresponding to the group1 and group2 columns in the emmeans test"
      )
    }

    effect_row <- which(
      pairwise_comparison$group1 == effect[1] &
        pairwise_comparison$group2 == effect[2]
    )

    if (length(effect_row) == 0) {
      effect_row <- which(
        pairwise_comparison$group1 == effect[2] &
          pairwise_comparison$group2 == effect[1]
      )

      reverse_effect_size <- TRUE

      if (length(effect_row) == 0) {
        stop("The pair of effects are not in the emmeans_test table")
      }
    }
  } else if (is.numeric(effect) & length(effect) != 1) {
    stop(
      "The effect must be a single numeric value or a vector of length 2 corresponding to the group1 and group2 columns in the emmeans test"
    )
  } else if (!is.numeric(effect)) {
    stop(
      "The effect must be a single numeric value or a vector of length 2 corresponding to the group1 and group2 columns in the emmeans test"
    )
  } else {
    effect_row <- effect
  }

  if (is.numeric(effect)) {
    if (effect < 1) {
      stop("The effect number must be greater than 0")
    }

    if (effect > nrow(pairwise_comparison)) {
      stop(
        "The effect number is greater than the number of effects in the emmeans_test table"
      )
    }
  }

  if (!is.numeric(digits)) {
    stop("The digits argument must be a number")
  }

  if (attributes(pairwise_comparison)$args$p.adjust.method == "none") {
    p_value <- pairwise_comparison$p[effect_row]

    p_report <- stringr::str_c(
      ", *p* ",
      format_p(p_value, digits = digits)
    )
  } else {
    p_value <- pairwise_comparison$p.adj[effect_row]

    p_report <- stringr::str_c(
      ", adjusted *p* ",
      format_p(p_value, digits = digits)
    )
  }

  if (effect_size) {
    formula_ef <- stats::formula(paste(
      pairwise_comparison$.y.[effect_row],
      "~",
      pairwise_comparison$term[effect_row]
    ))
    data_ef <- attributes(pairwise_comparison)$args$data

    y_ef <- which(colnames(data_ef) == pairwise_comparison$term[effect_row])

    if (reverse_effect_size) {
      group1_ef <- pairwise_comparison$group2[effect_row]
      group2_ef <- pairwise_comparison$group1[effect_row]
    } else {
      group1_ef <- pairwise_comparison$group1[effect_row]
      group2_ef <- pairwise_comparison$group2[effect_row]
    }

    if (
      is.numeric(
        data_ef |>
          dplyr::pull(y_ef)
      )
    ) {
      rows_ef <- which(
        data_ef |>
          dplyr::pull(y_ef) |>
          as.character() %in%
          c(
            group1_ef,
            group2_ef
          )
      )
    } else {
      rows_ef <- which(
        data_ef |>
          dplyr::pull(y_ef) %in%
          c(
            group1_ef,
            group2_ef
          )
      )
    }

    data_ef <- data_ef[rows_ef, ]

    lm_ef <- stats::lm(formula_ef, data_ef)
    em_ef <- emmeans::emmeans(
      lm_ef,
      pairwise_comparison$term[effect_row],
      adjust = attributes(pairwise_comparison)$args$p.adjust.method
    )

    ef_size <- emmeans::eff_size(
      em_ef,
      sigma = stats::sigma(lm_ef),
      edf = pairwise_comparison$df[effect_row]
    )

    ef_size <- summary(ef_size)$effect.size

    ef_size <- dplyr::if_else(
      reverse_effect_size,
      true = ef_size * -1,
      false = ef_size
    ) |>
      format(digits = digits)

    p_report <- stringr::str_c(
      p_report,
      ", *d* = ",
      ef_size
    )
  }

  stringr::str_c(
    "*t*~(",
    format(pairwise_comparison$df[effect_row], digits = digits),
    ")~ = ",
    format(pairwise_comparison$statistic[effect_row], digits = digits),
    p_report
  )
}
