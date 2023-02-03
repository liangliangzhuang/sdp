sim_dat = function(group, t, para){
  # para 指 mu,sigma
  # epoch 指测量次数，group 指组数
  delta_t = diff(t)
  epoch = length(delta_t)
  dat = matrix(NA,epoch,group+1)
  dat[,1] = seq(1,epoch)
  dat_unit = numeric()
  for(i in 1:group){
    for(j in 1:epoch) dat_unit[j] = rnorm(1,para[1]*delta_t[j],sqrt(para[2]^2*delta_t[j]))
    dat[,i+1] = cumsum(dat_unit)
  }
  dat = data.frame(dat)
  dat1 = rbind(rep(0,group+1),dat) # 加入初始值绘制点
  colnames(dat1) = c("Time",paste(1:group,sep=''))
  return(dat1)
}
