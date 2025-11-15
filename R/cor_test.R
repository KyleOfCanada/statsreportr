# modification of cor_test from the package rstatix. Saves the degrees of freedom in the output.

#'Correlation Test
#'
#'
#'@description Provides a pipe-friendly framework to perform correlation test
#'  between paired samples, using Pearson, Kendall or Spearman method. Wrapper
#'  around the function \code{\link[stats]{cor.test}()}.
#'
#'  Can also performs multiple pairwise correlation analyses between more than
#'  two variables or between two different vectors of variables. Using this
#'  function, you can also compute, for example, the correlation between one
#'  variable vs many.
#'
#'  This is a slight modification of cor_test from the package rstatix. Saves the degrees of freedom of a Pearson correlation in the output.
#'
#'
#'@inheritParams stats::cor.test
#'@inheritParams stats::cor
#'@param data a data.frame containing the variables.
#'@param vars optional character vector containing variable names for
#'  correlation analysis. Ignored when dot vars are specified. \itemize{ \item
#'  If \code{vars} is NULL, multiple pairwise correlation tests is performed
#'  between all variables in the data. \item If \code{vars} contain only one
#'  variable, a pairwise correlation analysis is performed between the specified
#'  variable vs either all the remaining numeric variables in the data or
#'  variables in \code{vars2} (if specified). \item If \code{vars} contain two
#'  or more variables: i) if \code{vars2} is not specified, a pairwise
#'  correlation analysis is performed between all possible combinations of
#'  variables. ii) if \code{vars2} is specified, each element in \code{vars} is
#'  tested against all elements in \code{vars2}}. Accept unquoted
#'  variable names: \code{c(var1, var2)}.
#'@param vars2 optional character vector. If specified, each element in
#'  \code{vars} is tested against all elements in \code{vars2}. Accept unquoted
#'  variable names: \code{c(var1, var2)}.
#'@param ... One or more unquoted expressions (or variable names) separated by
#'  commas. Used to select a variable of interest. Alternative to the argument
#'  \code{vars}.
#'
#'@return return a data frame with the following columns: \itemize{ \item
#'  \code{var1, var2}: the variables used in the correlation test. \item
#'  \code{cor}: the correlation coefficient. \item \code{statistic}: Test
#'  statistic used to compute the p-value. \item \code{p}: p-value. \item
#'  \code{conf.low,conf.high}: Lower and upper bounds on a confidence interval.
#'  \item \code{method}: the method used to compute the statistic.}
#'@seealso \code{\link[rstatix]{cor_mat}()}, \code{\link[rstatix]{as_cor_mat}()}
#' @examples
#'
#' # Correlation between the specified variable vs
#' # the remaining numeric variables in the data
#' #:::::::::::::::::::::::::::::::::::::::::
#' mtcars |> cor_test(mpg)
#'
#' # Correlation test between two variables
#' #:::::::::::::::::::::::::::::::::::::::::
#' mtcars |> cor_test(wt, mpg)
#'
#' # Pairwise correlation between multiple variables
#' #:::::::::::::::::::::::::::::::::::::::::
#' mtcars |> cor_test(wt, mpg, disp)
#'
#' # Grouped data
#' #:::::::::::::::::::::::::::::::::::::::::
#' iris |>
#'   dplyr::group_by(Species) |>
#'   cor_test(Sepal.Width, Sepal.Length)
#'
#' # Multiple correlation test
#' #:::::::::::::::::::::::::::::::::::::::::
#' # Correlation between one variable vs many
#' mtcars |> cor_test(
#'   vars = "mpg",
#'   vars2 = c("disp", "hp", "drat")
#'  )
#'
#' # Correlation between two vectors of variables
#' # Each element in vars is tested against all elements in vars2
#' mtcars |> cor_test(
#'   vars = c("mpg", "wt"),
#'   vars2 = c("disp", "hp", "drat")
#'  )
#'
#'
#'@describeIn cor_test correlation test between two or more variables.
#'@export
cor_test <- function(
  data,
  ...,
  vars = NULL,
  vars2 = NULL,
  alternative = "two.sided",
  method = "pearson",
  conf.level = 0.95,
  use = "pairwise.complete.obs"
) {
  . <- NULL
  .args <- rlang::enquos(vars = vars, vars2 = vars2) |>
    get_quo_vars_list(data, .enquos = _)
  vars <- .args$vars
  vars2 <- .args$vars2
  vars <- data |>
    get_selected_vars(..., vars = vars)
  n.vars <- length(vars)
  data.numeric <- data |>
    select_numeric_columns()
  if (is.null(vars2)) {
    if (is.null(vars)) {
      vars <- vars2 <- colnames(data.numeric)
    } else if (n.vars == 1) {
      vars2 <- colnames(data.numeric) |> setdiff(vars)
    } else if (n.vars == 2) {
      vars2 <- vars[2]
      vars <- vars[1]
    } else if (n.vars > 2) {
      vars2 <- vars
    }
  }

  tmp_dat <- expand.grid(y = vars2, x = vars, stringsAsFactors = FALSE) |>
    as.list() |>
    purrr::pmap(
      cor_test_xy,
      data = data,
      alternative = alternative,
      method = method,
      conf.level = conf.level,
      use = use
    ) |>
    dplyr::bind_rows() |>
    add_class(c("cor_test", "statsreportr_test"))

  attributes(tmp_dat)$args$data <- data
  attributes(tmp_dat)$args$vars <- vars
  attributes(tmp_dat)$args$vars2 <- vars2
  attributes(tmp_dat)$args$alternative <- alternative
  attributes(tmp_dat)$args$method <- method
  attributes(tmp_dat)$args$conf.level <- conf.level
  attributes(tmp_dat)$args$use <- use

  tmp_dat
}

