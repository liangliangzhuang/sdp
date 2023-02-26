#' Generate simulated degradation data
#'
#' This function is used to generate simulated degradation data.
#'
#' @param t time.
#' @param group The number of groups of products
#' @param para parameters of a certain model.
#' @param process Wiener, Gamma or Inverse Gaussian process.
#' @param type classical in default.
#' @param s  stress.
#' @param rel relationship.
#'
#' @return  Return a list containing simulated data at different time points for each group.
#' The output is a list.
#' The first part of the list is the amount of degradation of the simulated data,
#' and the second part is the increment of its degradation
#' @examples
#' dat <- sim_dat(group = 5, t = 1:200, para = c(2,3),
#' process = "Wiener",type = "classical",
#' s = NULL, rel = NULL)
#' str(dat)
#' @export
#'
sim_dat <- function(group = 5,
                    t = 1:100,
                    para = c(2,3),
                    process = "Wiener",
                    type = "classical",
                    s=NULL,
                    rel = NULL) {
  # para 指 mu,sigma
  # epoch 指测量次数，group 指组数
  delta_t <- diff(t)
  epoch <- length(delta_t)
  dat = dat_unit = list()

  if(type == "classical"){
    # group = 5;t = 1:10; para = c(2,3); stress = NULL; process = "Wiener"; type = "classical";
    # s=NULL; rel = NULL
    if(length(para) != 2) stop("The `para` vector is inconsistent, it should be 2")
    dat[[1]] <- dat_unit[[1]] <- matrix(NA, epoch, group + 1)
    dat[[1]][, 1] <- dat_unit[[1]][, 1] <- seq(1, epoch)
    for (i in 1:group) {
      for (j in 1:epoch) {
        if (process == "Wiener") {
          dat_unit[[1]][j, i + 1] <- rnorm(1, para[1] * delta_t[j], sqrt(para[2]^2 * delta_t[j]))
        } else if (process == "Gamma") {
          dat_unit[[1]][j, i + 1] <- rgamma(1, shape = para[1] * delta_t[j], scale = para[2])
        } else if (process == "IG") {
          dat_unit[[1]][j, i + 1] <- SuppDists::rinvGauss(1, para[1] * delta_t[j], para[2] * (delta_t[j])^2)
        }
      }
        dat[[1]][, i + 1] <- cumsum(dat_unit[[1]][, i + 1])
    }
    dat[[1]] <- rbind(rep(0, group + 1), data.frame(dat[[1]])) # Add initial points
    colnames(dat[[1]]) <- c("Time", paste(1:group, sep = ""))
  } else if(type == "acc"){

    # group = 5; t = 1:10;para = c(1,2,3); process = "Wiener"; type = "acc"; stress = 3;
    # s=c(1,2,3); rel = 1; rel = "s*2"
    if(length(para) != 3) stop("The `para` vector is inconsistent, it should be 3.") #a,b,sigma
    # if(length(s) != stress) stop("The length of `s` should be equal to `stress`.")
    mu = exp(para[1] + para[2] * acc_stress(s=s, rel = rel))
    for(k in 1:length(s)){
      dat[[k]] = dat_unit[[k]] = matrix(NA, epoch, group + 1)
      dat[[k]][, 1] = dat_unit[[k]][, 1] = seq(1, epoch)
      for (i in 1:group) {
        for (j in 1:epoch) {
          if (process == "Wiener") {
            dat_unit[[k]][j, i + 1] <- rnorm(1, mu[k] * delta_t[j], sqrt(para[2]^2 * delta_t[j]))
          } else if (process == "Gamma") {
            dat_unit[[k]][j, i + 1] <- rgamma(1, shape = mu[k] * delta_t[j], scale = para[2])
          } else if (process == "IG") {
            dat_unit[[k]][j, i + 1] <- SuppDists::rinvGauss(1, mu[k] * delta_t[j], para[2] * (delta_t[j])^2)
          }
        }
        dat[[k]][, i + 1] <- cumsum(dat_unit[[k]][, i + 1])
      }
      dat[[k]] <- rbind(rep(0, group + 1), data.frame(dat[[k]])) # Add initial points
      colnames(dat[[k]]) <- c("Time", paste(1:group, sep = ""))
    }

  }
  return(dat) # 输出为list，dat1是退化量
}



