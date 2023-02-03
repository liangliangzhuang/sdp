
cumsub = function(x){
  #完成逐个相减功能，类似cumsum
  re = numeric()
  re[1] = x[1]
  for(i in 2:length(x)){
    re[i] = x[i] - x[i-1]
  }
  return(re)
}









