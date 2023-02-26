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
#' 1
#' @export
#' @importFrom expint gammainc
#'
RUL <- function(t, cur_time, threshold, data,
                par, process, type) {
  if(type == 'acc') stop("This type can not provide a RUL distribution.")
  RUL <- list()
  cur_path <- as.numeric(data[cur_time, ])
  if (process == "Wiener") {
    for (i in 1:(ncol(data) - 1)) {
      RUL[[i]] <- numeric()
      RUL[[i]] <- (threshold - cur_path[i]) / (sqrt(2 * pi * par[2]^2 * t^3)) * exp(-(threshold - cur_path[i] - par[1] * t)^2 / (2 * par[2]^2 * t))
    }
  } else if (process == "Gamma") {
    for (i in 1:(ncol(data) - 1)) {
      RUL[[i]] <- numeric()
      v = sqrt(par[2]/(threshold - cur_path[i])); u = (threshold - cur_path[i])/(par[2]*par[1])
      RUL[[i]] <- 1/(2*sqrt(2*pi) * u * v) * ((u/t)^(1/2) + (u/t)^(3/2)) *
        exp(-(1/(2*v^2)) * ((t/u) - 2 + (u/t)))
    }
  } else if (process == "IG") {
    for (i in 1:(ncol(data) - 1)) {
      RUL[[i]] <- numeric()
      sqrt_lam_lxt <- sqrt(par[2] / (threshold - cur_path[i]))
      term1 <- dnorm(sqrt_lam_lxt * (t - threshold / par[1])) * sqrt_lam_lxt
      term2 <- -2 * par[2] / par[1] * exp(2 * par[2] * t / par[1]) * pnorm(-sqrt_lam_lxt * ((threshold - cur_path[i]) / par[1] + t))
      term3 <- exp(2 * par[2] * t / par[1]) * dnorm(-sqrt_lam_lxt * ((threshold - cur_path[i]) / par[1] + t)) * sqrt_lam_lxt
      RUL[[i]] <- term1 + term2 + term3
    }
  }
  return(RUL)
}
