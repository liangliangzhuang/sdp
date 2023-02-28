testthat::test_that(
  "acc_stress does this",
  {
    acc_stress(s = 1, rel = "2 * s / 5")
    acc_stress(s = 1, rel = 1)
    acc_stress(s = 1, rel = 2)
    acc_stress(s = 1, rel = 3)
  }
)
