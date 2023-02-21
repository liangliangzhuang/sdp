# 伽马过程 ===============
dat = sim_dat(group = 10, t = 1:100, para = c(3,3),process = "Gamma")
plot_path(dat[[1]])
# 矩估计 ======
# me_fit = sta_infer(method = "ME", process = "Gamma",type = "classical",
#                    data = dat[[1]])
# me_fit
# gamma_moment(data = dat[[1]])

# 极大似然估计 ========
# gamma_mle = optim(par=c(3,3), fn = Gamma_mle,
#       data = dat[[1]], method = "BFGS", hessian = TRUE)
# gamma_mle$par
mle_fit = sta_infer(method = "MLE", process = "Gamma",type = "classical",
                    data = dat[[1]])
mle_fit

# 贝叶斯估计 =========
Bayes = sta_infer(method = "Bayes", process = "Gamma",type = "classical",
                 data = dat[[1]])
bayes_fit = summary(Bayes)$summary[c(1,2),c(4,1,8)] #
print(bayes_fit, probs = c(0.025,0.5,0.975),pars = c("mu","w"))
plot(Bayes)
traceplot(Bayes,pars = c("mu","w"), inc_warmup = T,nrow = 1) + theme(legend.position = "top")


## 可靠度和RUL
Reliability_plot(R_time = 1:50,sum_para = mle_fit,threshold = 150,
                 process = "Gamma",type = "classical")

RUL(t = 1:100, cur_time = 100, threshold = 150, data = dat[[1]],
    par = mle_fit[,2], process = "Gamma", type = "classical")

# RUL计算和绘图有问题
RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:300,
         threshold = 300,zlim = c(0,0.5),xlim = c(0,300),
         para = mle_fit[,2], process = "Gamma", type = "classical",
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
