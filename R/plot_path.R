#' Remaining Useful Life
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#'
#' @param data data.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' # data simulation (a Wiener linear process with 5 units)
#' dat <- sim_dat(group = 5, t = 1:200, para = c(2,3),
#' process = "Wiener",type = "classical",
#' s = NULL, rel = NULL)
#' # Plot degradation path
#' library(ggplot2)
#' plot_path(dat)
#' # add ggplot related functions.
#' plot_path(dat) +
#' theme_bw() +
#' theme(panel.grid = element_blank())
#' @export
#' @importFrom viridis scale_color_viridis
#' @import ggplot2 magrittr dplyr
#' @importFrom tidyr pivot_longer
#'

plot_path <- function(data = NULL) {
  # 画图
  # library(tidyr)
  # library(ggplot2)
  options(warn = -1)
  if(is.data.frame(data) == TRUE |(is.list(data) == TRUE & length(data) == 1)
){
    data.frame(data) %>%
      tidyr::pivot_longer(colnames(.)[-1],
                   names_to = "Group",
                   values_to = "y"
      ) -> new_data
    colnames(new_data)[1] = "Time"
    p <- ggplot(new_data,aes(Time, y, color = Group)) +
      geom_line() +
      viridis::scale_color_viridis(discrete = T) +
      ylab("Degradation")
  }
  if(is.list(data) == TRUE && length(data) > 1){
    dim2 = rep(1:length(data), times = sapply(data,dim)[1,])
    data %>% dplyr::bind_rows() %>%
      dplyr::mutate(id = dim2) %>%
      tidyr::pivot_longer(colnames(.)[-c(1,ncol(.))],
                          names_to = "Group",values_to = "y") -> new_data
    colnames(new_data)[1] = "Time"
    p <- ggplot2::ggplot(new_data,aes(Time, y, color = factor(id))) +
      geom_line(aes(shape = Group)) +
      # facet_wrap(vars(stress),scales = "free_y") +
      viridis::scale_color_viridis(discrete = T,name = c("Stress")) +
      ylab("Degradation")
  }
  return(p)
}

