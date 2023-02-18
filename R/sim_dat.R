
sim_dat = function(group, t, para, process = "Wiener"){
  library(SuppDists)
  # para 指 mu,sigma
  # epoch 指测量次数，group 指组数
  delta_t = diff(t)
  epoch = length(delta_t)
  dat = dat_unit = matrix(NA,epoch,group+1)
  dat[,1] = dat_unit[,1] = seq(1,epoch)
  if(process == "Wiener"){
    for(i in 1:group){
      for(j in 1:epoch){
        dat_unit[j,i+1] = rnorm(1,para[1]*delta_t[j],sqrt(para[2]^2*delta_t[j]))
        dat[,i+1] = cumsum(dat_unit[,i+1])
        }
    }
  } else if(process == "Gamma"){
    for(i in 1:group){
      for(j in 1:epoch)
        dat_unit[j,i+1] = rgamma(1,shape = para[1]*delta_t[j],scale = para[2])
        dat[,i+1] = cumsum(dat_unit[,i+1])
    }
  } else if(process == "IG"){
    for(i in 1:group){
      for(j in 1:epoch)
        dat_unit[j,i+1] = SuppDists::rinvGauss(1,para[1]*delta_t[j], para[2] * (delta_t[j])^2)
        dat[,i+1] = cumsum(dat_unit[,i+1])
    }
  }

  dat1 = rbind(rep(0,group+1),data.frame(dat)) # 加入初始值绘制点
  colnames(dat1) = c("Time",paste(1:group,sep=''))

  dat_unit1 = rbind(rep(0,group+1),data.frame(dat_unit)) # 加入初始值绘制点
  colnames(dat_unit1) = c("Time",paste(1:group,sep=''))
  return(list(dat1,dat_unit1)) # 输出list，dat1是退化量,data_unit1是退化增量
}





