
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


# text titlu si salvare png si fisier
textvar <- reactive({
  
  if(input$Parameter == "tasAdjust") var1 <- "Tmean"
  if(input$Parameter == "tasminAdjust") var1 <- "Tmin"
  if(input$Parameter == "tasmaxAdjust") var1 <- "Tmax"
  if(input$Parameter == "prAdjust") var1 <- "Precipitation"
  var2 <- ifelse (input$Scenario == "rcp45",  "RCP4.5", "RCP8.5")
  var3 <- ifelse(grepl(2071, input$Period, fixed = TRUE), "2071-2100 vs. 1971-2000", "2021-2050 vs. 1971-2000")
  varf <- paste(var1,input$Season, var2, var3 )
  
})


output$tabtext <- renderText({
  textvar()
})

# reactive acum pentruutilizare output si download
plotInput<- reactive ({
  
  rs <- rs()
  #print(rs)
  
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
    
  } else {
    cols <- data.frame(cols = brewer.pal(7,"BrBG"), brks = seq(-30, 30, by = 10))
    cols <- cols %>% filter( brks >= plyr::round_any(rg[1],10, f = floor) & brks <= plyr::round_any(rg[2], 10, f = ceiling) )
    
  }
  
  #print(cols)
  #print(rg)
  ggplot() +
    geom_raster(data = rs, aes(x = x, y = y,
                               fill = values),interpolate = F, alpha = 100) +
    geom_sf(fill = "transparent", data = judete) +
    geom_sf_text(aes(label = JUDET),colour = "darkgrey",size = 3, data = judete)+
    # make title bold and add space
    # 
    scale_fill_stepsn( colours = cols$cols,#[2:(nrow(cols))],
                       name = ifelse(input$Parameter != "prAdjust", "      °C", "      %"), 
                       breaks = cols$brks) + 
    
    
    
    
    labs(caption = "@MeteoRomania") +
    xlab("") + ylab("") +
    theme_bw() +
    guides(fill = guide_colourbar(barwidth = 1.0, barheight = 10.0, title.position = "top")) +
    theme( legend.position = c(.9, .75),
           plot.caption = element_text(vjust = 25, hjust = 0.95))# ,aspect.ratio = 1)   #c(.93,.72)
  
  
})

# pentru randare plot
output$coolplot <- renderPlot(
  height = 500, units="px", {
    plotInput()
  })

# pentru descprcare plot imagine
output$downloadPlot <- downloadHandler(
  filename = function() { paste(textvar() %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.png', sep='') },
  content = function(file) {
    png(file, width = 1014, height = 800, units = "px", res = 130)
    print(plotInput())
    dev.off()
  })



