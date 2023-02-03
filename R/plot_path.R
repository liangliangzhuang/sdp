plot_path = function(data){
  # 画图
  p = data %>% pivot_longer(paste(1:ncol(data[,-1])),
                            names_to = "Group",
                            values_to = "y") %>%
    ggplot(aes(Time,y,color = Group)) +
    geom_line() +
    viridis::scale_color_viridis(discrete = T) +
    ylab("Degradation") #+
  #theme_bw() +
  #theme(panel.grid = element_blank())
  print(p)
}
