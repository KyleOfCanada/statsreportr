#' Format a p value for presentation in a R Markdown or Quarto document
#'
#' @param p_value The p value to format
#' @param digits The number of digits to round the p value to
#'
#' @returns A string with the formatted p value
#' @export
#'
#' @examples
#' p <- 0.00445463
#' format_p(p)

format_p <- function(p_value, digits = 3) {
  stopifnot(is.numeric(p_value), length(p_value) == 1)

  dplyr::case_when(
    p_value > .1 ~ stringr::str_c("= ", round(p_value, digits)),
    p_value > .05 ~ stringr::str_c("= ", round(p_value, digits)),
    p_value > .01 ~ stringr::str_c("= ", round(p_value, digits + 1)),
    p_value > .001 ~ stringr::str_c("= ", round(p_value, digits + 2)),
    p_value > .0001 ~ "< 0.001",
    TRUE ~ "< 0.0001",
  )
}
