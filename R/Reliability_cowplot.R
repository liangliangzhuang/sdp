#' Reliability_cowplot
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#' @param R_time R_time
#' @param sum_para  sum_para
#' @param threshold a vector of thresholds for each group.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#'
#' @return  Return a plot of panel
#' @examples
#' 1
#' @import ggplot2 viridis
#' @export
#'


Reliability_cowplot <- function(R_time,
                                sum_para,
                                threshold,
                                process,
                                type) {
  options(warn = -1)
  R_data <- data.frame(
    "Time" = rep(R_time, times = length(threshold)),
    "Up" = as.numeric(sapply(threshold, Reliability, t = R_time, par = sum_para[, 3], process = process, type = type)),
    "Mean" = as.numeric(sapply(threshold, Reliability, t = R_time, par = sum_para[, 1], process = process, type = type)),
    "Low" = as.numeric(sapply(threshold, Reliability, t = R_time, par = sum_para[, 2], process = process, type = type)),
    "Class" = rep(1:length(threshold), each = length(R_time))
  )
  R_data %>% pivot_longer(`Up`:`Low`,
    names_to = "Estimate",
    values_to = "Value"
  ) -> R_data_new
  p <- ggplot(R_data_new, aes(Time, Value, color = Estimate)) +
    geom_line() +
    facet_wrap(vars(as.factor(Class)), nrow = 2) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    scale_color_viridis(discrete = T) +
    labs(x = "Time", y = "Reliability")
  return(p)
}

# r1 = Reliability_plot(R_time = 1:400,sum_para = mle_fit,threshold = lithium_battery[[2]][1],
#                       process = "Wiener",type = "classical")
# r2 = Reliability_plot(R_time = 1:400,sum_para = mle_fit,threshold = lithium_battery[[2]][2],
#                       process = "Wiener",type = "classical")
# r3 = Reliability_plot(R_time = 1:400,sum_para = mle_fit,threshold = lithium_battery[[2]][3],
#                       process = "Wiener",type = "classical")
# r4 = Reliability_plot(R_time = 1:400,sum_para = mle_fit,threshold = lithium_battery[[2]][4],
#                       process = "Wiener",type = "classical")
#
# library(cowplot)
# cowplot::plot_grid(r1,r2,r3,r4,nrow = 2,labels = letters[1:4])
