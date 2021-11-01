# culori culori leaflet indicatori agro---------------------------------------------------------

leg_leaf_ind <- function (input, reg_period, param) {
  # culori interpolate
  colintYlOrRd <- colorRampPalette( brewer.pal(9,"YlOrRd"),interpolate="linear")
  colintBrBG <- colorRampPalette( brewer.pal(11,"BrBG")[1:5],interpolate="linear")
  colintBlues <- colorRampPalette(brewer.pal(9,"Blues"), interpolate="linear")
  colintBuPu <- colorRampPalette(brewer.pal(9,"BuPu"), interpolate="linear")
  colintPuRd <- colorRampPalette(brewer.pal(9,"PuRd"), interpolate="linear")
  colintYlOrBr <- colorRampPalette(brewer.pal(9,"YlOrBr"), interpolate="linear")
  colintinferno <- colorRampPalette(rev(viridis::inferno(14)), interpolate="linear")
  
  if (param %in% c("heatuspring")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = c( colintYlOrBr(17)), 
        vals = c(seq(0,150, 25), seq(200, 1100, 100))
      )
    } else {
      df.col <- data.frame(
        cols = c( colintinferno(14)), 
        vals = c(seq(0,150, 25), seq(200, 800, 100))
      )
    }
  }
  
  if (param %in% c("heatufall")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = c(rev(brewer.pal(9,"Blues")), colintYlOrRd(13), rev(colintBrBG(9))), 
        vals = c(-150,-125, -100, -75, seq(-50,-10,10), seq(0,100,10), seq(125, 350, 25) , 400)
      )
    } else {
      df.col <- data.frame(
        cols = c(rev(brewer.pal(3,"Blues")[1:3]),  colintYlOrRd(14)), 
        vals = c(-150,seq(-50,300, 25), 350)
      )
    }
  }
  
  if (param %in% c("coldu")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = colintBuPu(16), 
        vals = c(0,25,50,75,100,200, 300, 400,500,600,700,800,900,1000,1100,2000)
      )
    } else {
      df.col <- data.frame(
        cols = rev(colintBlues(11)), 
        vals = c(-700,-600,-500,-400,-300,-250,-200,-150,-100,-50,0)
      )
    }
  }
  
  ints <- findInterval(range(input$values), df.col$vals, rightmost.closed = F, left.open = T)
  print(ints)
  bins <-  df.col$vals[ints[1]:(ints[2] + 1)]
  cols <- df.col$cols[ints[1]:(ints[2])]
  
  print(cols)
  print(range(input$values))
  
  pal <- colorBin(cols, domain = df.col$values, bins = bins)
  pal2 <- colorBin(cols, domain = df.col$values, bins = bins, reverse = T)
  return(list(pal = pal, pal2 = pal2))
  
  
  
  # # titlu legenda -----------------------------------------------------------
  # 
  # if (level_ag()$reg_paraminit != "prAdjust" & strsplit(reg_period,"_")[[1]][1] == "mean") {
  #   leaflet_titleg_ind  <- "°C"
  # } else if (level_ag()$reg_paraminit == "prAdjust" & strsplit(reg_period,"_")[[1]][1] == "mean") {
  #   leaflet_titleg_ind <- "l/m²"
  # } else if (level_ag()$reg_paraminit == "prAdjust" & strsplit(reg_period,"_")[[1]][1] != "mean") {
  #   leaflet_titleg_ind <- "%"
  # } else {
  #   leaflet_titleg_ind <-  "°C"
  # }
  
}

# info mouseover ----------------------------------------------------------



#var2 <- ifelse (input$Scenario == "rcp45",  "RCP4.5", "RCP8.5")

# image(1:25,1,as.matrix(1:25),col= rev(colint(25)),xlab="Greens (sequential)",
#       ylab="",xaxt="n",yaxt="n",bty="n")
# simboluri in functie de parametru


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