#:::::::::::::::::::::::::::::::::::::::::::::::::::
# Helper functions
#:::::::::::::::::::::::::::::::::::::::::::::::::::

# Correlation test between two variables x and y
#++++++++++++++++++++++++++++++++++++++++++++++++++++
cor_test_xy <- function(
  data,
  x,
  y,
  method = "pearson",
  use = "pairwise.complete.obs",
  ...
) {
  if (dplyr::is_grouped_df(data)) {
    results <- data |>
      rstatix::doo(cor_test_xy, x, y, method = method, use = use, ...)
    return(results)
  }
  # Correlation test, suppress the warning when method = "spearman" or "kendall".
  suppressWarnings(stats::cor.test(
    data[[x]],
    data[[y]],
    method = method,
    use = use,
    ...
  )) |>
    as_tidy_cor() |>
    dplyr::mutate(var1 = x, var2 = y, .before = "cor")
}

# Tidy output for correlation test
as_tidy_cor <- function(x) {
  estimate <- cor <- statistic <- p <-
    conf.low <- conf.high <- method <- df <- NULL
  res <- x |>
    as_tidy_stat() |>
    dplyr::rename(cor = estimate) |>
    dplyr::mutate(cor = signif(cor, 2))
  if (res$method == "Pearson") {
    res |>
      dplyr::select(
        cor,
        statistic,
        df,
        p,
        conf.low,
        conf.high,
        method
      )
  } else {
    res |>
      dplyr::select(cor, statistic, p, method)
  }
}

# Create a tidy statistical output
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Generic function to create a tidy statistical output
as_tidy_stat <- function(x, round.p = TRUE, digits = 3, stat.method = NULL) {
  estimate <- estimate1 <- estimate2 <- p.value <-
    alternative <- p <- .data <- NULL
  res <- broom::tidy(x)
  if (!is.null(stat.method)) {
    res |> dplyr::mutate(method = stat.method) -> res
  } else if ("method" %in% colnames(res)) {
    stat.method <- get_stat_method(x)
    res |> dplyr::mutate(method = stat.method) -> res
  }
  if ("p.value" %in% colnames(res)) {
    res <- res |>
      dplyr::rename(p = p.value)
    if (round.p) {
      res <- res |>
        dplyr::mutate(p = signif(p, digits))
    }
  }
  if ("parameter" %in% colnames(res)) {
    res <- res |>
      dplyr::rename(df = .data$parameter)
  }
  res
}

get_stat_method <- function(x) {
  available.methods <- c(
    "T-test",
    "Wilcoxon",
    "Kruskal-Wallis",
    "Pearson",
    "Spearman",
    "Kendall",
    "Sign-Test",
    "Cohen's d",
    "Chi-squared test"
  )
  used.method <- available.methods |>
    purrr::map(grepl, x$method, ignore.case = TRUE) |>
    unlist()
  if (sum(used.method) > 0) {
    results <- available.methods |>
      magrittr::extract(used.method)
    if (length(results) >= 2) {
      results <- paste(results, collapse = " ")
    }
  } else {
    results <- x$method
  }
  results
}


# Utilities ---------------------------------------------------------------

add_class <- function(x, .class) {
  class(x) <- unique(c(.class, class(x)))
  x
}

get_quo_vars_list <- function(data, .enquos) {
  . <- NULL
  res <- .enquos |>
    purrr::map(~ get_quo_vars(data, .))
  res <- purrr::map(res, function(x) {
    if (length(x) == 0) {
      x <- NULL
    }
    x
  })
  res
}

get_quo_vars <- function(data, vars) {
  if (rlang::quo_is_missing(vars)) {
    return(NULL)
  }
  names(data) |>
    tidyselect::vars_select(!!vars) |>
    magrittr::set_names(NULL)
}

get_selected_vars <- function(x, ..., vars = NULL) {
  if (dplyr::is_grouped_df(x)) {
    x <- x |>
      dplyr::ungroup()
  }
  dot.vars <- rlang::quos(...)
  if (length(vars) > 0) {
    return(vars)
  }
  if (length(dot.vars) == 0) {
    selected <- colnames(x)
  } else {
    selected <- tidyselect::vars_select(names(x), !!!dot.vars)
  }
  selected |> as.character()
}

select_numeric_columns <- function(data) {
  if (dplyr::is_grouped_df(data)) {
    data <- data |>
      dplyr::ungroup()
  }
  data |>
    dplyr::select_if(is.numeric)
}
