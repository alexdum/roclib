# titlu legenda
tit.legenda <- ifelse(substr(input$Indicator, 1,2) != "pr", "     Σ°C", "      mm")
if (input$Indicator == "scorch no") tit.legenda <- "   days"

# simboluri in functie de parametru
# schimbarea
if (input$Indicator == "coldu") {
  ylOrBn <- colorRampPalette( brewer.pal(9,"PuBuGn") %>% rev(), interpolate="linear")
  brks <- seq(-350, -100, by = 50)
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(-400, -50)
  
  # mdeia
  rmean <- colorRampPalette(brewer.pal(9, "BuPu") %>% rev(), interpolate="linear")
  brks.mean <- c(125, seq(250, 1250, by = 250))
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(0, 1500)
} 


if (input$Indicator ==  "frostu 10") {
  ylOrBn <- colorRampPalette( brewer.pal(9,"PuBuGn") %>% rev(), interpolate="linear")
  brks <- seq(-450, -50, by = 50)
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(-500, 0)
  
  # mdeia
  rmean <- colorRampPalette(brewer.pal(9, "BuPu") %>% rev(), interpolate="linear")
  brks.mean <- c(50, seq(100, 600, by = 100))
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(0, 700)
} 

if (input$Indicator ==  "frostu 15") {
  ylOrBn <- colorRampPalette( brewer.pal(9,"PuBuGn") %>% rev(), interpolate="linear")
  brks <- seq(-350, -50, by = 50)
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(-400, 0)
  
  # mdeia
  rmean <- colorRampPalette(brewer.pal(9, "BuPu") %>% rev(), interpolate="linear")
  brks.mean <- c(50, seq(100, 400, by = 100))
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(0, 500)
} 

if (input$Indicator ==  "frostu 20") {
  ylOrBn <- colorRampPalette( brewer.pal(5,"PuBuGn") %>% rev(), interpolate="linear")
  brks <- c(seq(-150, -50, by = 50), -25)
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(-200, 0)
  
  # mdeia
  rmean <- colorRampPalette(brewer.pal(9, "BuPu") %>% rev(), interpolate="linear")
  brks.mean <- c(25, seq(50, 250, by = 50))
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(0, 300)
} 

if (input$Indicator ==  "heat u fall") {
  ylOrBn <- colorRampPalette( brewer.pal(9,"YlOrRd"), interpolate="linear")
  brks <- c(seq(25,225, by = 25))
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(0, 250)
  
  # mdeia,
  rmean <- colorRampPalette(brewer.pal(9, "OrRd") %>% rev(), interpolate="linear")
  brks.mean <- seq(200, 1100, by = 100)
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(150, 1200)
} 


if (input$Indicator ==  "heat u spring") {
  ylOrBn <- colorRampPalette( brewer.pal(9,"YlOrRd"), interpolate="linear")
  brks <- c(25, seq(50,300, by = 50))
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(0, 350)
  
  # mdeia,
  rmean <- colorRampPalette(brewer.pal(9, "OrRd") %>% rev(), interpolate="linear")
  brks.mean <- c(25, seq(100, 900, by = 100))
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(0, 1000)
} 


if (input$Indicator == "pr fall") {
  cols <- brewer.pal(6,"BrBG")
  brks <- seq(-10, 20, by = 10)
  lim <- c(-20,30)
  rmean <- colorRampPalette( brewer.pal(9, "GnBu"), interpolate="linear")
  brks.mean <- seq(25, 175, 25)
  cols.mean <- rmean(length(brks.mean) - 1)
  lim.mean <- c(0, 200)
}


if (input$Indicator == "pr veget") {
  cols <- brewer.pal(6,"BrBG")
  brks <- seq(-10, 20, by = 10)
  lim <- c(-20,30)
  rmean <- colorRampPalette( brewer.pal(9, "GnBu"), interpolate="linear")
  brks.mean <- seq(200, 1000, 100)
  cols.mean <- rmean(length(brks.mean) - 1)
  lim.mean <- c(100, 1100)
}

if (input$Indicator == "pr winter") {
  cols <- brewer.pal(6,"BrBG")
  brks <- seq(-10, 20, by = 10)
  lim <- c(-20,30)
  rmean <- colorRampPalette( brewer.pal(9, "GnBu"), interpolate="linear")
  brks.mean <- seq(150, 450, 50)
  cols.mean <- rmean(length(brks.mean) - 1)
  lim.mean <- c(100, 500)
}


if (input$Indicator ==  "scorch u") {
  ylOrBn <- colorRampPalette( brewer.pal(9,"YlOrRd"), interpolate="linear")
  brks <- seq(100,400, by = 50)
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(50, 450)
  
  # mdeia,
  rmean <- colorRampPalette(brewer.pal(9, "OrRd") %>% rev(), interpolate="linear")
  brks.mean <- seq(1000, 3000, by = 250)
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(750, 3250)
} 

if (input$Indicator ==  "scorch no") {
  ylOrBn <- colorRampPalette( brewer.pal(9,"YlOrRd"), interpolate="linear")
  brks <- seq(5,30, by = 5)
  cols <- ylOrBn(length(brks) - 1)
  lim <- c(0, 35)
  
  # mdeia,
  rmean <- colorRampPalette(brewer.pal(9, "OrRd") %>% rev(), interpolate="linear")
  brks.mean <- c(5, seq(10, 50,  by = 10))
  cols.mean <- rev(rmean(length(brks.mean) - 1))
  lim.mean <- c(0, 60)
} 


