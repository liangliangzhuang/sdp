#' Calculate Reliability function
#'
#' This function is used to calculate reliability function.
#'
#' @param t time.
#' @param threshold threshold of a degradation path.
#' @param par parameters of a certain model.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#' @param s  stress.
#' @param rel relationship.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' reb = Reliability(t = 40, threshold = 100, par = c(1,2),
#' process = "Wiener",type = "classical")
#' reb
#' @export
#'
Reliability <- function(t = 100,
                        threshold = 150,
                        par = NULL,
                        process = "Wiener",
                        type = "classical",
                        s = NULL,
                        rel = NULL) {
  if(type == "classical"){
    if(length(par) != 2) stop("The `par` vector is inconsistent, it should be 2.")
    new_par = par
  }else if(type == "acc"){
    if(length(par) != 3) stop("The `par` vector is inconsistent, it should be 3.")
    new_par = numeric()
    new_par[1] = exp(par[1] + par[2] * acc_stress(s=1, rel = rel))
    new_par[2] = par[3]
  }

  if (process == "Wiener") {
    R <- pnorm((threshold - new_par[1] * t) / (new_par[2] * sqrt(t))) -
      exp(2 * new_par[1] * threshold / (new_par[2]^2)) *
      pnorm((-threshold - new_par[1] * t) / (new_par[2] * sqrt(t)))
  } else if (process == "Gamma") {
    v <- sqrt(new_par[2] / threshold)
    u <- threshold / (new_par[1] * new_par[2])
    R <- 1 - pnorm((sqrt(t / u) - sqrt(u / t)) / v)
  } else if (process == "IG") {
    R <- 1 - pnorm(sqrt(new_par[2] / threshold) * (t - threshold / new_par[1])) +
      exp(2 * new_par[2] * t / new_par[1]) * pnorm(-sqrt(new_par[2] / threshold) * (threshold / new_par[1] + t))
  }

  return(R)
}
