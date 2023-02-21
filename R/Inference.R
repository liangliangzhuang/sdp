#' Statistical inference
#'
#' This function is used to statistical inference of model parameters.
#' The methods including maximum likelihood estimator and Bayesian inference.
#'
#' @param method  time.
#' @param data degradation data.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#'
#' @return  Returns a data frame if method is MLE,
#' returns stan raw results if method is Bayes.
#' @examples
#' 11
#' @export
#'

sta_infer = function(method, process, type, data){
  options(warn = -1)
  if(method == "MLE"){
    mle_re = optim(par=c(1,1), fn = MLE, process = process,
                   data = data, method = "BFGS", hessian = TRUE)
    mle_par = mle_re$par
    # 区间估计
    mle_up = mle_re$par + sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975)
    mle_low = mle_re$par - sqrt(diag(solve(mle_re$hessian)))*qnorm(0.975)
    mle_summary = round(cbind(mle_low,mle_re$par,mle_up),4)
    colnames(mle_summary) = c("low","mean","up")
    return(mle_summary)
  } else if(method == "Bayes"){
    rstan::rstan_options(auto_write = TRUE)
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
    # library(rstan)
    options(mc.cores = parallel::detectCores())
    if(process == "Wiener"){
      wiener_linear = "data {
                                int<lower=0> I;
                                int<lower=0> J;
                                matrix[I,J] x;
                                matrix[I,J] t;
                              }

                              parameters {
                                real mu;
                                real<lower=0> w;
                              }


                              model {
                                w ~ gamma(1,1);
                                mu ~ normal(0, 100/w);
                                for (i in 1:I){
                                  for (j in 1:J) {
                                    x[i,j] ~ normal(mu * t[i,j], w * t[i,j]);
                                  }
                                }
                              }
                              "
      fit1 = rstan::stan(model_code = wiener_linear,
                  data = process_data, chains = 1, warmup = 1000, iter = 2000,
                  cores = 1,refresh = 0)
    }else if(process == "Gamma"){
      gamma_linear = "data {
                                int<lower=0> I;
                                int<lower=0> J;
                                matrix[I,J] x;
                                matrix[I,J] t;
                              }

                              parameters {
                                real mu;
                                real<lower=0> w;
                              }


                              model {
                                w ~ gamma(1,1);
                                mu ~ normal(0, 100/w);
                                for (i in 1:I){
                                  for (j in 1:J) {
                                    x[i,j] ~ gamma(mu * t[i,j], 1/w);
                                  }
                                }
                              }

        "
      fit1 = rstan::stan(model_code = gamma_linear,
                  data = process_data, chains = 1, warmup = 1000, iter = 2000,
                  cores = 1,refresh = 0)
    }else if(process == "IG"){
      ig_linear = "
              functions {
                          real IG_log (real x, real mu, real lambda){
                            // vector [num_elements (x)] prob;
                            real lprob;
                            lprob = log((lambda/(2*pi()*(x^3)))^0.5 * exp(-lambda*(x - mu)^2/(2*mu^2*x)));
                            return lprob;
                          }
                        }


              data {
                int<lower=0> I;
                int<lower=0> J;
                matrix[I,J] x;
                matrix[I,J] t;
              }

              parameters {
                real mu;
                real<lower=0> w;
              }


              model {
                w ~ gamma(1,1); //scale
                mu ~ normal(0, 1); //shape
                for (i in 1:I){
                  for (j in 1:J) {
                    x[i,j] ~ IG_log (mu * t[i,j], w * t[i,j]^2);
                  }
                }
              }
"
      fit1 = rstan::stan(model_code = ig_linear,
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



