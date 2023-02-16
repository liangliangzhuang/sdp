MLE = function(par = c(1,1),data = dat, process = "Wiener"){
  # 输入：mu，sigma，数据
  # 输出：负对数似然函数
  # mu = par[1]; sigma = par[2]
  group = ncol(data) - 1;time = data[,1];y = data[-1,-1]
  # 差分得到delta_time和delta_y
  delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
  delta_y = matrix(NA,nrow(delta_time),group)
  for(i in 1:group) delta_y[,i] = cumsub(y[,i])
  if(process == "Wiener"){
    logl = -1/2 * sum(log(delta_time)) - group*nrow(delta_time)*log(par[2]) - sum((delta_y - par[1] * delta_time)^2/(2*par[2]^2*delta_time),na.rm =T)
  } else if(process == "Gamma"){
    logl = sum((par[1] * delta_time -1) * log(delta_y)) - group * par[1] * (time[length(time)]+1) * log(par[2]) -
      sum(log(gamma(par[1]*delta_time))) - sum(y[nrow(y),]/par[2])
  } else if(process == "IG"){
    logl = nrow(delta_time)*group * (1/2 * log(par[2]) + log(par[1])) +
      sum(log(delta_time) - 1/2 * log(2*pi*delta_y^3) - (par[2]*(delta_y - par[1]*delta_time)^2)/(2*delta_time),na.rm =T)
  }
  return(-logl)
}


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

Gamma_mle = function(par = c(2,2),data = dat[[1]]){
  # 输入：alpha，beta，数据
  # 输出：负对数似然函数
  alpha = par[1]; beta = par[2]
  group = ncol(data) - 1;time = data[,1];y = data[-1,-1]
  # 差分得到delta_time和delta_y
  delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
  delta_y = matrix(NA,nrow(delta_time),group)
  for(i in 1:group) delta_y[,i] = cumsub(y[,i])

  logl = sum((alpha * delta_time -1) * log(delta_y)) - group * alpha * (time[length(time)]+1) * log(beta) -
               sum(log(gamma(alpha*delta_time))) - sum(y[nrow(y),]/beta)

  return(-logl)
}


IG_mle = function(par = c(1,1),data = dat){
  # 输入：eta，lambda 数据
  # 输出：负对数似然函数
  group = ncol(data) - 1;time = data[,1];y = data[-1,-1]
  # 差分得到delta_time和delta_y
  delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
  delta_y = matrix(NA,nrow(delta_time),group)
  for(i in 1:group) delta_y[,i] = cumsub(y[,i])
  logl = nrow(delta_time)*group * (1/2 * log(par[2]) + log(par[1])) + sum(log(delta_time) - 1/2 * log(2*pi*delta_y^3) - (par[2]*(delta_y - par[1]*delta_time)^2)/(2*delta_time),na.rm =T)
  return(-logl)
}

