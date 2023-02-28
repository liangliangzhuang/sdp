testthat::test_that(
  "plot_path does this",
  {
    dat <- sim_dat(
      group = 5, t = 1:200, para = c(2, 3),
      process = "Wiener", type = "classical",
      s = NULL, rel = NULL
    )
    library(ggplot2)
    plot_path(dat)
    # add ggplot related functions.
    plot_path(dat) +
      theme_bw() +
      theme(panel.grid = element_blank())

    dat <- sim_dat(
      group = 3, t = 1:200, para = c(1, 2, 3),
      process = "Gamma", type = "acc",
      s = c(1,1.1,1.2), rel = 3
    )
    library(ggplot2)
    plot_path(dat)
    # add ggplot related functions.
    plot_path(dat) +
      theme_bw() +
      theme(panel.grid = element_blank())
  }
)
