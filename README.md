
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdp <a href='https://liangliangzhuang.github.io/sdp/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->
<!-- badges: end -->

## Overview

The goal of sdp is to provide engineers with practical guidance on how
to analyze data using common degradation models: Wiener process, Gamma
process, and Inverse Gaussian process. For each degradation process, we
provide data simulation generation, statistical inference, and remaining
useful life prognostics.

## Installation

You can install the development version of sdp from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("liangliangzhuang/sdp")
```

## Getting started

``` r
library(sdp)
## basic example code
```

sdp functions fall into five main categories:

- “Simulate” which can simulate a group of degradation.

- “Inference” which contains maximum likelihood estimator (MLE) and
  Bayesian method.

- “Plot” which contains several visualization functions, mainly for
  plotting degradation paths, reliability and remaining useful life. See
  `plot_path()`, `RUL_plot()`, `Reliability_plot`,
  `Reliability_cowplot()`, and `RUL_3D_density()`.

- “Others” which contains some useful functions. See `cumsub()`.

## Example: Simulated Data

This is a basic example which shows you how to solve a common problem.

We use `sim_dat()` to generate a simulated Wiener degradation process,
where group is 6, time epoch is `t = 1:200`. We denote the parameters
are $\mu = 2, \sigma = 3$. The output is a list: (i) first part of the
list is the amount of degradation of the simulated data, (ii) second
part is the increment of its degradation.

``` r
dat = sim_dat(group = 6, t = 1:200, para = c(2,3),process = "Wiener")
str(dat)
#> List of 2
#>  $ :'data.frame':    200 obs. of  7 variables:
#>   ..$ Time: num [1:200] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ 1   : num [1:200] 0 3.09 9 10.53 8.77 ...
#>   ..$ 2   : num [1:200] 0 -0.764 0.437 0.425 4.464 ...
#>   ..$ 3   : num [1:200] 0 3.53 1.75 7.2 12.62 ...
#>   ..$ 4   : num [1:200] 0 0.406 5.725 8.224 8.018 ...
#>   ..$ 5   : num [1:200] 0 0.983 4.513 7.027 6.358 ...
#>   ..$ 6   : num [1:200] 0 -0.441 3.245 8.509 14.474 ...
#>  $ :'data.frame':    200 obs. of  7 variables:
#>   ..$ Time: num [1:200] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ 1   : num [1:200] 0 3.09 5.91 1.53 -1.76 ...
#>   ..$ 2   : num [1:200] 0 -0.7639 1.2011 -0.0119 4.0386 ...
#>   ..$ 3   : num [1:200] 0 3.53 -1.78 5.44 5.42 ...
#>   ..$ 4   : num [1:200] 0 0.406 5.318 2.5 -0.206 ...
#>   ..$ 5   : num [1:200] 0 0.983 3.53 2.513 -0.669 ...
#>   ..$ 6   : num [1:200] 0 -0.441 3.685 5.265 5.965 ...
```

Using `plot_path()` function to plot the simulated degradation data.

``` r
plot_path(dat[[1]])
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

The object is a ggplot, so you can add other related function to change
the plot. For example, let’s change the theme pattern.

``` r
plot_path(dat[[1]]) + theme_bw() +
  theme(panel.grid = element_blank())
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

### Inference

For this section, we provide a tutorial for parameter estimates using
MLE and Bayesian methods. Both methods are integrated in the
`sta_infer()` function and just need to be set in the `"method"`.

#### MLE

The output of MLE is the dataframe contains point and interval
estimates.

``` r
mle_fit = sta_infer(method = "MLE", process = "Wiener", type = "classical", data = dat[[1]])
mle_fit
#>         low   mean     up
#> [1,] 2.0080 2.1809 2.3537
#> [2,] 2.9249 3.0471 3.1693
```

#### Bayes

The output of Bayes is the resampling in `rstan`. According to this
object, we can do further process, e.g., prognostic, check an so on.

``` r
fit1 = sta_infer(method = "Bayes", process = "Wiener",type = "classical",data = dat[[1]])
#> Running /Library/Frameworks/R.framework/Resources/bin/R CMD SHLIB foo.c
#> clang -arch arm64 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG   -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/Rcpp/include/"  -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/"  -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/unsupported"  -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/BH/include" -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/StanHeaders/include/src/"  -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/StanHeaders/include/"  -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppParallel/include/"  -I"/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/rstan/include" -DEIGEN_NO_DEBUG  -DBOOST_DISABLE_ASSERTS  -DBOOST_PENDING_INTEGER_LOG2_HPP  -DSTAN_THREADS  -DBOOST_NO_AUTO_PTR  -include '/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/Eigen.hpp'  -D_REENTRANT -DRCPP_PARALLEL_USE_TBB=1   -I/opt/R/arm64/include   -fPIC  -falign-functions=64 -Wall -g -O2  -c foo.c -o foo.o
#> In file included from <built-in>:1:
#> In file included from /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/Eigen.hpp:13:
#> In file included from /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/Eigen/Dense:1:
#> In file included from /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/Eigen/Core:88:
#> /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/Eigen/src/Core/util/Macros.h:628:1: error: unknown type name 'namespace'
#> namespace Eigen {
#> ^
#> /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/Eigen/src/Core/util/Macros.h:628:16: error: expected ';' after top level declarator
#> namespace Eigen {
#>                ^
#>                ;
#> In file included from <built-in>:1:
#> In file included from /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/Eigen.hpp:13:
#> In file included from /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/Eigen/Dense:1:
#> /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/RcppEigen/include/Eigen/Core:96:10: fatal error: 'complex' file not found
#> #include <complex>
#>          ^~~~~~~~~
#> 3 errors generated.
#> make: *** [foo.o] Error 1
bayes_fit = rstan::summary(fit1)$summary[c(1,2),c(4,1,8)] #
bayes_fit
#>        2.5%     mean    97.5%
#> mu 2.008699 2.181743 2.352026
#> w  2.924380 3.052988 3.191184
# print(fit1, probs = c(0.025,0.5,0.975),pars = c("mu","w"))
rstan::plot(fit1)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
rstan::traceplot(fit1,pars = c("mu","w"), inc_warmup = T,nrow = 1) + theme(legend.position = "top")
```

<img src="man/figures/README-unnamed-chunk-5-2.png" width="100%" />

### Reliability and RUL

Based on the statistical inference, we use `Reliability()` and `RUL()`
to calculate the Reliability and RUL, respectively. Then using
`Reliability_plot()` and `RUL_plot()` to plot.

``` r
reb = Reliability(t = 50, threshold = 150,par = mle_fit,
                       process = "Wiener",type = "classical")
