# Install
devtools::install_github("Liangliangzhuang/sdp",force = TRUE)
library(sdp)

# 维纳过程 ===============
# Simulation
dat = sim_dat(group = 6, t = 1:200, para = c(2,3),process = "Wiener")
plot_path(dat[[1]])
# dim(dat[[1]])  #(200,7)
# dim(dat[[2]])  #(200,7)
# Inference
# MLE ========
mle_fit = sta_infer(method = "MLE", process = "Wiener", type = "classical",
                    data = dat[[1]])
mle_fit
Reliability(t = 50, threshold = 150,par = mle_fit,
                       process = "Wiener",type = "classical")
Reliability_plot(R_time = 1:150,sum_para = mle_fit,threshold = 150,
                 process = "Wiener",type = "classical")

RUL(t = 1:100, cur_time = 100, threshold = 150, data = dat[[1]],
    par = mle_fit[,2], process = "Wiener", type = "classical")

RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:100,
                threshold = 150,zlim = c(0,0.05),xlim = c(0,100),
                para = mle_fit[,2],
                real_RUL=c(NA,NA,NA,NA,NA,NA)+40)

# Bayes ======
fit1 = sta_infer(method = "Bayes", process = "Wiener",type = "classical",
                 data = dat[[1]])
bayes_fit = summary(fit1)$summary[c(1,2),c(4,1,8)] #
bayes_fit[2,] = 1/bayes_fit[2,]
print(fit1, probs = c(0.025,0.5,0.975),pars = c("mu","w"))
plot(fit1)
traceplot(fit1,pars = c("mu","w"), inc_warmup = T,nrow = 1) + theme(legend.position = "top")

Reliability_plot(R_time = 1:50,sum_para = bayes_fit,threshold = 150,
                 process = "Gamma",type = "classical")

RUL(t = 1:100, cur_time = 100, threshold = 150,data = dat[[1]],
    par = bayes_fit[,2], process = "Wiener", type = "classical")

RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:100,
         threshold = 150,zlim = c(0,0.05),xlim = c(0,100),
         para = bayes_fit[,2], process = "Wiener", type = "classical",
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)


