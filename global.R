suppressPackageStartupMessages({
  library(leaflet)
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
  library(shinyWidgets)
  library(shinycssloaders)
  library(ggspatial)
  library(markdown)
  library(ncdf4)
 
  
})
source("utils/utils.R")
source("utils/grapsh_funct.R")
source("utils/calc_func.R")
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

# Options for Spinner
options(spinner.color = "#0275D8", spinner.color.background = "#ffffff", spinner.size = 2)
judete <- read_sf("www/data/shp/counties.shp") %>% st_transform(4326)
ctrs <- read_sf("www/data/shp/countries.shp") 
sea <- read_sf("www/data/shp/sea.shp") 
logo <- readPNG("www/png/sigla_anm.png")
# Citeste datele pentru explore in Deails
shape_uat <- readRDS(file = "www/data/shp/uat_ro.rds")
shape_region <- readRDS(file = "www/data/shp/region_ro.rds")
shape_county <- readRDS(file = "www/data/shp/county_ro.rds")
start_county <- readRDS("www/data/tabs/anomalies/variables/county_anomalies_annual_prAdjust_rcp45_1971_2100.rds")
# pentru map de start la leafletProxy
start_county <- shape_county %>% right_join(start_county$changes, by = c("code" = "name"))
start_county$values <- start_county$mean_2021_2050
# next click on polygons for graphs
# https://community.rstudio.com/t/shiny-leaflet-link-map-polygons-to-reactive-plotly-graphs/40527/2








