# 加载所需的库
library(rstan)

dat <- sim_dat(group = 5, t = 1:100, para = c(0.5,0.5,2), process = "Wiener",
               type = "acc", s=c(1,1.1,1.2), rel = "s*1.2")
data = dat
# arr <- array(unlist(data), dim = c(10, 6, 3))
delta_y = delta_time = array(NA,dim = c(dim(dat[[1]])[1]-1,dim(dat[[1]])[2]-1,3))
for(k in 1:length(s)){
  group = ncol(data[[k]]) - 1;time = data[[k]][,1];y = data[[k]][-1,-1];group = ncol(data[[k]][,-1])
  delta_time[,,k] = matrix(rep(diff(time),group),length(diff(time)),group)
  delta_y[,,k] = sapply(y,cumsub)
}


process_data <- list(
  I = dim(delta_y)[1],
  J = dim(delta_y)[2],
  K = dim(delta_y)[3],
  x = delta_y,
  t = delta_time,
  rels = acc_stress(s=s, rel = rel)
)
# 定义stan模型代码
stan_model_code <- "
data {
  int<lower=0> I;
  int<lower=0> J;
  int<lower=0> K;
  real x[I,J,K];
  real t[I,J,K];
  vector[K] rels;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

transformed parameters {
  vector[K] mu;
  mu = exp(a + b * rels);
}

model {
  sigma ~ gamma(1,1);
  a ~ normal(1,100);
  b ~ normal(1,100);
  for(k in 1:K){
    for (i in 1:I){
      for (j in 1:J) {
        x[i,j,k] ~ normal(mu[k] * t[i,j,k], sqrt(1/sigma^2 * t[i,j,k]));
      }
    }
  }
}

"
# 编译stan模型
fit1 = rstan::stan(model_code = stan_model_code,
                   data = process_data, chains = 1, warmup = 1000, iter = 2000,
                   cores = 1,refresh = 0)
fit1
rstan::summary(fit1)$summary[c(1,2,3,4,5,6),c(4,1,8)]

