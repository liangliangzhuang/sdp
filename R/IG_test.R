# 逆高斯过程 ===============
# Simulation
dat = sim_dat(group = 6, t = 1:200, para = c(5,5),process = "IG")
plot_path(dat[[1]])
# Inference
# MLE ========
# 估计不准确
mle_fit = sta_infer(method = "MLE", process = "IG",type = "classical",
                    data = dat[[1]])
mle_fit
Reliability(t = 50, threshold = 150,par = mle_fit,
            process = "IG",type = "classical")
Reliability_plot(R_time = 1:65,sum_para = mle_fit,threshold = 150,
                 process = "IG",type = "classical")
RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:50,
         threshold = 150,zlim = c(0,0.1),xlim = c(0,50),
         process = "IG", type = "classical",
         para = mle_fit[,2],
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)

# Bayes ======
fit1 = sta_infer(method = "Bayes", process = "IG",type = "classical",
                 data = dat[[1]])
bayes_fit = summary(fit1)$summary[c(1,2),c(4,1,8)] #
print(fit1, probs = c(0.025,0.5,0.975),pars = c("mu","w"))
plot(fit1)
traceplot(fit1,pars = c("mu","w"), inc_warmup = T,nrow = 1) + theme(legend.position = "top")

Reliability_plot(R_time = 1:65,sum_para = bayes_fit, threshold = 150,
                 process = "IG",type = "classical")

RUL(t = 1:100, cur_time = 30, threshold = 150,
    par = bayes_fit[,2], process = "IG", type = "classical")

RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:60,
         threshold = 150,zlim = c(0,0.1),xlim = c(0,60),
         para = bayes_fit[,2], process = "IG", type = "classical",
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)


