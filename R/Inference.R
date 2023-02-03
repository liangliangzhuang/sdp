# 统计推断 =========
Weiner_mle = function(par = c(1,1),data = dat){
  # 输入：mu，sigma，数据
  # 输出：负对数似然函数
  mu = par[1]; sigma = par[2]
  group = ncol(data) - 1;time = data[,1];y = data[-1,-1]
  # 差分得到delta_time和delta_y
  delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
  delta_y = matrix(NA,nrow(delta_time),group)
  for(i in 1:group) delta_y[,i] = cumsub(y[,i])

  logl = -1/2 * sum(log(delta_time)) - group*nrow(delta_time)*log(sigma) - sum((delta_y - mu * delta_time)^2/(2*sigma^2*delta_time),na.rm =T)

  return(-logl)
}

sta_infer = function(method = "MLE", process = "Wiener",type = "classical",
                     data = dat){
  if(method == "MLE"){
    mle_re = optim(par=c(1,1), fn = Weiner_mle,
                   data = dat, method = "BFGS", hessian = TRUE)
    # mle_re
    mle_par = mle_re$par
    # 区间估计
    mle_up = mle_re$par + sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975)
    mle_low = mle_re$par - sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975) #hessian 和协方差矩阵存在逆的关系：https://blog.csdn.net/anruoxi3236/article/details/102005217
    mle_summary = round(cbind(mle_low,mle_re$par,mle_up),3)
    colnames(mle_summary) = c("low","mean","up")
    return(mle_summary)
  } else if(method == "Bayes"){
    # 数据准备
    group = ncol(dat) - 1;time = dat[,1];y = dat[-1,-1];group = ncol(dat[,-1])
    delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
    delta_y = matrix(NA,nrow(delta_time),group)
    for(i in 1:group) delta_y[,i] = cumsub(y[,i])
    # 数据设定
    wiener_data <- list(
      I = nrow(delta_y),
      J = ncol(delta_y),
      x = delta_y,
      t = delta_time
    )
    # 后验抽样
    library(rstan)
    options(mc.cores = parallel::detectCores())
    rstan_options(auto_write = TRUE)
    fit1 = stan(
      file = "utility/wiener_linear.stan",
      data = wiener_data,
      chains = 1,
      warmup = 1000,
      iter = 2000,
      cores = 4,
      refresh = 0
    )
    return(fit1)
  }
}
