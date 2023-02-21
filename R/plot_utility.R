#' Remaining Useful Life
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#'
#' @param data data.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' dat <- sim_dat(group = 6, t = 1:200, para = c(2, 3), process = "Wiener")
#' plot_path(dat[[1]])
#' @export
#' @importFrom tidyr pivot_longer
#' @importFrom viridis scale_color_viridis
#' @import ggplot2
#'
plot_path <- function(data) {
  # 画图
  p <- data %>%
    pivot_longer(paste(1:ncol(data[, -1])),
      names_to = "Group",
      values_to = "y"
    ) %>%
    ggplot(aes(Time, y, color = Group)) +
    geom_line() +
    viridis::scale_color_viridis(discrete = T) +
    ylab("Degradation") #+
  # theme_bw() +
  # theme(panel.grid = element_blank())
  print(p)
}
