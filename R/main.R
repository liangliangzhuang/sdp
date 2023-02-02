#' Plot stochastic degradation process
#'
#' It is an example of create a R package. This function is used to
#' make a set of stochastic degradation process path. We hope to
#' make it easy to xxx.
#' Thank you for using it.
#'
#' @param group group of the degradation path.
#' @param t time.
#' @param para parameters of a certain model.
#'
#' @return  Return a list containing a data of degradation path and a figure.
#' @examples
#' main(group = 6,t = 1:200,para = c(1,1))
#' @export
#' @importFrom ggplot2 ggplot aes geom_line geom_abline
main = function(group = 6,t = 1:200,para = c(1,1)){
  dat = sim_dat(group = group, t = t, para = para)
  p = plot_path(dat)
  return(list(dat,p))
}



