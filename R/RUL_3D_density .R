#' Remaining Useful Life
#'
#' This function is used to calculate Remaining Useful Life (RUL).
#'
#' @param fut_time fut_time
#' @param time_epoch time_epoch
#' @param rul_den ul_den
#' @param threshold threshold
#' @param real_RUL real_RUL
#' @param zlim zlim
#' @param xlim xlim
#' data data.
#'
#' @return  Return a list containing RUL at different time points for each group.
#' @examples
#' #' dat = sim_dat(group = 6, t = 1:200, para = c(2,3),process = "Wiener")
#' mle_fit = sta_infer(method = "MLE", process = "Wiener",type = "classical",data = dat[[1]])
#' RUL_plot(fut_time = c(50,55,60,65,70,75,80),time_epoch = 1:100,threshold = 150,zlim = c(0,0.05),
#' xlim = c(0,100),para = mle_fit[,2],real_RUL=c(NA,NA,NA,NA,NA,NA)+40)
#' @export
#'

# 未来时刻fut_time下的RUL值
RUL_3D_density = function(fut_time,time_epoch,rul_den,
                          threshold,real_RUL,
                          zlim = c(0,0.1),xlim = c(0,100)){
  library(plot3D)
  col = c("#02B1e6", "#E81D22", "#F9BC15", "#8015f9", "#20e81d", "#e64602","black")
  scatter3D(time_epoch, rep(1,length(time_epoch)), c(rul_den[[1]],rep(NA,length(time_epoch) - length(rul_den[[1]]))),
            bty = "b2",colkey = FALSE,
            phi = 14,theta = 55,
            pch = 18,alpha = 0, expand =0.2,ticktype = "detailed",
            xlim = xlim,
            ylim = c(min(fut_time)-5,max(fut_time)+5),
            zlim = zlim,
            xlab = "RUL", ylab = "Time", zlab = "Kernel Distribution")
  # 循环绘制3D图形
  for(i in 1:length(fut_time)){
    # 密度函数
    scatter3D(time_epoch, rep(fut_time[i],length(time_epoch)), c(rul_den[[i]],rep(NA,length(time_epoch) - length(rul_den[[i]]))),
              add = TRUE,type ='l', col = col[i], pch = 16)
    # 预测值
    scatter3D(which.max(rul_den[[i]]), fut_time[i], 0,
              add = TRUE, type ='h', col = "black", pch = 16)
    # 真实值
    scatter3D(real_RUL[i],fut_time[i], 0,
              add = TRUE, type ='h', col = "red", pch = 5)
  }
  legend("top", legend = c("RUL distribution","Point estimation","Real value"),
         pch=c(NA,16,5), col = c(col[1],"black","red"),lty = c(1,NA,NA)) #,inset = .05
  # 7.8,6.4
}
