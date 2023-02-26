#' Remaining Useful Life
#' @param x data.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @export
cumsub <- function(x) {
  # 完成逐个相减功能，类似cumsum
  re <- numeric()
  re[1] <- x[1]
  for (i in 2:length(x)) {
    re[i] <- x[i] - x[i - 1]
  }
  return(re)
}


acc_stress = function(s=1, rel = "2 * s / 5"){
  if(rel == 1){
    re = 1/s
  }else if(rel == 2){
    re = log(s)
  }else if(rel == 3){
    re = exp(s)
  }else{ #self-definition
    re = eval(parse(text = rel))
  }
  return(re)
}

# acc_norm_stress = function(s = c(1,2,3), rel = "2 * s / 5"){
#
#   if(rel == 1){
#     re = (log(s) - log(min(s))) / (log(max(s)) - log(min(s)))
#   }else if(rel == 2){
#     re = log(s)
#   }else if(rel == 3){
#     re = exp(s)
#   }else{ #self-definition
#     re = eval(parse(text = rel))
#   }
#   return(re)
# }




