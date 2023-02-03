## 可靠度 =====
Wiener_R = function(t = 100, threshold = 150,par = mle_par){
  R = pnorm((threshold - par[1]*t)/(par[2]*sqrt(t))) - exp(2*par[1]*threshold/(par[2]^2)) * pnorm((-threshold - par[1]*t)/(par[2]*sqrt(t)))
  return(R)
}

Wiener_R_plot = function(R_time = 1:300,sum_para = fit,threshold = 150){
  R_data = data.frame("Time" = R_time,
                      "Up" = Wiener_R(t = R_time, threshold = threshold,par = sum_para[,3]),
                      "Mean" = Wiener_R(t = R_time, threshold = threshold,par = sum_para[,2]),
                      "Low" = Wiener_R(t = R_time, threshold = threshold,par = sum_para[,1]))
  # 绘制带区间估计的可靠度函数
  p = ggplot(R_data) +
    geom_line(aes(Time,Up),color = "gray60",linetype = 2) +
    geom_line(aes(Time,Mean)) +
    geom_line(aes(Time,Low),color = "gray60",linetype = 2) +
    ylab("Reliability") + xlab("time")
  return(p)
}
