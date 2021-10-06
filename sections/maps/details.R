
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
  
  # region <- 3
  # reg_param <- "tasAdjust"
  # reg_period <- "mean_2021_2050"
  # reg_scen <-  "rcp45"
  # reg_season <- "DJF"
  
  
  reg_scenform <- ifelse(reg_scen  == "rcp45",  "RCP4.5", "RCP8.5")
  
  dat <- readRDS(paste0("www/data/tabs/anomalies/variables/",c("region","county", "uat")[region],"_anomalies_",ifelse(reg_season == "Annual", "annual", "seasons"),"_",reg_param,"_",reg_scen,"_1971_2100.rds"))
  
  dat_changes <- dat$changes 
  dat_anomalies <- dat$anomalies
  # subseteaza data frame si lista cad ai sezoane
  
  if(reg_season  != "Annual") { 
    dat_changes <- dat_changes[dat_changes$season == reg_season, ] 
    #dat_anomalies <- lapply(dat_anomalies, function(x) { x[ x$season ==  reg_season, ] })
  }
  
  dat$changes[,c("mean_hist", "mean_2021_2050", "mean_2071_2100", "change_2021_2050", "change_2071_2100")] <- round(dat$changes[,c("mean_hist", "mean_2021_2050", "mean_2071_2100", "change_2021_2050", "change_2071_2100")],1)
  
  switch(region,
         shape <- shape_region %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_county %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_uat %>% right_join( dat_changes, by = c("code" = "name"))
  )
  
  
  shape$values <- shape %>% data.frame() %>% dplyr::select(matches(reg_period)) %>% unlist()
  
  source("sections/maps/details_settings.R", local = T)
  
  #print( paste(reg_param, region))
  # returneaza ca lista sa poti duce ambele variabile
  list(shape = shape, pal = pal, pal2 = pal2, leaflet_titleg = leaflet_titleg,  reg_paramnam  = reg_paramnam ,
       reg_name = reg_name, reg_season = reg_season, reg_scenform = reg_scenform, dat_anomalies = dat_anomalies, 
       reg_val = length(names(dat_anomalies)))
  
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
        fillOpacity = 0.2,
        bringToFront = TRUE,
        sendToBack = TRUE
      ) 
    )   %>% 
    addProviderTiles(
      "CartoDB.PositronOnlyLabels",
      # options = leafletOptions(pane = "maplabels"),
      group = "map labels"
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
  
  req(input$tab_being_displayed == "Explore in detail") # Only display if tab is 'Explore in detail'
  
  
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
      title = paste0("<html>", gsub(",","",toString(rep("&nbsp;", 5))),level_ag()$leaflet_titleg,"</html>"),
      "bottomright", pal = level_ag()$pal2, values = ~values, opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    ) 
  #}
})



# mouseover data ----------------------------------------------------------



observe({ 
  
  #req(input$tab_being_displayed == "Explore in detail") # Only display if tab is 'Explore in detail'
  
  # output$params_name <- renderUI(
  #   HTML(
  #     paste(
  #       "<b>Region</b>",level_ag()$reg_name,"<b>Climate Scenario</b>",level_ag()$reg_scenform,"<b>Parameter</b>",level_ag()$reg_season, level_ag()$reg_paramnam)
  #   )
  # )
  
  event <- input$map_shape_mouseover
  output$cnty <- renderUI(
    HTML(
      paste(
        "<table>
        <caption>",
        level_ag()$reg_name,level_ag()$reg_scenform,level_ag()$reg_season,level_ag()$reg_paramnam
        ,"</caption>
      <tr>
      <th style='padding:5px 10px 5px 5px'>Name Region</th>
      <th style='padding:5px 10px 5px 5px'>Mean 1971-2010</th>
      <th style='padding:5px 10px 5px 5px'>Mean 2021-2050</th>
      <th style='padding:5px 10px 5px 5px'>Mean 2071-2100</th>
      <th style='padding:5px 10px 5px 5px'>Change 2021-2050</th>
      <th style='padding:5px 10px 5px 5px'>Change 2071-2100</th>
      </tr>
      <tr>
      <td style='padding:5px 10px 5px 5px'>",level_ag()$shape$name[level_ag()$shape$code == event$id],"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_hist[level_ag()$shape$code == event$id], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_2021_2050[level_ag()$shape$code == event$id], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_2071_2100[level_ag()$shape$code == event$id], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$change_2021_2050[level_ag()$shape$code == event$id],1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$change_2071_2100[level_ag()$shape$code == event$id], 1),"</td>
      </tr>
      </table>"
      )
    )
  )
  
})

# mouse click data --------------------------------------------------------

# validate_event <- reactive({
#   # I have used OR condition here, you can use AND also
#   req(input$map_shape_click) | req(input$regio_ag)
# })


values  <- reactiveValues(id = NULL)
observe({values$id <- level_ag()$reg_val})

observeEvent(input$map_shape_click$id,{ 
  values$id <- which(names(level_ag()$dat_anomalies) %in% input$map_shape_click$id)
}) 


output$sum <- renderPrint({
  
  dd <- level_ag()$dat_anomalies[[values$id]]
  if(level_ag()$reg_season != "Annual") dd <- dd[dd$season == level_ag()$reg_season,]
  print(values$id)
  
  summary( dd ) 
}) 
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)
