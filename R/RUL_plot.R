#' Remaining Useful Life Ploting
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#'
#' @param fut_time time.
#' @param group group
#' @param time_epoch  time_epoch
#' @param threshold threshold of a degradation path.
#' @param data degradation data.
#' @param para parameters of a certain model.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#' @param zlim zlim.
#' @param xlim  xlim.
#' @param real_RUL real_RUL.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' dat <- sim_dat(group = 5, t = 1:200, para = c(2,3),
#' process = "Wiener",type = "classical")
#' # MLE
#' mle_fit = sta_infer(method = "MLE", process = "Wiener",
#' type = "classical", data = dat)
#' # RUL
#' RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:100,
#' threshold = 150,zlim = c(0,0.05),xlim = c(0,100),data = dat[[1]],
#' para = mle_fit[,2], group = 1, real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
#' @export
#'
RUL_plot <- function(fut_time = c(50, 55, 60, 65, 70, 75, 80),
                     group = 1,
                     time_epoch = 1:100,
                     threshold = 350,
                     data = NULL,
                     para = NULL,
                     process = "Wiener",
                     type = "classical",
                     zlim = c(0, 0.01),
                     xlim = c(0, 300),
                     real_RUL = NULL) {
  if(type == 'acc') stop("This type can not provide a RUL distribution.")
  rul_den <- list() # matrix(NA,length(time_epoch),length(fut_time))
  for (i in 1:length(fut_time)) {
    rul_den[[i]] <- RUL(
      t = time_epoch, cur_time = fut_time[i],
      threshold = threshold, par = para, data = data,
      process = process, type = type
    )[[group]]
  }
  p <- RUL_3D_density(fut_time, time_epoch, rul_den, threshold,
    real_RUL,zlim = zlim, xlim = xlim)
  return(p)
}
