# library(dplyr)
# library(stringr)

format_p <- function(p_value, digits = 3) {
  
  dplyr::case_when(
    p_value > .1 ~ stringr::str_c("= ", round(p_value, digits)),
    p_value > .05 ~ stringr::str_c("= ", round(p_value, digits)),
    p_value > .01 ~ stringr::str_c("= ", round(p_value, digits + 1)),
    p_value > .001 ~ stringr::str_c("= ", round(p_value, digits + 2)),
    p_value > .0001 ~ "< 0.001",
    TRUE ~ "< 0.0001",
  )
}