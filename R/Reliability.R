#' Calculate Reliability function
#'
#' This function is used to calculate reliability function.
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
#' dat <- sim_dat(group = 6, t = 1:200, para = c(2, 3), process = "Wiener")
#' mle_fit <- sta_infer(method = "MLE", process = "Wiener", type = "classical", data = dat[[1]])
#' Reliability(t = 50, threshold = 150, par = mle_fit, process = "Wiener", type = "classical")
#' @export
#'
Reliability <- function(t = 100, threshold = 150, par = mle_par,
                        process = "Wiener", type = "classical") {
  if (process == "Wiener") {
    R <- pnorm((threshold - par[1] * t) / (par[2] * sqrt(t))) - exp(2 * par[1] * threshold / (par[2]^2)) * pnorm((-threshold - par[1] * t) / (par[2] * sqrt(t)))
  } else if (process == "Gamma") {
    alp <- par[1]
    beta <- par[2]
    v <- sqrt(beta / threshold)
    u <- threshold / (alp * beta)
    R <- 1 - pnorm((sqrt(t / u) - sqrt(u / t)) / v)
  } else if (process == "IG") {
    R <- 1 - pnorm(sqrt(par[2] / threshold) * (t - threshold / par[1])) +
      exp(2 * par[2] * t / par[1]) * pnorm(-sqrt(par[2] / threshold) * (threshold / par[1] + t))
  }

  return(R)
}
