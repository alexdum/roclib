suppressPackageStartupMessages({
  library(shinythemes)
  library(shinyjs)
  library(shiny)
  library(shinydashboard)
  library(dplyr)
  library(ggplot2)
  library(ggridges)
  library(viridis)
  library(plotly)
  library(rgdal, quietly = T)
  library(sf)
  library(RColorBrewer)
  library(raster)
  library(png)
})
#date1 <- readRDS("www/data/tabs/season+anual_mean_models.rds")

### calcul anual din sezoniere 
#date11 <- date1%>% group_by(Lon,Lat,model,scen,param)%>% summarise(value= ifelse(param=="precAdjust",sum(value),mean(value)))%>%
#      mutate(season = "anual")
#res <-bind_rows(date1, date11) 
#saveRDS(res,"www/data/tabs/season+anual_mean_models.rds")
# 
# brks.p<-c(50,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550,600)
# cols.p <- c("#ffffd9",brewer.pal(9,"GnBu"), "#023858","#081d58","#810f7c","#88419d")
# brks<-c(-6.0,-4.0,-2.0,0.0,2.0,4.0,6.0,8.0,10.0,12.0,14.0,16.0,18.0,20.0,22.0,24.0,26,28.0,30.0,32.0,34.0,36.0)
#cols <- c("#8c6bb1","#9ecae1","#deebf7","#ffffe5",brewer.pal(9,"YlOrRd"),rev(brewer.pal(9,"PuRd")))

## pentru judete limita a se folosit doar o data dupa se pune in comentariu.

judete <- read_sf("www/data/shp/ROU_adm/Judete.shp") %>% st_transform(4326)
logo <- readPNG("www/png/sigla_anm.png")








