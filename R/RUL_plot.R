#' Remaining Useful Life
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#'
#' @param fut_time time.
#' @param group group
#' @param time_epoch  time_epoch
#' @param zlim zlim.
#' @param xlim  xlim.
#' @param real_RUL real_RUL.
#' @param threshold threshold of a degradation path.
#' @param data degradation data.
#' @param para parameters of a certain model.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' dat <- sim_dat(group = 6, t = 1:200, para = c(2, 3), process = "Wiener")
#' plot_path(dat[[1]])
#' @export
#'
RUL_plot <- function(fut_time = c(50, 55, 60, 65, 70, 75, 80), group = 1,
                     time_epoch = 1:100, threshold = 350, data = dat[[1]],
                     para = mle_par, process = "Wiener", type = "classical",
                     zlim = c(0, 0.08), xlim = c(0, 100), real_RUL = real_RUL) {
  rul_den <- list() # matrix(NA,length(time_epoch),length(fut_time))
  for (i in 1:length(fut_time)) {
    rul_den[[i]] <- RUL(
      t = time_epoch, cur_time = fut_time[i],
      threshold = threshold, par = para, data = data,
      process = process, type = type
    )[[group]]
  }
  p <- RUL_3D_density(fut_time, time_epoch, rul_den, threshold,
    real_RUL,
    zlim = zlim, xlim = xlim
  )
  return(p)
}
