testthat::test_that(
  "utility does this",
  {
    cumsub(1:5)
    apply(matrix(1:12,3,4),2,cumsub)
  }
)
