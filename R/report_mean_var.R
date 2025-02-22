# mean_sd -----------------------------------------------------------------

#' Report the mean and standard deviation in text
#'
#' @param .data A data frame
#' @param value_var The name of the variable to report
#' @param group_var The name of the grouping variable
#' @param effect The name or row number of the effect to report
#' @param digits The number of digits to round the p value to
#'
#' @returns A string with the mean and standard deviation of the variable in the format: "mean ± sd"
#' @export
#'
#' @examples
#' mtcars |> report_mean_sd(value_var = mpg)
#' mtcars |> report_mean_sd(mpg, cyl, effect = "6")
report_mean_sd <- function(
  .data,
  value_var,
  group_var = NULL,
  effect = 1,
  digits = 3
) {
  if (!is.data.frame(.data)) {
    stop("The data must be a data frame")
  }

  if (nrow(.data) == 0) {
    stop("The data frame is empty")
  }

  #fmt: skip
  # if(!is.null({{ group_var  }})){
  #   if (!({{ group_var }} %in% names(data))) {
  #     stop("The group variable is not in the data frame")
  #   }
  # }

  #fmt: skip
  # if (!({{ value_var }} %in% names(data))) {
  #   stop("The value variable is not in the data frame")
  # }

  if (!is.numeric(digits)) {
    stop("The digits must be a number")
  }

  dat <- .data |>
    dplyr::group_by({{ group_var }}) |>
    dplyr::summarise(
      mean = mean({{ value_var }}, na.rm = TRUE),
      sd = stats::sd({{ value_var }}, na.rm = TRUE)
    )

  if (is.character(effect)) {
    effect <- which(dat[, 1] == effect)

    if (length(effect) == 0) {
      stop("The effect name is not in the data table")
    }
  }

  if (effect > nrow(dat)) {
    stop(
      "The effect number is greater than the number of effects in the data table"
    )
  }

  stringr::str_c(
    format(
      dat$mean[effect],
      digits = digits
    ),
    " \u00B1 ",
    format(
      dat$sd[effect],
      digits = digits
    )
  )
}


# mean_sem ----------------------------------------------------------------

#' Report the mean and standard error of the mean in text
#'
#' @param .data A data frame
#' @param value_var The name of the variable to report
#' @param group_var The name of the grouping variable
#' @param effect The name or row number of the effect to report
#' @param digits The number of digits to round the p value to
#'
#' @returns A string with the mean and standard error of the variable in the format: "mean ± sem"
#' @export
#'
#' @examples
#' mtcars |> report_mean_sem(value_var = mpg)
#' mtcars |> report_mean_sem(mpg, cyl, effect = "6")
report_mean_sem <- function(
  .data,
  value_var,
  group_var = NULL,
  effect = 1,
  digits = 3
) {
  if (!is.data.frame(.data)) {
    stop("The data must be a data frame")
  }

  if (nrow(.data) == 0) {
    stop("The data frame is empty")
  }

  #fmt: skip
  # if(!is.null({{ group_var  }})){
  #   if (!({{ group_var }} %in% names(data))) {
  #     stop("The group variable is not in the data frame")
  #   }
  # }

  #fmt: skip
  # if (!({{ value_var }} %in% names(data))) {
  #   stop("The value variable is not in the data frame")
  # }

  if (!is.numeric(digits)) {
    stop("The digits must be a number")
  }

  dat <- .data |>
    dplyr::group_by({{ group_var }}) |>
    dplyr::summarise(
      mean = mean({{ value_var }}, na.rm = TRUE),
      sem = stats::sd({{ value_var }}, na.rm = TRUE) /
        sqrt(length({{ value_var }}))
    )

  if (is.character(effect)) {
    effect <- which(dat[, 1] == effect)

    if (length(effect) == 0) {
      stop("The effect name is not in the data table")
    }
  }

  if (effect > nrow(dat)) {
    stop(
      "The effect number is greater than the number of effects in the data table"
    )
  }

  stringr::str_c(
    format(
      dat$mean[effect],
      digits = digits
    ),
    " \u00B1 ",
    format(
      dat$sem[effect],
      digits = digits
    )
  )
}
