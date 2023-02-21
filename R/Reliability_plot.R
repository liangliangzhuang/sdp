#' Reliability_plot
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#' @param R_time R_time
#' @param sum_para  sum_para
#' @param threshold threshold
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' dat = sim_dat(group = 6, t = 1:200, para = c(2,3),process = "Wiener")
#' mle_fit = sta_infer(method = "MLE", process = "Wiener",type = "classical",
#' data = dat[[1]])
#' Reliability_plot(R_time = 1:150,sum_para = mle_fit,threshold = 150,
#' process = "Wiener",type = "classical")
#' @export
#'
Reliability_plot = function(R_time = 1:300,sum_para = fit,threshold = 150,
                            process = "Wiener",type = "classical"){
  R_data = data.frame("Time" = R_time,
                      "Up" = Reliability(t = R_time, threshold = threshold,par = sum_para[,3],process = process,type = type),
                      "Mean" = Reliability(t = R_time, threshold = threshold,par = sum_para[,2],process = process,type = type),
                      "Low" = Reliability(t = R_time, threshold = threshold,par = sum_para[,1],process = process,type = type))
  # 绘制带区间估计的可靠度函数
  p = ggplot(R_data) +
    geom_line(aes(Time,Up),color = "gray60",linetype = 2) +
    geom_line(aes(Time,Mean)) +
    geom_line(aes(Time,Low),color = "gray60",linetype = 2) +
    ylab("Reliability") + xlab("time")
  return(p)
}
