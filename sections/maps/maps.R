
rs <- reactive({
  
  if (input$Parameter != "prAdjust") {
    path <- paste0("www/data/ncs/changes_ensemble/bc_",input$Parameter,"_",input$Scenario,"_",input$Period,"_seasmean.nc")
  } else {
    path <- paste0("www/data/ncs/changes_ensemble/bc_",input$Parameter,"_",input$Scenario,"_",input$Period,"_seassum.nc")
  }
  
  print(path)
  r <- brick(path)
  # r <- brick("www/data/ncs/changes_ensemble/bc_tasAdjust_rcp85_20710301-21001130_seasmean.nc")
  nms <- names(r) %>% gsub("X", "",.) %>% as.numeric() %>%  as.Date(origin = "1970-01-01") %>% seas::mkseas("DJF") %>% as.character()
  
  
  rs <- r[[which(nms %in% input$Season )]] %>% rasterToPoints() %>% as_tibble()
  # rs <- r[[which(nms %in% "SON" )]] %>% rasterToPoints() %>% as_tibble()
  names(rs)[3] <- "values"
  
  rs
  
  
})






output$coolplot <- renderPlot({
  
  
  
  rs <- rs()
  print(rs)
  
  
  rg <- range(rs$values) %>% round(1)
  
  #print(brks)
  rs$values[rs$values > rg[2]] <- rg[2]
  rs$values[rs$values < rg[1]] <- rg[1]
  
  # simboluri in functie de parametru
  
  if (input$Parameter != "prAdjust") {
    

    ylOrBn <- colorRampPalette( brewer.pal(9,"YlOrRd"), interpolate="linear")
    
    brks <- seq(0.2, 5.4, by = 0.2)
    brks <-  brks[brks >= plyr::round_any(rg[1], 0.2, f = floor) & brks <=  plyr::round_any(rg[2], 0.2, f = ceiling)]
    
    cols <- data.frame(cols = ylOrBn(length(brks)),
                       brks = brks)
    
   # cols <- cols %>% filter( brks >= rg[1] & brks <=  rg[2])
  } else {
    cols <- data.frame(cols = brewer.pal(7,"BrBG"),
                       brks = seq(-30, 30, by = 10))
    
    cols <- cols %>% filter( brks >= plyr::round_any(rg[1],10, f = floor) & brks <= plyr::round_any(rg[2], 10, f = ceiling) )
    
  }
  
  print(cols)
  print(rg)
  ggplot() +
    
    geom_raster(data = rs, aes(x = x, y = y,
                               fill = values),interpolate = F, alpha = 100) +
    geom_sf(fill = "transparent", data = judete) +
    geom_sf_text(aes(label = JUDET),colour = "darkgrey",size = 3, data = judete)+
    # make title bold and add space
    # 
    scale_fill_stepsn( colours = cols$cols,#[2:(nrow(cols))],
                       name = ifelse(input$Parameter != "prAdjust", "     °C", "     mm"), 
                       breaks = cols$brks) + 
    
    
    
    # scale_fill_gradientn(name = "    °C",
    #                      limits = c(rg[1], rg[2]),
    #                      breaks = brks,
    #                      colors = cols)+
    
    #colorspace::scale_fill_binned_sequential(palette =  values$c, name = "    °C", breaks = brks) + 
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
  
})


