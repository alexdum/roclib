
filtered <- reactive({
  date1 %>% 
    filter(model == input$Model) %>%
    filter(scen == input$Scenario) %>%
    
    filter(season == input$Season)%>%
    
    filter(param == input$Parameter)
})




output$coolplot <- renderPlot({
  
  if (input$Parameter == "precAdjust") {
    
    ggplot() + 
      geom_tile(data= filtered(), aes(x = Lon, y = Lat,
                                      fill = value)) +
      scale_fill_gradientn(name = "mm",
                           limits = c(50,
                                      600),
                           breaks = brks.p,
                           colors = cols.p)+
      geom_sf(fill="transparent", data = judete)+
      geom_sf_text(aes(label = JUDET),colour = "red",size = 3.15,data = judete)+
      
      labs(caption = "Database: @MeteoRomania") +
      theme_bw() +
      guides(fill = guide_colourbar(barwidth = 1.0, barheight = 11.6, title.position="top"))+
      theme( legend.position = "right")
    #fig <- plot_ly(filtered(), y = ~Pp, color = ~month, type = "box")
    #fig <- fig %>% layout(title = "Modifying The Algorithm For Computing Quartiles")
    
  } else {
    
    ggplot() +
      
      geom_raster(data= filtered(), aes(x= Lon, y=Lat,
                                        fill = value),interpolate = T)+
      geom_sf(fill="transparent", data = judete)+
      geom_sf_text(aes(label = JUDET),colour = "darkgrey",size = 3.15,data = judete)+
      # make title bold and add space
      
      scale_fill_gradientn(name = "°C",
                           limits = c(-6,
                                      35),
                           breaks = brks,
                           colors = cols)+ # change color scale
      #geom_tile(data = hill_spdf, aes(x = x, y = y, fill = value)) +
      #scale_fill_gradient(low = "black", high = "white") +
      #new_scale_fill() +
      #geom_tile(data = dem_spdf, aes(x = x, y = y, fill = value), alpha=0.4)
      
      labs(caption = "Database: @MeteoRomania")+
      theme_bw() +
      guides(fill = guide_colourbar(barwidth = 1.0, barheight = 14.0, title.position="top"))+
      theme( legend.position = "right" )   #c(.93,.72)
    
  }
  
})


r <- brick("www/data/ncs/changes_ensemble/bc_tasminAdjust_rcp85_20710301-21001130_seasmean.nc")
nms <- names(r) %>% gsub("X", "",.) %>% as.numeric() %>%  as.Date(origin = "1970-01-01") %>% seas::mkseas("DJF") 


rs <- r[[which(nms %in% "DJF")]] %>% rasterToPoints() %>% as_tibble()
names(rs)[3] <- "values"

rg <- range(rs$values) %>% round(1)
brks <- seq(rg[1], rg[2], by = 0.2)

rs$values[rs$values > rg[2]] <- rg[2]
rs$values[rs$values < rg[1]] <- rg[1]


# cols <- c("#8c6bb1","#9ecae1","#deebf7","#ffffe5",brewer.pal(9,"YlOrRd"),rev(brewer.pal(9,"PuRd")))

if (min(brks) > 0) cols <- "YlOrRd"



ggplot() +
  
  geom_raster(data = rs, aes(x = x, y = y,
                                    fill = values),interpolate = T) +
  geom_sf(fill = "transparent", data = judete) +
  geom_sf_text(aes(label = JUDET),colour = "darkgrey",size = 3.15,data = judete)+
  # make title bold and add space
  # 
  # scale_fill_gradientn(name = "    °C",
  #                      limits = c(rg[1], rg[2]),
  #                      breaks = brks,
  #                      colors = cols)+ 
 
  colorspace::scale_fill_binned_sequential(palette = cols, name = "    °C", breaks = brks) + 
 # change color scale
  #geom_tile(data = hill_spdf, aes(x = x, y = y, fill = value)) +
  #scale_fill_gradient(low = "black", high = "white") +
  #new_scale_fill() +
  #geom_tile(data = dem_spdf, aes(x = x, y = y, fill = value), alpha=0.4)
  
  labs(caption = "Database: @MeteoRomania") +
  xlab("") + ylab("") +
  theme_bw() +
  guides(fill = guide_colourbar(barwidth = 1.0, barheight = 14.0, title.position = "top")) +
  theme( legend.position = "right" )   #c(.93,.72)

# output$downloadPlot <- downloadHandler(
#   filename = function(){paste("input$coolplot",'.png',sep='')},
#   content = function(file){
#     ggsave(file,plot=input$coolplot)
#   }
# )