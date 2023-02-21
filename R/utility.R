#' Remaining Useful Life
#' @param x data.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @export
cumsub <- function(x) {
  # 完成逐个相减功能，类似cumsum
  re <- numeric()
  re[1] <- x[1]
  for (i in 2:length(x)) {
    re[i] <- x[i] - x[i - 1]
  }
  return(re)
}
