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
  
  rmean <- brick(gsub("changes_ensemble", "multiannual_means", path))
  nms <- names(rmean) %>% gsub("X", "",.) %>% as.numeric() %>%  as.Date(origin = "1970-01-01") %>% seas::mkseas("DJF") %>% as.character()
  if (input$Season != "Annual") rmean <- rmean[[which(nms %in% input$Season )]]
  #nlayers(r)
  # returneaza ca lista sa poti duce ambele variabile
  list(change = r, enmean = rmean)
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
  
  rs <- rs()$change %>% rasterToPoints() %>% as_tibble()
  names(rs)[3] <- "values"
  
  rg <- range(rs$values) %>% round(1)
  
  # simboluri in functie de parametru
  if (input$Parameter != "prAdjust") {
    ylOrBn <- colorRampPalette( brewer.pal(9,"YlOrRd"), interpolate="linear")
    brks <- seq(1, 5, by = 0.5)
    cols <- ylOrBn(length(brks) - 1)
    lim <- c(0.5, 5.5)
    # pentru hartile cu schimbarea
    rmean <- colorRampPalette( brewer.pal(11, "RdYlBu")[3:11], interpolate="linear")
    brks.change <- seq(-8, 26, by = 2)
    cols.change <- rmean(length(brks.change) - 1)
    lim.change <- c(-6, 24)
    
  } else {
    cols <- brewer.pal(6,"BrBG")
    brks <- seq(-20, 20, by = 10)
    lim <- c(-30,30)
    # pentru hartile cu schimbarea
    rmean <- colorRampPalette( c(brewer.pal(9, "YlOrBr")[3:9], brewer.pal(9, "BuPu")), interpolate="linear")
    if (input$Season != "Annual") {
    brks.change <- c(0,5,10,20,30,40,50,75,100)
    cols.change <- rmean(length(brks.change) - 1)
    lim.change <- c(5, 75)
    } else {
      brks.change <- c(300,400,500,600,700,800,900,1000)
      cols.change <- rmean(length(brks.change) - 1)
      lim.change <- c(400, 900)
    }
    
  }
  
  #print(cols)
  #print(rg)
  
  plot.change <- ggplot() +
    geom_raster(data = rs, aes(x = x, y = y,
                               fill = values),interpolate = F, alpha = 100) +
    geom_sf(fill = "lightgrey", color = "grey", data = ctrs) +
    geom_sf(fill = "transparent", data = judete) +
    geom_sf(fill = "#a4b9b9", data = sea, color = "lightgrey", lwd = 0.4) +
    geom_sf_text(aes(label = name),colour = "darkgrey",size = 3, data = judete) + 
    geom_vline(xintercept = c(20,22,24,26,28,30), color="#EBEBEB", linetype='dashed') +
    geom_hline(yintercept = c(44,45,46,47,48), color="#EBEBEB", linetype='dashed') +
    
    annotation_raster(logo, xmin = 20.525, xmax = 21.525, ymin = 43.9, ymax = 44.5) +
    # make title bold and add space
    # 
    scale_fill_stepsn( colours = cols,
                       name = ifelse(input$Parameter != "prAdjust", "      °C", "      %"), 
                       breaks = brks,
                       limits = lim) + 
    labs(caption = paste("@SUSCAP", Sys.Date()), title = textvar(), x = "", y = "") +
    coord_sf(xlim = c(20,30), ylim = c(43.5, 48.5), expand = F) +
    theme_bw() + #xlim(20,30) + ylim(43.7, 48.3) +
    guides(fill =  guide_colourbar(barwidth = 1.0, barheight = 9, title.position = "top",
                                   label.theme = element_text(size = 10))) +
    scale_linetype_manual(values=c("twodash")) +
    
    theme(legend.position = c(.94, .91),
          legend.justification = c("right", "top"),
          legend.background = element_rect(fill="lightgrey", colour = "lightgrey"),
          plot.caption = element_text(vjust = 30, hjust = 0.040, size = 7.5),
          plot.title = element_text(vjust = -7.5, hjust = 0.5, size = 13),
          #axis.text = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          axis.ticks.length = unit(0, "pt"), #length of tick marks
          # panel.grid.major=element_blank(),
          # panel.grid.minor=element_blank(),
          plot.margin = margin(-0.9, 0.5, 0, 0, "cm")
    ) +
    annotate("text", label = paste("min.:", rg[1] %>% sprintf("%.1f",.)), x=29.1, y = 46, size = 3.3) +
    annotate("text", label = paste("avg.:", mean(rs$values) %>% round(1)%>% sprintf("%.1f",.)), x = 29.1, y = 45.9,  size = 3.3) +
    annotate("text", label = paste("max.:", rg[2] %>% sprintf("%.1f",.)), x=29.1, y = 45.8, size = 3.3)
  
 list(plot.change = plot.change)
  
})

# pentru randare plot
output$coolplot <- renderPlot(
  width = 850, height = 650, units = "px",res = 100, {
    plotInput()$plot.change
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
    print(plotInput()$plot.change)
    dev.off()
  })

# pentru descarcare fisier Geotiff
output$downloadRaster <- downloadHandler(
  filename = function() { paste(textvar() %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.tif', sep='') },
  content = function(file) {
    writeRaster(rs()$change, file, overwrite = T)
  }
)



