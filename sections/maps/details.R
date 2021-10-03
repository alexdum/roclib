
#plot(shape["code"])
# shape <- read_sf("misc/data/ro_uat_poligon_simp.shp") %>% st_set_crs (3844) %>% st_transform(4326)
# names(shape)[1] <- "code"

level_ag <- reactive({
  
  # selectare regiune
  region <- as.numeric(input$regio_ag)
  reg_param <- input$regio_param
  reg_period <- input$regio_period
  reg_scen <- input$regio_scen
  reg_season <- input$regio_season
  
  
  dat1 <- readRDS(paste0("www/data/tabs/anomalies/variables/",c("region","county", "uat")[region],"_anomalies_annual_",reg_param,"_",reg_scen,"_1971_2100.rds"))
  dat1$changes <- data.frame(dat1$changes[, "name"], season = "Annual", 
                             dat1$changes[, c("mean_hist", "mean_2021_2050", "mean_2071_2100", "change_2021_2050", "change_2071_2050")])
  dat2 <- readRDS(paste0("www/data/tabs/anomalies/variables/",c("region","county", "uat")[region],"_anomalies_seasons_",reg_param,"_",reg_scen,"_1971_2100.rds"))
  
  dat_changes <- rbind(dat1$changes,  dat2$changes) %>% dplyr:: filter(season ==  reg_season)
  
  switch(region,
         shape <- shape_region %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_county %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_uat %>% right_join(  dat_changes, by = c("code" = "name"))
         
         
  )
  shape$values <- shape %>% data.frame() %>% dplyr::select(matches(reg_period)) %>% unlist()
  
  source("sections/maps/details_settings.R", local = T)
  
  # returneaza ca lista sa poti duce ambele variabile
  list(shape = shape, pal = pal, pal2 = pal2)
  
})



output$map <- renderLeaflet ({
  leaflet(start_county,
          options = leafletOptions(
            minZoom = 6, maxZoom = 12
          ) 
  ) %>%
    leaflet.extras::addBootstrapDependency() %>%
    setView(25, 46, zoom = 6) %>%
    setMaxBounds(20, 43.5, 30, 48.2) %>% 
    # addMapPane(name = "pol", zIndex = 500) %>% 
    #  addMapPane(name = "maplabels", zIndex = 520) %>%
    addProviderTiles(
      "CartoDB.PositronNoLabels"
    )   %>% 
    addProviderTiles(
      "CartoDB.PositronOnlyLabels",
      # options = leafletOptions(pane = "maplabels"),
      group = "map labels"
    )  %>% 
    addEasyButton(
      easyButton (
        icon    = "glyphicon glyphicon-home", title = "Reset zoom",
        onClick = JS("function(btn, map){ map.setView([46, 25], 6); }")
      )
    )   %>%
    addLayersControl(baseGroups = "CartoDB.PositronNoLabels",
                     overlayGroups = c("map labels",
                                       "region"))  %>% 
    leaflet.extras::addSearchOSM (
      options = 
        leaflet.extras::searchOptions(
          collapsed = T,
          zoom = 9,
          autoCollapse = TRUE, minLength = 2,
          hideMarkerOnCollapse = TRUE
        )
    ) 
  # leaflet.extras2::addEasyprint(
  #   options =
  #     leaflet.extras2::easyprintOptions(
  #       title = 'Print map',
  #       position = 'topleft',
  #       exportOnly = T,
  #       sizeModes = c('A4Landscape', 'A4 Landscape')
  #     )
  # )
  #%>%
  #leaflet.extras::addResetMapButton() %>%
  # leaflet.extras::addSearchFeatures(
  #   targetGroups  = 'region',
  #   options = leaflet.extras::searchFeaturesOptions(
  #     zoom=10, 
  #     openPopup=FALSE,
  #     propertyName = "name",
  #     hideMarkerOnCollapse = TRUE,
  #     firstTipSubmit = TRUE
  #     # textErr = "Locația nu a fost găsită", 
  #     # textCancel = "Anulare",
  #     # textPlaceholder = "Căutare..."
  #   )
  # )
  
})

# this is the fun part!!! :)
observe({ 
  
  req(input$tab_being_displayed == "Explore in detail") # Only display if tab is 'Explore in detail'
  
  opacy <- input$transp
  data <- level_ag()$shape
  palm <- level_ag()$pal
  
  leafletProxy("map",  data = data)  %>%
    clearShapes() %>%
    addPolygons (
      fillColor = ~palm(values), 
      color = "grey",
      weight = 0.5, smoothFactor = 0.1,
      opacity = 0.5, 
      fillOpacity = opacy ,
      layerId = ~code,
      #options = leafletOptions(pane = "pol"),
      group = "region",
      highlightOptions = highlightOptions(
        weight = 2,
        color = "#666",
        fillOpacity = 1,
        bringToFront = TRUE,
        sendToBack = TRUE
      ) 
    ) 
  # %>%
  # addLegend(
  #   "bottomright", pal = level_ag()$pal2, values = level_ag()$shape$values, opacity = 1,
  #   labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
  # ) 
  # 
}) 

#Use a separate observer to recreate the legend as needed.
observe({
  
  req(input$tab_being_displayed == "Explore in detail") # Only display if tab is 'Map Tab'
  proxy <- leafletProxy( "map", data = start_county)
  # Remove any existing legend, and only if the legend is
  # enabled, create a new one.
  proxy %>% clearControls()
  #if (input$legend) {
  proxy%>%
    leaflet.extras2::addEasyprint(
      options =
        leaflet.extras2::easyprintOptions(
          title = 'Print map',
          position = 'bottomleft',
          exportOnly = T,
          sizeModes = list('Current'),#'A4Landscape', 'A4Portrait'),
          hideControlContainer = F,
          hideClasses = list('leaflet-control-zoom')
          
          
        )
    ) %>% 
    addLegend(
      "bottomright", pal = level_ag()$pal2, values = ~values, opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    ) 
  #}
})


observe({ 
  
  #event <- input$map_shape_click
  event <- input$map_shape_mouseover
  output$cnty <- renderText(
    paste(round(level_ag()$shape$values[level_ag()$shape$code == event$id], 1), 
          level_ag()$shape$name[level_ag()$shape$code == event$id])
  )
  
})
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)
