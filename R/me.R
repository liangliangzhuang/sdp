gamma_moment <- function(data = dat[[1]]) {
  # 每组测量次数相同
  time <- data[, 1]
  y <- data[-1, -1]
  group <- ncol(data) - 1
  delta_t <- diff(time)
  delta_y <- matrix(NA, length(time) - 1, group)
  for (i in 1:group) delta_y[, i] <- cumsub(y[, i])
  M <- group * length(time)
  Rij <- delta_y / delta_t
  Rbar <- sum(Rij) / M
  MSR2 <- sum((Rij - Rbar)^2)
  moment_alp <- Rbar^2 * group * sum(1 / delta_t) / MSR2
  moment_beta <- MSR2 / (group * sum(1 / delta_t) * Rbar)
  return(c(moment_alp, moment_beta))
}
