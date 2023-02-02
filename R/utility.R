# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

sim_dat = function(group, t, para){
  # para 指 mu,sigma
  # epoch 指测量次数， group 指组数
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


plot_path = function(data = dat1){
  # 画图
  p = data %>% pivot_longer(paste(1:ncol(data[,-1])),
                            names_to = "Group",
                            values_to = "y") %>%
    ggplot(aes(Time,y,color = Group)) +
    geom_line() +
    viridis::scale_color_viridis(discrete = T) +
    ylab("Degradation") #+
  #theme_bw() +
  #theme(panel.grid = element_blank())
  print(p)
}
