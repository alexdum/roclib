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
  colintGnBu <- colorRampPalette(brewer.pal(9,"GnBu"), interpolate="linear")
  colintRdPu <- colorRampPalette(brewer.pal(9,"RdPu"), interpolate="linear")
  colintBrBGfull <- colorRampPalette( brewer.pal(11,"BrBG"),interpolate="linear")
  
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
        cols = c( colintYlOrBr(18)), 
        vals = c(seq(0,150, 25), seq(200, 1200, 100))
      )
    } else {
      df.col <- data.frame (
        cols = c(rev(brewer.pal(3,"Blues")[1:3]),  colintYlOrRd(14)), 
        vals = c(-150,seq(-50,300, 25), 350)
      )
    }
  }
  
  if (param %in% c("scorchno")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = c( colintYlOrBr(16)), 
        vals = seq(0,75, 5)
      )
    } else {
      df.col <- data.frame(
        cols =  c(colintBuPu(15)[6], colintYlOrRd(10)), 
        vals = seq(-5, 45, 5)
      )
    }
  }
  
  if (param %in% c("scorchu")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = c( colintYlOrBr(13)), 
        vals = seq(800,3200, 200)
      )
    } else {
      df.col <- data.frame(
        cols =   c(colintBuPu(15)[6], colintYlOrRd(11)), 
        vals = seq(-50, 500, 50)
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
        cols = c(rev(colintYlOrRd(10)), colintBuPu(9)[2:4]), 
        vals = c(-700,-600,-500,-400,-300,-250,-200,-150,-100,-50,0, 50, 100)
      )
    }
  }
  
  if (param %in% c("frostu10", "frostu15", "frostu20")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = colintBuPu(15), 
        vals = c(0,10,20,30,40,50,75,100,200, 300, 400,500,600,700,800)
      )
    } else {
      df.col <- data.frame(
        cols = c(rev(colintYlOrRd(10)),  colintBuPu(9)[2:6]), 
        vals = c(-700,-600,-500,-400,-300,-250,-200,-150,-100,-50,0, 50,100,150,200)
      )
    }
  }
  
  
  if (param %in% "prveget") {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols =  c(colintGnBu(11), rev(colintPuRd(8))),
        vals = c(200, 250,300,350, 400,450,500,550,600,650,700,750,800, 850, 900,950, 1000,1100,1200)
      )
    } else {
      df.col <- data.frame(
        cols =   colintBrBGfull(17), 
        vals = c(-50,-40,-30,-25,-20,-15,-10,-5, 0,5,10,15,20,25,30,40,50)
      )
    }
  }
  
  
  if (substr(param, 1, 2) %in% "pr") {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols =  c(colintGnBu(11), rev(colintPuRd(5))),
        vals = c(0, 25,50,75,100,125,150,175,200,225,250,350,400, 450, 500,600)
      )
    } else {
      df.col <- data.frame(
        cols =   colintBrBGfull(19), 
        vals = c(-75,-50,-40,-30,-25,-20,-15,-10,-5, 0,5,10,15,20,25,30,40,50,75)
      )
    }
  }
  
  ints <- findInterval(range(input$values), df.col$vals, rightmost.closed = T, left.open = F)
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