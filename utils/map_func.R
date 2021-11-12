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
      leaflet_titleg <- "ΣTmax. ≥ 0°C"
    } else {
      df.col <- data.frame(
        cols = c( colintinferno(14)), 
        vals = c(seq(0,150, 25), seq(200, 800, 100))
      )
      leaflet_titleg <- "Σ°C"
    }
  }
  
  if (param %in% c("heatufall")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = c( colintYlOrBr(18)), 
        vals = c(seq(0,150, 25), seq(200, 1200, 100))
      )
      leaflet_titleg <- "ΣTmax. ≥ 0°C"
    } else {
      df.col <- data.frame (
        cols = c(rev(brewer.pal(3,"Blues")[1:3]),  colintYlOrRd(14)), 
        vals = c(-150,seq(-50,300, 25), 350)
      )
      leaflet_titleg <- "Σ°C"
    }
  }
  
  if (param %in% c("scorchno")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = c( colintYlOrBr(16)), 
        vals = seq(0,75, 5)
      )
      leaflet_titleg <- "days"
    } else {
      df.col <- data.frame(
        cols =  c(colintBuPu(15)[6], colintYlOrRd(10)), 
        vals = seq(-5, 45, 5)
      )
      leaflet_titleg <- "days"
    }
  }
  
  if (param %in% c("scorchu")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = c( colintYlOrBr(13)), 
        vals = seq(800,3200, 200)
      )
      leaflet_titleg <- "ΣTmax. ≥ 32°C"
    } else {
      df.col <- data.frame(
        cols =   c(colintBuPu(15)[6], colintYlOrRd(11)), 
        vals = seq(-50, 500, 50)
      )
      leaflet_titleg <- "Σ°C"
    }
  }
  
  if (param %in% c("coldu")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = colintBuPu(16), 
        vals = c(0,25,50,75,100,200, 300, 400,500,600,700,800,900,1000,1100,2000)
      )
      leaflet_titleg <- "ΣTavg. < 0°C"
    } else {
      df.col <- data.frame(
        cols = c(rev(colintYlOrRd(10)), colintBuPu(9)[2:4]), 
        vals = c(-700,-600,-500,-400,-300,-250,-200,-150,-100,-50,0, 50, 100)
      )
      leaflet_titleg <- "Σ°C"
    }
  }
  
  if (param %in% c("frostu10", "frostu15", "frostu20")) {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols = colintBuPu(15), 
        vals = c(0,10,20,30,40,50,75,100,200, 300, 400,500,600,700,800)
      )
      leaflet_titleg <- paste0("ΣTmin. ≤ -",gsub("frostu", "",param),"°C")
    } else {
      df.col <- data.frame(
        cols = c(rev(colintYlOrRd(10)),  colintBuPu(9)[2:6]), 
        vals = c(-700,-600,-500,-400,-300,-250,-200,-150,-100,-50,0, 50,100,150,200)
      )
      leaflet_titleg <- "Σ°C"
    }
  }
  
  
  if (param %in% "prveget") {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols =  c(colintGnBu(11), rev(colintPuRd(8))),
        vals = c(200, 250,300,350, 400,450,500,550,600,650,700,750,800, 850, 900,950, 1000,1100,1200)
      )
      leaflet_titleg <- "l/m²"
    } else {
      df.col <- data.frame(
        cols =   colintBrBGfull(17), 
        vals = c(-50,-40,-30,-25,-20,-15,-10,-5, 0,5,10,15,20,25,30,40,50)
      )
      leaflet_titleg <- "%"
    }
  }
  
  
  if (substr(param, 1, 2) %in% "pr") {
    if(strsplit(reg_period,"_")[[1]][1] == "mean") {
      df.col <- data.frame(
        cols =  c(colintGnBu(11), rev(colintPuRd(5))),
        vals = c(0, 25,50,75,100,125,150,175,200,225,250,350,400, 450, 500,600)
      )
      leaflet_titleg <- "l/m²"
    } else {
      df.col <- data.frame(
        cols =   colintBrBGfull(19), 
        vals = c(-75,-50,-40,-30,-25,-20,-15,-10,-5, 0,5,10,15,20,25,30,40,50,75)
      )
      leaflet_titleg <- "%"
    }
  }
  
  ints <- findInterval(range(input$values), df.col$vals, rightmost.closed = T, left.open = F)
  print(ints)
  bins <-  df.col$vals[ints[1]:(ints[2] + 1)]
  cols <- df.col$cols[ints[1]:(ints[2])]
  
  print(cols)
  print(range(input$values))
  print(leaflet_titleg)
  
  pal <- colorBin(cols, domain = df.col$values, bins = bins)
  pal2 <- colorBin(cols, domain = df.col$values, bins = bins, reverse = T)
  return(list(pal = pal, pal2 = pal2, leaflet_titleg = leaflet_titleg))
  
  
}

