#' Remaining Useful Life
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#'
#' @param t time.
#' @param cur_time current time.
#' @param threshold threshold of a degradation path.
#' @param data degradation data.
#' @param par parameters of a certain model.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' #' dat = sim_dat(group = 6, t = 1:200, para = c(2,3),process = "Wiener")
#' @export
#' @importFrom expint gammainc
#'
RUL = function(t, cur_time, threshold, data,
               par, process, type){
  RUL = list()
  cur_path = as.numeric(data[cur_time,])
  if(process == "Wiener"){
    for(i in 1:(ncol(data)-1)) {
      RUL[[i]] = numeric()
      RUL[[i]] = (threshold - cur_path[i])/(sqrt(2*pi*par[2]^2*t^3)) * exp(-(threshold- cur_path[i] - par[1] * t)^2/(2 * par[2]^2 * t))
    }
  } else if(process == "Gamma"){
    for(i in 1:(ncol(data)-1)){
      RUL[[i]] = numeric()
      RUL[[i]] = expint::gammainc(par[1] * (t[t>cur_time] - cur_time), (threshold - cur_path[i])/par[2])/
        gamma(par[1] * (t[t>cur_time] - cur_time))
    }
  } else if(process == "IG"){
    for(i in 1:(ncol(data)-1)){
      RUL[[i]] = numeric()
      ll = sqrt(par[2])/sqrt((threshold - cur_path[i]))
      RUL[[i]] = dnorm(ll * (t - threshold/par[1])) * ll - 2*par[2]/par[1] * exp(2 * par[2] * t / par[1]) * pnorm(- ll * ((threshold - cur_path[i])/par[1] + t)) +
        exp(2*par[2]*t/par[1]) * dnorm(-ll * ((threshold - cur_path[i])/par[1] + t) ) * ll
    }
  }
  return(RUL)
}





