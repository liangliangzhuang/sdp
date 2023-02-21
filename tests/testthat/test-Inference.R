test_that("multiplication works", {
  dat = sim_dat(group = 6, t = 1:200, para = c(5,5),process = "IG")
  plot_path(dat[[1]])
})