Reliability_plot(R_time = 1:150,sum_para = mle_fit,threshold = 150,
                 process = "Wiener",type = "classical")
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r

rul = RUL(t = 1:100, cur_time = 100, threshold = 150, data = dat[[1]],
    par = mle_fit[,2], process = "Wiener", type = "classical")

RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:100,
                threshold = 150,zlim = c(0,0.05),xlim = c(0,100),
                para = mle_fit[,2],
                real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
```

<img src="man/figures/README-unnamed-chunk-6-2.png" width="100%" />

    #> $rect
    #> $rect$w
    #> [1] 0.2499835
    #> 
    #> $rect$h
    #> [1] 0.1139012
    #> 
    #> $rect$left
    #> [1] -0.1004324
    #> 
    #> $rect$top
    #> [1] 0.1683858
    #> 
    #> 
    #> $text
    #> $text$x
    #> [1] -0.02995602 -0.02995602 -0.02995602
    #> 
    #> $text$y
    #> [1] 0.13991046 0.11143515 0.08295984

## Example: lithium_battery data

``` r
str(lithium_battery)
#> List of 2
#>  $ data     :'data.frame':   168 obs. of  5 variables:
#>   ..$ Time : int [1:168] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ B0005: num [1:168] 0 0.0102 0.0211 0.0212 0.0218 ...
#>   ..$ B0006: num [1:168] 0 0.0102 0.022 0.0221 0.0348 ...
#>   ..$ B0007: num [1:168] 0 0.0104 0.0104 0.0103 0.0116 ...
#>   ..$ B0018: num [1:168] 0 0.0118 0.0154 0.0243 0.0223 ...
#>  $ threshold: num [1:4] 0.456 0.635 0.491 0.455
plot_path(lithium_battery[[1]]) + 
  # scale_color_discrete() +
  theme_bw() + 
  theme(panel.grid = element_blank()) 
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

``` r
# Inference
# MLE ========
mle_fit = sta_infer(method = "MLE", process = "Wiener", type = "classical",
                    data = lithium_battery[[1]])
mle_fit
#>         low   mean     up
#> [1,] 0.0024 0.0038 0.0051
#> [2,] 0.0167 0.0176 0.0185
Reliability(t = 100, threshold = lithium_battery[[2]][1],par = mle_fit,
            process = "Wiener",type = "classical")
#> [1] 0.8633334
Reliability_cowplot(R_time = 1:300, sum_para = mle_fit, threshold = lithium_battery[[2]],
                               process = "Wiener", type = "classical")
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r
rul2 = RUL(t = 1:100, cur_time = 30, threshold = lithium_battery[[2]][1], data = lithium_battery[[1]], par = mle_fit[,2], process = "Wiener", type = "classical")

RUL_plot(fut_time = c(10,15,20,25,30), 
         time_epoch = 1:300,
         group = 1,
         process = "Wiener", 
         type = "classical",
         threshold = lithium_battery[[2]][1],
         dat = lithium_battery[[1]],
         zlim = c(0,0.01),
         xlim = c(0,300),
         para = mle_fit[,2],
         real_RUL=c(NA,NA,NA,NA,NA,NA))
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

    #> $rect
    #> $rect$w
    #> [1] 0.2499835
    #> 
    #> $rect$h
    #> [1] 0.1139012
    #> 
    #> $rect$left
    #> [1] -0.1004324
    #> 
    #> $rect$top
    #> [1] 0.1683858
    #> 
    #> 
    #> $text
    #> $text$x
    #> [1] -0.02995602 -0.02995602 -0.02995602
    #> 
    #> $text$y
    #> [1] 0.13991046 0.11143515 0.08295984
