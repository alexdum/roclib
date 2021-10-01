#display.brewer.pal(9,"YlOrRd")
colint <- colorRampPalette( brewer.pal(9,"YlOrRd") , interpolate="linear")
mean.tt.col <- data.frame(cols = c(rev(brewer.pal(9,"Blues")),colint(10)), vals = seq(-16,20, 2))

colint <- colorRampPalette( brewer.pal(10,"RdYlBu") , interpolate="linear")
change.tt.col <- data.frame(cols = rev(colint(25)), vals = seq(-6,6, 0.5))

# image(1:25,1,as.matrix(1:25),col= rev(colint(25)),xlab="Greens (sequential)",
#       ylab="",xaxt="n",yaxt="n",bty="n")
# simboluri in functie de parametru

# pentru temperatura medii
if (reg_param != "prAdjust" & strsplit(reg_period,"_")[[1]][1] == "mean") {
  bins <- seq(round_even(min(shape$values), 2, 0), round_even(max(shape$values), 2, 1), by = 2)
  cols <- mean.tt.col$cols[mean.tt.col$vals >= bins[2] &  mean.tt.col$vals <= max(bins)]
  
  pal <- colorBin(cols, domain = shape$values, bins = bins)
  pal2 <- colorBin(cols, domain = shape$values, bins = bins, reverse = T)
  print(bins)
  print(cols)
  print(range(shape$values))
}


# pentru temperatura change
if (reg_param != "prAdjust" & strsplit(reg_period,"_")[[1]][1] != "mean") {
  bins <- seq(round_even(min(shape$values), 1, 0), round_even(max(shape$values), 1, 1), by = 0.5)
  cols <- change.tt.col$cols[change.tt.col$vals >= bins[2] &  change.tt.col$vals <= max(bins)]
  
  pal <- colorBin(cols, domain = shape$values, bins = bins)
  pal2 <- colorBin(cols, domain = shape$values, bins = bins, reverse = T)
  print(bins)
  print(cols)
  print(range(shape$values))
}

# 
# # pentru hartile cu schimbarea
# 
# if (input$Season != "Annual") {
#   rmean <- colorRampPalette( brewer.pal(11, "RdYlBu")[1:9], interpolate="linear")
#   brks.mean <- seq(-6, 24, by = 2)
#   cols.mean <- rev(rmean(length(brks.mean) - 1))
#   lim.mean <- c(-8, 26)
# } else {
#   rmean <- colorRampPalette( brewer.pal(11, "RdYlBu")[1:7], interpolate="linear")
#   brks.mean <- seq(2, 18, by = 2)
#   cols.mean <- rev(rmean(length(brks.mean) - 1))
#   lim.mean <- c(0, 20)
# }
# 
# } else {
#   cols <- brewer.pal(6,"BrBG")
#   brks <- seq(-20, 20, by = 10)
#   lim <- c(-30,30)
#   # pentru hartile cu schimbarea
#   
#   if (input$Season != "Annual") {
#     rmean <- colorRampPalette( brewer.pal(9, "GnBu"), interpolate="linear")
#     brks.mean <- c(100,150,200,250,300,350,400)
#     cols.mean <- rmean(length(brks.mean) - 1)
#     lim.mean <- c(50, 450)
#   } else {
#     rmean <- colorRampPalette( brewer.pal(9, "GnBu"), interpolate="linear")
#     brks.mean <- c(400,500,600,700,800,900,1000,1100,1200)
#     cols.mean <- rmean(length(brks.mean) - 1)
#     lim.mean <- c(300, 1300)
#   }
#   
# }