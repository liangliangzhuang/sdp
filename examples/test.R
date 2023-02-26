# Wiener =========================================
# classical ================
library(tidyverse)
library(ggplot2)
dat <- sim_dat(group = 5, t = 1:200, para = c(2,3), process = "Wiener",
               type = "classical", s = NULL, rel = NULL)
plot_path(dat)
mle_fit = sta_infer(method = "MLE", process = "Wiener", type = "classical", data = dat)
bayes_fit = sta_infer(method = "Bayes", process = "Wiener", type = "classical", data = dat)
bayes_fit$summary

reb = Reliability(t = 40, threshold = 100, par = mle_fit[,2],
                  process = "Wiener",type = "classical")
Reliability_plot(R_time = 1:200,sum_para = mle_fit,threshold = 100,
                 process = "Wiener",type = "classical")

rul = RUL(t = 1:100, cur_time = 80, threshold = 150, data = dat[[1]],
          par = mle_fit[,2], process = "Wiener", type = "classical")
rul

RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:100,
         threshold = 150,zlim = c(0,0.05),xlim = c(0,100),
         para = mle_fit[,2], group = 1,
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
RUL_plot(fut_time = c(40,45,50,55,60,65,70),time_epoch = 1:60,
         threshold = 150,zlim = c(0,0.1),xlim = c(0,60),
         para = mle_fit[,2], group = 2,
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
RUL_plot(fut_time = c(30,35,40,45,50,55),time_epoch = 1:60,
         threshold = 150,zlim = c(0,0.14),xlim = c(0,60),
         para = mle_fit[,2], group = 3,
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
RUL_plot(fut_time = c(40,45,50,55,60,65,70),time_epoch = 1:100,
         threshold = 150,zlim = c(0,0.1),xlim = c(0,100),
         para = mle_fit[,2], group = 4,
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
RUL_plot(fut_time = c(40,45,50,55,60,65,70),time_epoch = 1:60,
         threshold = 150,zlim = c(0,0.1),xlim = c(0,60),
         para = mle_fit[,2], group = 5,
         real_RUL=c(NA,NA,NA,NA,NA,NA)+40)

# acc ======================
dat <- sim_dat(group = 5, t = 1:100, para = c(0.5,1,1), process = "Wiener",
               type = "acc", s=c(1,1.1,1.2), rel = 2)
dat
plot_path(dat)

mle_fit = sta_infer(method = "MLE", process = "Wiener", type = "acc", data = dat,
          par = c(1,5,5), rel = 2, s=c(1,1.1,1.2))
mle_fit
bayes_fit = sta_infer(method = "Bayes", process = "Wiener", type = "acc", data = dat,
          par = c(1,5,5), rel = 2, s=c(1,1.1,1.2))
bayes_fit$summary
# exp(par[1] + par[2] * acc_stress(s=1, rel = 2))

Reliability(t = 100, threshold = 150,par = mle_fit[,2],
                  process = "Wiener",type = "acc",rel = 2, s=c(1,1.1,1.2))
Reliability_plot(R_time = 1:150,sum_para = mle_fit,threshold = 120,
                 rel = 2, s=c(1,1.1,1.2),
                 process = "Wiener",type = "acc")



# Gamma =========================================
# classical ================
dat <- sim_dat(group = 5, t = 1:200, para = c(2,3), process = "Gamma",
               type = "classical", s = NULL, rel = NULL)
plot_path(dat)
mle_fit = sta_infer(method = "MLE", process = "Gamma", type = "classical", data = dat)
bayes_fit = sta_infer(method = "Bayes", process = "Gamma", type = "classical", data = dat)
bayes_fit$summary

reb = Reliability(t = 40, threshold = 100, par = mle_fit[,2],
                  process = "Gamma",type = "classical")
Reliability_plot(R_time = 1:200,sum_para = mle_fit,threshold = 500,
                 process = "Gamma",type = "classical")

rul = RUL(t = 1:100, cur_time = 80, threshold = 700, data = dat[[1]],
          par = mle_fit[,2], process = "Gamma", type = "classical")
rul

RUL_plot(fut_time = c(40,50,60,70,80,90,100),time_epoch = 1:100,
         para = mle_fit[,2], process = "Gamma", type = "classical",
         data = dat[[1]],threshold = 300,zlim = c(0,0.1),xlim = c(0,100),
         group = 1, real_RUL=c(NA,NA,NA,NA,NA,NA)+40) #有效果，但是有问题

# acc ======================
dat <- sim_dat(group = 5, t = 1:10, para = c(2,4,2), process = "Gamma",
               type = "acc", s=c(1,1.1,1.2), rel = 2)
dat
plot_path(dat)

# 结果不行错误
mle_fit = sta_infer(method = "MLE", process = "Gamma", type = "acc", data = dat,
          par = c(2,2,2), rel = 2, s=c(1,1.1,1.2))
# 结果可以
bayes_fit = sta_infer(method = "Bayes", process = "Gamma", type = "acc", data = dat,
          par = c(1,2,2), rel = 1, s=c(1,1.1,1.2))


# IG =========================================
# classical ================
dat <- sim_dat(group = 5, t = 1:100, para = c(2,3), process = "IG",
               type = "classical", s = NULL, rel = NULL)
plot_path(dat)
mle_fit = sta_infer(method = "MLE", process = "IG", type = "classical", data = dat)
bayes_fit = sta_infer(method = "Bayes", process = "IG", type = "classical", data = dat)
bayes_fit$summary

reb = Reliability(t = 40, threshold = 100, par = mle_fit[,2],
                  process = "IG",type = "classical")
Reliability_plot(R_time = 1:100,sum_para = mle_fit,threshold = 100,
                 process = "IG",type = "classical")

rul = RUL(t = 1:100, cur_time = 80, threshold = 700, data = dat[[1]],
          par = mle_fit[,2], process = "IG", type = "classical")
rul

RUL_plot(fut_time = c(40,45,50,55,60,65,70),time_epoch = 1:100,
         para = mle_fit[,2], process = "IG", type = "classical",
         data = dat[[1]],threshold = 100,zlim = c(0,0.13),xlim = c(0,100),
         group = 1, real_RUL=c(NA,NA,NA,NA,NA,NA)+40) #有效果，但是有问题



# acc ======================
dat <- sim_dat(group = 5, t = 1:10, para = c(1,0.5,1), process = "IG",
               type = "acc", s=c(1,1.1,1.2), rel = 2)
dat
plot_path(dat)

# 结果不行
sta_infer(method = "MLE", process = "IG", type = "acc", data = dat,
          par = c(3,3,2), rel = 1, s=c(1,1.1,1.2))
# 结果不行
sta_infer(method = "Bayes", process = "IG", type = "acc", data = dat,
          par = c(1,2,2), rel = 1, s=c(1,1.1,1.2))

# exp(par[1] + par[2] * acc_stress(s=1, rel = 2))

Reliability(t = 100, threshold = 150,par = mle_fit[,2],
            process = "Wiener",type = "acc",rel = 2, s=c(1,1.1,1.2))
Reliability_plot(R_time = 1:150,sum_para = mle_fit,threshold = 120,
                 rel = 2, s=c(1,1.1,1.2),
                 process = "Wiener",type = "acc")


