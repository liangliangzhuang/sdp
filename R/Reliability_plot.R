#' Reliability_plot
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#' @param R_time R_time
#' @param sum_para  sum_para
#' @param threshold a vector of thresholds for each group.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#' @param s  stress.
#' @param rel relationship.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' @import ggplot2
#' @export
#'
Reliability_plot <- function(R_time = 1:300,
                             sum_para = fit,
                             threshold = 150,
                             process = "Wiener",
                             type = "classical",
                             rel = rel,
                             s = s) {
  R_data <- data.frame(
    "Time" = R_time,
    "Up" = Reliability(t = R_time, threshold = threshold, par = sum_para[, 3],
                       process = process, type = type, rel = rel, s = s),
    "Mean" = Reliability(t = R_time, threshold = threshold, par = sum_para[, 2],
                         process = process, type = type, rel = rel, s = s),
    "Low" = Reliability(t = R_time, threshold = threshold, par = sum_para[, 1],
                        process = process, type = type, rel = rel, s = s)
  )
  # 绘制带区间估计的可靠度函数
  p <- ggplot(R_data) +
    geom_line(aes(Time, Up), color = "gray60", linetype = 2) +
    geom_line(aes(Time, Mean)) +
    geom_line(aes(Time, Low), color = "gray60", linetype = 2) +
    ylab("Reliability") +
    xlab("time")
  return(p)
}
