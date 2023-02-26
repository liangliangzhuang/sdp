MLE <- function(par = c(3, 3),
                data = NULL,
                process = "Wiener",
                type = "classical",
                s = NULL,
                rel = NULL) {
  # Input: par = c(mu, sigma), data, ...
  # Output: Negative log-likelihood function
  options(warn = -1)
  if(type == "classical"){
    # Some error messages
    if(length(par) != 2) stop("The `par` vector is inconsistent, it should be 2.")

    group <- ncol(data[[1]]) - 1; time <- data[[1]][, 1]; y <- data[[1]][-1, -1]
    # Difference to get delta_time and delta_y
    delta_time <- matrix(rep(diff(time), group), length(diff(time)), group)
    delta_y <- sapply(y,cumsub)

    if (process == "Wiener") {
      logl <- -1 / 2 * sum(log(delta_time)) - group * nrow(delta_time) * log(par[2]) - sum((delta_y - par[1] * delta_time)^2 / (2 * par[2]^2 * delta_time), na.rm = T)
    } else if (process == "Gamma") {
      logl <- sum((par[1] * delta_time - 1) * log(delta_y)) -
        group * par[1] * (time[length(time)] + 1) * log(par[2]) -
        sum(log(gamma(par[1] * delta_time))) - sum(y[nrow(y), ] / par[2])
    } else if (process == "IG") {
      logl <- nrow(delta_time) * group * 1 / 2 * log(par[2]) + sum(log(delta_time) - 3 / 2 * log(delta_y) - (par[2] * (delta_y - par[1] * delta_time)^2) / (2 * par[1]^2 * delta_y), na.rm = T)
    }
  } else if(type == "acc"){
    # Some error messages
    if(length(par) != 3) stop("The `par` vector is inconsistent, it should be 3.")
    logl = numeric()
    mu = exp(par[1] + par[2] * acc_stress(s=s, rel = rel))
    for(k in 1:length(s)){
      group <- ncol(data[[k]]) - 1; time <- data[[k]][, 1]; y <- data[[k]][-1, -1]
      # Difference to get delta_time and delta_y
      delta_time <- matrix(rep(diff(time), group), length(diff(time)), group)
      delta_y <- sapply(y,cumsub)
      if (process == "Wiener") {
        logl[k] <- -1 / 2 * sum(log(delta_time)) - group * nrow(delta_time) * log(par[3]) - sum((delta_y - mu[k] * delta_time)^2 / (2 * par[3]^2 * delta_time), na.rm = T)
      } else if (process == "Gamma") {
        logl[k] <- sum((mu[k] * delta_time - 1) * log(delta_y)) -
          group * mu[k] * (time[length(time)] + 1) * log(par[3]) -
          sum(log(gamma(mu[k] * delta_time))) - sum(y[nrow(y), ] / par[3])
      } else if (process == "IG") {
        logl[k] <- nrow(delta_time) * group * 1 / 2 * log(par[3]) +
          sum(log(delta_time) - 3 / 2 * log(delta_y) - (par[3] * (delta_y - mu[k] * delta_time)^2) / (2 * mu[k]^2 * delta_y), na.rm = T)
      }
    }
  }
  return(-sum(logl))
}


# Weiner_mle = function(par = c(1,1),data = dat){
#   # 输入：mu，sigma，数据
#   # 输出：负对数似然函数
#   mu = par[1]; sigma = par[2]
#   group = ncol(data) - 1;time = data[,1];y = data[-1,-1]
#   # 差分得到delta_time和delta_y
#   delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
#   delta_y = matrix(NA,nrow(delta_time),group)
#   for(i in 1:group) delta_y[,i] = cumsub(y[,i])
#
#   logl = -1/2 * sum(log(delta_time)) - group*nrow(delta_time)*log(sigma) - sum((delta_y - mu * delta_time)^2/(2*sigma^2*delta_time),na.rm =T)
#
#   return(-logl)
# }
#
# Gamma_mle = function(par = c(2,2),data = dat[[1]]){
#   # 输入：alpha，beta，数据
#   # 输出：负对数似然函数
#   alpha = par[1]; beta = par[2]
#   group = ncol(data) - 1;time = data[,1];y = data[-1,-1]
#   # 差分得到delta_time和delta_y
#   delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
#   delta_y = matrix(NA,nrow(delta_time),group)
#   for(i in 1:group) delta_y[,i] = cumsub(y[,i])
#
#   logl = sum((alpha * delta_time -1) * log(delta_y)) - group * alpha * (time[length(time)]+1) * log(beta) -
#                sum(log(gamma(alpha*delta_time))) - sum(y[nrow(y),]/beta)
#
#   return(-logl)
# }
#
#
# IG_mle = function(par = c(1,1),data = dat){
#   # 输入：eta，lambda 数据
#   # 输出：负对数似然函数
#   group = ncol(data) - 1;time = data[,1];y = data[-1,-1]
#   # 差分得到delta_time和delta_y
#   delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
#   delta_y = matrix(NA,nrow(delta_time),group)
#   for(i in 1:group) delta_y[,i] = cumsub(y[,i])
#   logl = nrow(delta_time)*group * (1/2 * log(par[2]) + log(par[1])) + sum(log(delta_time) - 1/2 * log(2*pi*delta_y^3) - (par[2]*(delta_y - par[1]*delta_time)^2)/(2*delta_time),na.rm =T)
#   return(-logl)
# }





