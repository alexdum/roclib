# pentru culori si setare harta
source("sections/maps/maps_settings.R", local = T)

# netcdf input ------------------------------------------------------------
rs.ind <- reactive({
  
  # modificari in situatia cu Annual
  period <- input$Period.ind
  
  
  path <- paste0("www/data/ncs/indicators/changes_ensemble/",gsub(" ", "",input$Indicator),"_",input$Scenario.ind,"_",period, ".nc")
  
  # print(path)
  r <- brick(path)
  
  
  rscen <- brick(gsub("changes_ensemble", "multiannual_means", path))
  
  rhist <- brick(
    path %>% gsub("changes_ensemble", "multiannual_means",.) %>% gsub(input$Scenario.ind,"hist",.) %>%
      gsub("_2021|_2071", "_1971",.) %>%   gsub("-2050|-2100", "-2000",.)
  )
  
  # nlayers(r)
  # print(names(rhist))
  # returneaza ca lista sa poti duce ambele variabile
  list(change = r, scen.mean = rscen, hist.mean = rhist)
})


# text titlu si salvare png si fisier -------------------------------------

textvar.ind <- reactive({
  var1 <- tools::toTitleCase(input$Indicator) %>% gsub("u", " Units", .) %>%
    gsub("  ", " ", .) %>% gsub("Pr", "Precipitation", .) %>% gsub("No", "number of days", .)
  var2 <- ifelse (input$Scenario.ind == "rcp45",  "RCP4.5", "RCP8.5")
  var3 <- ifelse(grepl(2071, input$Period.ind, fixed = TRUE), "2071-2100 vs. 1971-2000", "2021-2050 vs. 1971-2000")
  varf <- paste(var1, var2, var3 )
  
  list(
    change = paste("Changes in", var1, var2, var3), 
    mean.scen = paste( var1, var2, substr(var3,1,9)),
    mean.hist = paste(var1, "Historical", substr(var3,15,23))
    
  )
  
})



# grafice -----------------------------------------------------------------

plotInput.ind <- reactive ({
  
  # schimbare
  rs <- rs.ind()$change %>% rasterToPoints() %>% as_tibble()
  names(rs)[3] <- "values"
  rg <- range(rs$values) %>% round(1)
  # scenariu
  rm <- rs.ind()$scen.mean %>% rasterToPoints() %>% as_tibble()
  names(rm)[3] <- "values"
  rg.mean <- range(rm$values) %>% round(1)
  
  # history
  rh <- rs.ind()$hist.mean %>% rasterToPoints() %>% as_tibble()
  names(rh)[3] <- "values"
  rg.hist <- range(rh$values) %>% round(1)
  
  # culori harti
  source("sections/maps/maps_indicators_settings.R", local = T) 

plot.scen <- ggplot() +
  geom_raster(data = rm, aes(x = x, y = y,
                             fill = values),interpolate = F, alpha = 100) +
  geom_sf(fill = "lightgrey", color = "grey", data = ctrs) +
  geom_sf(fill = "transparent", data = judete) +
  geom_sf(fill = "#a4b9b9", data = sea, color = "lightgrey", lwd = 0.4) +
  geom_sf_text(aes(label = name),colour = "darkgrey",size = 3, data = judete) + 
  geom_vline(xintercept = c(20,22,24,26,28,30), color="#EBEBEB", linetype='dashed') +
  geom_hline(yintercept = c(44,45,46,47,48), color="#EBEBEB", linetype='dashed') +
  
  annotation_raster(logo, xmin = 20.525, xmax = 21.525, ymin = 43.9, ymax = 44.5) +
  # make title bold and add space
  #scale_fill_stepsn(colours = terrain.colors(10)) +
  scale_fill_stepsn( colours = cols.mean,
                     name = tit.legenda, # vezi maps_indicators_settings.R
                     breaks = brks.mean,
                     limits = lim.mean) +
  labs(title = textvar.ind()$mean.scen) +
  coord_sf(xlim = c(20,30), ylim = c(43.5, 48.5), expand = F) +
  theme_bw() + #xlim(20,30) + ylim(43.7, 48.3) +
  guides(fill =  guide_colourbar(barwidth = 1.0, barheight = 9, title.position = "top",
                                 label.theme = element_text(size = 9.5))) +
  scale_linetype_manual(values = c("twodash")) +
  theme.maps  +
  annotate("text", label = paste("min.:", rg.mean[1] %>% sprintf("%.1f",.)), x = 29.1, y = 46, size = 3.3) +
  annotate("text", label = paste("avg.:", mean(rm$values) %>% round(1) %>% sprintf("%.1f",.)), x = 29.1, y = 45.9,  size = 3.3) +
  annotate("text", label = paste("max.:", rg.mean[2] %>% sprintf("%.1f",.)), x = 29.1, y = 45.8, size = 3.3) +
  annotate("text", label = paste("@SUSCAP", Sys.Date()), x = 21, y = 43.85, size = 2.5, fontface = 'italic')

plot.hist <- ggplot() +
  geom_raster(data = rh, aes(x = x, y = y,
                             fill = values),interpolate = F, alpha = 100) +
  geom_sf(fill = "lightgrey", color = "grey", data = ctrs) +
  geom_sf(fill = "transparent", data = judete) +
  geom_sf(fill = "#a4b9b9", data = sea, color = "lightgrey", lwd = 0.4) +
  geom_sf_text(aes(label = name),colour = "darkgrey",size = 3, data = judete) + 
  geom_vline(xintercept = c(20,22,24,26,28,30), color="#EBEBEB", linetype='dashed') +
  geom_hline(yintercept = c(44,45,46,47,48), color="#EBEBEB", linetype='dashed') +
  annotation_raster(logo, xmin = 20.525, xmax = 21.525, ymin = 43.9, ymax = 44.5) +
  # scale_fill_stepsn(colours = terrain.colors(10)) +
  scale_fill_stepsn(
    colours = cols.mean,
    name = tit.legenda, # vezi maps_indicators_settings.R
    breaks = brks.mean,
    limits = lim.mean
  ) +
  labs(title = textvar.ind()$mean.hist) +
  coord_sf(xlim = c(20,30), ylim = c(43.5, 48.5), expand = F) +
  theme_bw() + #xlim(20,30) + ylim(43.7, 48.3) +
  guides(fill =  guide_colourbar(barwidth = 1.0, barheight = 9, title.position = "top",
                                 label.theme = element_text(size = 9.5))) +
  scale_linetype_manual(values=c("twodash")) +
  
  theme.maps +
  annotate("text", label = paste("min.:", rg.hist[1] %>% sprintf("%.1f",.)), x=29.1, y = 46, size = 3.3) +
  annotate("text", label = paste("avg.:", mean(rh$values) %>% round(1)%>% sprintf("%.1f",.)), x = 29.1, y = 45.9,  size = 3.3) +
  annotate("text", label = paste("max.:", rg.hist[2] %>% sprintf("%.1f",.)), x=29.1, y = 45.8, size = 3.3) +
  annotate("text", label = paste("@SUSCAP", Sys.Date()), x = 21, y = 43.85, size = 2.5, fontface = 'italic')

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
  # scale_fill_stepsn(colours = terrain.colors(10)) +
  # 
  scale_fill_stepsn( colours = cols,
                     name = tit.legenda, # vezi maps_indicators_settings.R
                     breaks = brks,
                     limits = lim) +
  labs(title = textvar.ind()$change %>% gsub("changes", "- changes in", .)) +
  coord_sf(xlim = c(20,30), ylim = c(43.5, 48.5), expand = F) +
  theme_bw() + #xlim(20,30) + ylim(43.7, 48.3) +
  guides(fill =  guide_colourbar(barwidth = 1.0, barheight = 9, title.position = "top",
                                 label.theme = element_text(size = 10))) +
  scale_linetype_manual(values=c("twodash")) +
  #ggplot2::last_plot() + 
  theme.maps +
  annotate("text", label = paste("min.:", rg[1] %>% sprintf("%.1f",.)), x=29.1, y = 46, size = 3.3) +
  annotate("text", label = paste("avg.:", mean(rs$values) %>% round(1)%>% sprintf("%.1f",.)), x = 29.1, y = 45.9,  size = 3.3) +
  annotate("text", label = paste("max.:", rg[2] %>% sprintf("%.1f",.)), x=29.1, y = 45.8, size = 3.3) +
  annotate("text", label = paste("@SUSCAP", Sys.Date()), x = 21, y = 43.85, size = 2.5, fontface = 'italic')

list(plot.change = plot.change, plot.scen = plot.scen, plot.hist = plot.hist)

})

