# citeste raster de interes
rs <- reactive({
  
  # modificari in situatia cu Annual
  smean <- "_seasmean.nc"
  ssum <- "_seassum.nc"
  period <- input$Period
  if (input$Season == "Annual") {
    # perioada change
    period <- period %>% gsub("0301", "0101", .) %>% gsub("1130", "1231", .)
    # season change
    smean <- gsub("seas", "year", smean)
    ssum <- gsub("seas", "year", ssum)
    
  }
  
  
  if (input$Parameter != "prAdjust") {
    path <- paste0("www/data/ncs/changes_ensemble/bc_",input$Parameter,"_",input$Scenario,"_",period, smean)
  } else {
    path <- paste0("www/data/ncs/changes_ensemble/bc_",input$Parameter,"_",input$Scenario,"_",period, ssum)
  }
  
  # print(path)
  r <- brick(path)
  
  nms <- names(r) %>% gsub("X", "",.) %>% as.numeric() %>%  as.Date(origin = "1970-01-01") %>% seas::mkseas("DJF") %>% as.character()
  if (input$Season != "Annual") r <- r[[which(nms %in% input$Season )]]
  
  #nlayers(r)
  r
  
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


# # titlu harta
# output$tabtext <- renderText({
#   textvar()
# })

# plot reactive acum pentruutilizare output si download
plotInput<- reactive ({
  
  rs <- rs() %>% rasterToPoints() %>% as_tibble()
  names(rs)[3] <- "values"
  
  rg <- range(rs$values) %>% round(1)
  
  # simboluri in functie de parametru
  if (input$Parameter != "prAdjust") {
    ylOrBn <- colorRampPalette( brewer.pal(9,"YlOrRd"), interpolate="linear")
    brks <- seq(1, 5, by = 0.5)
    cols <- ylOrBn(length(brks) - 1)
    lim <- c(0.5, 5.5)
  } else {
    cols <- brewer.pal(6,"BrBG")
    brks <- seq(-20, 20, by = 10)
    lim <- c(-30,30)
  }
  
  #print(cols)
  #print(rg)
  
  ggplot() +
    geom_raster(data = rs, aes(x = x, y = y,
                               fill = values),interpolate = F, alpha = 100) +
    geom_sf(fill = "transparent", data = judete) +
    geom_sf_text(aes(label = JUDET),colour = "darkgrey",size = 3, data = judete) +
    annotation_raster(logo, xmin = 20.525, xmax = 21.525, ymin = 43.3, ymax = 43.9) +
    # make title bold and add space
    # 
    scale_fill_stepsn( colours = cols,
                       name = ifelse(input$Parameter != "prAdjust", "      °C", "      %"), 
                       breaks = brks,
                       limits = lim) + 
    labs(caption = "@SUSCAP", title = textvar(), x = "", y = "") +
    theme_bw() + #xlim(20,30) + ylim(43.5, 48.3) +
    guides(fill = guide_colourbar(barwidth = 1.0, barheight = 9, title.position = "top")) +
    theme(legend.position = c(.9, .75),
          plot.caption = element_text(vjust = 30, hjust = 0.95, size = 3),
          plot.title = element_text(vjust = -7, hjust = 0.5, size = 12),
          #axis.text = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          axis.ticks.length = unit(0, "pt"), #length of tick marks
          # panel.grid.major=element_blank(),
          # panel.grid.minor=element_blank(),
          plot.margin = margin(-0.9, 0, 0, 0, "cm")
          ) +
    annotate("text", label = paste("min.:", rg[1] %>% sprintf("%.1f",.)), x=29.2, y = 46, size = 3) +
    annotate("text", label = paste("avg.:", mean(rs$values) %>% round(1)%>% sprintf("%.1f",.)), x=29.2, y = 45.9,  size = 3) +
    annotate("text", label = paste("max.:", rg[2] %>% sprintf("%.1f",.)), x=29.2, y = 45.8, size = 3)
  
})

# pentru randare plot
output$coolplot <- renderPlot(
  width = 850, height = 650, units="px",res = 100, {
    plotInput()
  })


# render plot asimage

# output$imageplot <- renderImage ({
#   
#   outfile <- tempfile(fileext='.png')
#   png(outfile, width = 850, height = 650, units = "px", res = 100)
#   print(plotInput())
#   dev.off()
#   
#   # Return a list containing the filename
#   list(src = outfile,
#        contentType = 'text/svg+xml',
#        width = 850,
#        height = 650,
#        alt = "Map")
#   
# }, deleteFile = TRUE)
#   
  

# pentru descarcare plot imagine
output$downloadPlot <- downloadHandler(
  filename = function() { paste(textvar() %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.png', sep='') },
  content = function(file) {
    png(file, width = 850, height = 650, units = "px", res = 100)
    print(plotInput())
    dev.off()
  })

# pentru descarcare fisier Geotiff
output$downloadRaster <- downloadHandler(
  filename = function() { paste(textvar() %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.tif', sep='') },
  content = function(file) {
    writeRaster(rs(), file, overwrite = T)
  }
)



