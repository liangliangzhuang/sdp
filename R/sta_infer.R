#' Statistical inference
#'
#' This function is used to statistical inference of model parameters.
#' The methods including maximum likelihood estimator and Bayesian inference.
#'
#' @param method  time.
#' @param data degradation data.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#' @param p  in default `p=0.975`.
#' @param par initial parameter.
#' @param chains in default `chains = 1`
#' @param warmup  in default `warmup = 1000`.
#' @param iter in default `iter= 2000`.
#' @param cores cores = 1,
#' @param s  stress.
#' @param rel relationship.
#'
#' @return  Returns a data frame if method is MLE,
#' returns stan raw results if method is Bayes.
#' @examples
#' dat <- sim_dat(group = 5, t = 1:200, para = c(2,3),
#' process = "Wiener",type = "classical",
#' s = NULL, rel = NULL)
#' # MLE
#' mle_fit = sta_infer(method = "MLE", process = "Wiener",
#' type = "classical", data = dat)
#' mle_fit
#' # Bayes
#' library(rstan)
#' bayes_fit = sta_infer(method = "Bayes", process = "Wiener",
#' type = "classical", data = dat)
#' bayes_fit$summary
#' print(bayes_fit$summary, probs = c(0.025,0.5,0.975),pars = c("mu","w"))
#' plot(bayes_fit$stan_re)
#' # traceplot(bayes_fit$stan_re,pars = c("mu","w"),
#' #            inc_warmup = TRUE,nrow = 1) +
#' #    theme(legend.position = "top")
#' @export

sta_infer = function(method = "MLE",
                     process = "Wiener",
                     type = "classical",
                     data = dat,
                     p = 0.975,
                     par = c(1,1),
                     chains = 1,
                     warmup = 1000,
                     iter = 2000,
                     cores = 1,
                     s = NULL,
                     rel = NULL){
  options(warn = -1)
    if(method == "MLE"){
      mle_re = optim(par=par, fn = MLE, process = process, type = type,
                     data = data, s=s,rel = rel,
                     method = "Nelder-Mead", hessian = TRUE)
      mle_par = mle_re$par
      # Interval estimation
      mle_up = mle_re$par + sqrt(diag(solve(mle_re$hessian)))*qnorm(p)
      mle_low = mle_re$par - sqrt(diag(solve(mle_re$hessian)))*qnorm(p)
      mle_summary = round(cbind(mle_low,mle_re$par,mle_up),4)
      colnames(mle_summary) = c("low","mean","up")
      return(mle_summary)
    } else if(method == "Bayes"){
      rstan::rstan_options(auto_write = TRUE)
      options(mc.cores = parallel::detectCores())
      # Data preparation
      if(type == "classical"){
        group = ncol(data[[1]]) - 1;time = data[[1]][,1];y = data[[1]][-1,-1];group = ncol(data[[1]][,-1])
        delta_time = matrix(rep(diff(time),group),length(diff(time)),group)
        delta_y = matrix(NA,nrow(delta_time),group)
        for(i in 1:group) delta_y[,i] = cumsub(y[,i])
        # Data setting
        process_data <- list(I = nrow(delta_y), J = ncol(delta_y), x = delta_y, t = delta_time)

        # Posterior sampling
        stan_model_code = Bayes_stan(process = process, type = type)
        fit1 = rstan::stan(model_code = stan_model_code,
                           data = process_data, chains = chains, warmup = warmup, iter = iter,
                           cores = cores,refresh = 0)

        return(re = list("summary" = round(rstan::summary(fit1)$summary[c(1,2),c(4,1,8)],4),
                    "stan_re" = fit1)) # 给出stan原始的结果，根据这个结果做诊断和可视化
      } else if(type == 'acc'){
        delta_y = delta_time = array(NA,dim = c(dim(dat[[1]])[1]-1,dim(dat[[1]])[2]-1,3))
        for(k in 1:length(s)){
          group = ncol(data[[k]]) - 1;time = data[[k]][,1];y = data[[k]][-1,-1];group = ncol(data[[k]][,-1])
          delta_time[,,k] = matrix(rep(diff(time),group),length(diff(time)),group)
          delta_y[,,k] = sapply(y,cumsub)
        }
        # Data setting
        process_data <- list(I = dim(delta_y)[1], J = dim(delta_y)[2],
                             K = dim(delta_y)[3], x = delta_y, t = delta_time,
                             rels = acc_stress(s=s, rel = rel))
        # Posterior sampling
        stan_model_code = Bayes_stan(process = process, type = type)
        fit1 = rstan::stan(model_code = stan_model_code,
                           data = process_data, chains = chains, warmup = warmup, iter = iter,
                           cores = cores,refresh = 0)

        return(re = list("summary" = round(rstan::summary(fit1)$summary[1:6,c(4,1,8)],4),
                    "stan_re" = fit1)) # 给出stan原始的结果，根据这个结果做诊断和可视化
      }
    }
}


