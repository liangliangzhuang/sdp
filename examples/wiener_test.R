# Simulation
dat = sim_dat(group = 6 , t = 1:200, para = c(2,3))
plot_path(dat)
# MLE ========
mle_fit = sta_infer(method = "MLE", process = "Wiener",type = "classical",
                    data = dat)
mle_fit

Wiener_R_plot(R_time = 1:150,sum_para = mle_fit,threshold = 150)
Wiener_RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:150,
                threshold = 150,zlim = c(0,0.08),xlim = c(0,150),
                para = mle_fit[,2],
                real_RUL=c(48,46,43,41,38,36,33)+40)

# Bayes ======
fit1 = sta_infer(method = "Bayes", process = "Wiener",type = "classical",
                 data = dat)
bayes_fit = summary(fit1)$summary[c(1,2),c(4,1,8)] #
bayes_fit[2,] = 1/bayes_fit[2,]
print(fit1, probs = c(0.025,0.5,0.975),pars = c("mu","w"))
plot(fit1)
traceplot(fit1,pars = c("mu","w"), inc_warmup = T,nrow = 1) + theme(legend.position = "top")

Wiener_R_plot(R_time = 1:150,sum_para = bayes_fit,threshold = 150)
Wiener_RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:150,
                threshold = 150,zlim = c(0,0.08),xlim = c(0,150),
                para = bayes_fit[,2],
                real_RUL=c(48,46,43,41,38,36,33)+40)



