#' Cumulative Substract
#' @param x a numeric object, or an object that can be coerced to one of these.
#'
#' @return  Returns a vector whose elements are the cumulative substracts of the elements of the argument.
#' @export
cumsub <- function(x) {
  # Cumulative substract
  re <- numeric()
  re[1] <- x[1]
  for (i in 2:length(x)) {
    re[i] <- x[i] - x[i - 1]
  }
  return(re)
}

#' Relationship Between Parameter and Stress
#' @param s stress.
#' @param rel the relationship between parameter and stress.
#' @return a numeric.
#' @export
acc_stress = function(s=1,
                      rel = "2 * s / 5"){
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




