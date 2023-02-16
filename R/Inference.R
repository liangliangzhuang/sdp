# 统计推断 (MLE + Bayes) =========

#'''
#'客观贝叶斯和广义推断还未加入
#'


# MLE + Bayes ============
sta_infer = function(method = "MLE", process = "Wiener", type = "classical",
                     data = dat){
  if(method == "MLE"){
    mle_re = optim(par=c(1,1), fn = MLE, process = process,
                   data = data, method = "BFGS", hessian = TRUE)
    mle_par = mle_re$par
    # 区间估计
    mle_up = mle_re$par + sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975)
    mle_low = mle_re$par - sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975) #hessian 和协方差矩阵存在逆的关系：https://blog.csdn.net/anruoxi3236/article/details/102005217
    mle_summary = round(cbind(mle_low,mle_re$par,mle_up),3)
    colnames(mle_summary) = c("low","mean","up")
    return(mle_summary)
  } else if(method == "Bayes"){
      # 数据准备
      group = ncol(data) - 1;time = data[,1];y = data[-1,-1];group = ncol(data[,-1])
      delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
      delta_y = matrix(NA,nrow(delta_time),group)
      for(i in 1:group) delta_y[,i] = cumsub(y[,i])
      # 数据设定
      process_data <- list(
        I = nrow(delta_y),
        J = ncol(delta_y),
        x = delta_y,
        t = delta_time
      )
      # 后验抽样
      library(rstan)
      options(mc.cores = parallel::detectCores())
      rstan_options(auto_write = TRUE)
      if(process == "Wiener"){
        fit1 = stan(file = "utility/wiener_linear.stan",
          data = process_data, chains = 1, warmup = 1000, iter = 2000,
          cores = 1,refresh = 0)
      }else if(process == "Gamma"){
        fit1 = stan(file = "utility/gamma_linear.stan",
                    data = process_data, chains = 1, warmup = 1000, iter = 2000,
                    cores = 1,refresh = 0)
      }else if(process == "IG"){
        fit1 = stan(file = "utility/ig_linear.stan",
                    data = process_data, chains = 1, warmup = 1000, iter = 2000,
                    cores = 1,refresh = 0)
      }
      return(fit1) # 给出stan原始的结果，根据这个结果做诊断和可视化
  }# else if(method == "ME"){
  #   me_par = gamma_moment(data = dat[[1]])
  #   me_up = c(NA,NA) # 需要加入自助法
  #   me_low =c(NA,NA)
  #   me_summary = round(cbind(me_low,me_par,me_up),3)
  #   colnames(me_summary) = c("low","mean","up")
  #   return(me_summary)
  # }
  }













# else if(process == "Gamma"){
#     if(method == "MLE"){
#       mle_re = optim(par=c(3,3), fn = Gamma_mle,
#                      data = dat[[1]], method = "BFGS", hessian = TRUE)
#       # mle_re
#       mle_par = mle_re$par
#       # 区间估计
#       mle_up = mle_re$par + sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975)
#       mle_low = mle_re$par - sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975) #hessian 和协方差矩阵存在逆的关系：https://blog.csdn.net/anruoxi3236/article/details/102005217
#       mle_summary = round(cbind(mle_low,mle_par,mle_up),3)
#       colnames(mle_summary) = c("low","mean","up")
#       return(mle_summary)
#     } else if(method == "ME"){
#       me_par = gamma_moment(data = dat[[1]])
#       me_up = c(NA,NA)
#       me_low =c(NA,NA)
#       me_summary = round(cbind(me_low,me_par,me_up),3)
#       colnames(me_summary) = c("low","mean","up")
#       return(me_summary)
#     }
#   }else if(process == "IG"){
#     if(method == "MLE"){
#       mle_re = optim(par=c(3,3), fn = IG_mle,
#                      data = dat[[1]], method = "BFGS", hessian = TRUE)
#       # mle_re
#       mle_par = mle_re$par
#       # 区间估计
#       mle_up = mle_re$par + sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975)
#       mle_low = mle_re$par - sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975) #hessian 和协方差矩阵存在逆的关系：https://blog.csdn.net/anruoxi3236/article/details/102005217
#       mle_summary = round(cbind(mle_low,mle_par,mle_up),3)
#       colnames(mle_summary) = c("low","mean","up")
#       return(mle_summary)
#     }else if(method == "Bayes"){
#
#     }
#     }
#
# }
