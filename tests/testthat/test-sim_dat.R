testthat::test_that(
  "sim_dat does this",
  {
    dat <- sim_dat(
      group = 5, t = 1:200, para = c(2, 3),
      process = "Wiener", type = "classical"
    )
    dat <- sim_dat(
      group = 5, t = 1:20, para = c(2, 12),
      process = "Gamma", type = "classical"
    )
    dat <- sim_dat(
      group = 2, t = 1:10, para = c(4, 3),
      process = "IG", type = "classical"
    )

    dat <- sim_dat(
      group = 5, t = 1:200, para = c(2, 3, 1),
      process = "Wiener", type = "acc",
      s = c(1, 1.2, 1.4), rel = 1
    )
    dat <- sim_dat(
      group = 5, t = 1:200, para = c(2, 3, 2),
      process = "Gamma", type = "acc",
      s = c(1, 1.2, 1.4), rel = 2
    )
    dat <- sim_dat(
      group = 5, t = 1:200, para = c(1.5, 2, 1),
      process = "IG", type = "acc",
      s = c(1, 1.2, 1.4), rel = 3
    )
    dat <- sim_dat(
      group = 5, t = 1:200, para = c(1.2, 1, 2),
      process = "IG", type = "acc",
      s = c(1, 1.2, 1.4), rel = "s*1.1"
    )
  }
)
