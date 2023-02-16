## 可靠度 =====
Reliability = function(t = 100, threshold = 150,par = mle_par,
                    process = "Wiener",type = "classical"){
  if(process == "Wiener"){
    R = pnorm((threshold - par[1]*t)/(par[2]*sqrt(t))) - exp(2*par[1]*threshold/(par[2]^2)) * pnorm((-threshold - par[1]*t)/(par[2]*sqrt(t)))
  } else if(process == "Gamma"){
    alp = par[1]; beta = par[2]
    v = sqrt(beta/threshold); u = threshold/(alp*beta)
    R = 1-pnorm((sqrt(t/u)-sqrt(u/t))/v)
  }

  return(R)
}

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
