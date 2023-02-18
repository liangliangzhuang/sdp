## 剩余使用寿命 ========
RUL = function(t = 1:100, cur_time = 30, threshold = 350, data = dat[[1]],
               par = mle_par, process = "Wiener", type = "classical"){
  RUL = list()
  cur_path = as.numeric(data[cur_time,])
  if(process == "Wiener"){
    for(i in 1:(ncol(data)-1)) {
      RUL[[i]] = numeric()
      RUL[[i]] = (threshold - cur_path[i])/(sqrt(2*pi*par[2]^2*t^3)) * exp(-(threshold- cur_path[i] - par[1] * t)^2/(2 * par[2]^2 * t))
    }
  } else if(process == "Gamma"){
    for(i in 1:(ncol(data)-1)){
      RUL[[i]] = numeric()
      RUL[[i]] = expint::gammainc(par[1] * (t[t>cur_time] - cur_time), (threshold - cur_path[i])/par[2])/
        gamma(par[1] * (t[t>cur_time] - cur_time))
    }
  } else if(process == "IG"){
    for(i in 1:(ncol(data)-1)){
      RUL[[i]] = numeric()
      ll = sqrt(par[2])/sqrt((threshold - cur_path[i]))
      RUL[[i]] = dnorm(ll * (t - threshold/par[1])) * ll - 2*par[2]/par[1] * exp(2 * par[2] * t / par[1]) * pnorm(- ll * ((threshold - cur_path[i])/par[1] + t)) +
        exp(2*par[2]*t/par[1]) * dnorm(-ll * ((threshold - cur_path[i])/par[1] + t) ) * ll
    }
  }
  return(RUL)
}


RUL_plot = function(fut_time = c(50,55,60,65,70,75,80), group = 1,
                    time_epoch = 1:100, threshold = 350,
                    para = mle_par, process = "Wiener", type = "classical",
                    zlim = c(0,0.08), xlim = c(0,100), real_RUL=real_RUL){
  rul_den = list() #matrix(NA,length(time_epoch),length(fut_time))
  for(i in 1:length(fut_time)){
    rul_den[[i]] = RUL(t = time_epoch, cur_time = fut_time[i],
                      threshold = threshold, par = para,
                      process = process, type = type)[[group]]
  }
  p = RUL_3D_density(fut_time,time_epoch,rul_den,threshold,
                     real_RUL,zlim = zlim,xlim = xlim)
  return(p)
}


