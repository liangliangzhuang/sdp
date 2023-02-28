testthat::test_that(
  "acc_stress does this",
  {
    dat <- sim_dat(
      group = 5, t = 1:200, para = c(2, 3),
      process = "Wiener", type = "classical",
      s = NULL, rel = NULL)
    mle_re <- optim(
      par = c(1,1), fn = MLE, process ="Wiener", type = "classical",
      data = dat, method = "Nelder-Mead", hessian = TRUE)
    dat <- sim_dat(
      group = 5, t = 1:200, para = c(1,2, 3),
      process = "Wiener", type = "acc",
      s = c(1,1.1,1.2), rel = 2)
    mle_re <- optim(
      par = c(1,2,3), fn = MLE, process ="Wiener", type = "acc",
      s = c(1,1.1,1.2), rel = 2,
      data = dat, method = "Nelder-Mead", hessian = TRUE)
  }
)