# pentru randare plot
output$plot.change.ind <- renderPlot(
  width = 900, height = 670, units = "px",res = 110, {
    plotInput.ind()$plot.change
  })

output$plot.hist.ind <- renderPlot(
  width = 900, height = 670, units = "px",res = 110, {
    plotInput.ind()$plot.hist
  })

output$plot.scen.ind <- renderPlot(
  width = 900, height = 670, units = "px",res = 110, {
    plotInput.ind()$plot.scen
  })



# descarcare PNG GeoTIFF --------------------------------------------------

# pentru descarcare plot imagine
output$downpchange.ind <- downloadHandler(
  filename = function() { paste(textvar.ind()$change %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.png', sep='') },
  content = function(file) {
    png(file, width = 900, height = 670, units = "px", res = 110)
    print(plotInput.ind()$plot.change)
    dev.off()
  })

# pentru descarcare fisier Geotiff
output$downrchange.ind <- downloadHandler(
  filename = function() { paste(textvar.ind()$change %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.tif', sep='') },
  content = function(file) {
    writeRaster(rs.ind()$change, file, overwrite = T)
  })


# pentru descarcare plot imagine
output$downpmean.ind <- downloadHandler(
  filename = function() { paste(textvar.ind()$mean.scen %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.png', sep='') },
  content = function(file) {
    png(file, width = 900, height = 670, units = "px", res = 110)
    print(plotInput()$plot.scen)
    dev.off()
  })

# pentru descarcare fisier Geotiff
output$downrmean.ind <- downloadHandler(
  filename = function() { paste(textvar.ind()$mean.scen %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.tif', sep='') },
  content = function(file) {
    writeRaster(rs.ind()$scen.mean, file, overwrite = T)
  })

# pentru descarcare plot imagine
output$downphist.ind <- downloadHandler(
  filename = function() { paste(textvar.ind()$mean.hist %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.png', sep='') },
  content = function(file) {
    png(file, width = 900, height = 670, units = "px", res = 110)
    print(plotInput()$plot.hist)
    dev.off()
  })

# pentru descarcare fisier Geotiff
output$downrhist.ind<- downloadHandler(
  filename = function() { paste(textvar.ind()$mean.hist %>% gsub(" " ,"_", . ) %>% gsub("vs.", "vs",.) %>% tolower(), '.tif', sep='') },
  content = function(file) {
    writeRaster(rs.ind()$hist.mean, file, overwrite = T)
  })



