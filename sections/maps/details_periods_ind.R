
#plot(shape["code"])
# shape <- read_sf("misc/data/ro_uat_poligon_simp.shp") %>% st_set_crs (3844) %>% st_transform(4326)
# names(shape)[1] <- "code"


# recptie data ------------------------------------------------------------

level_ag_ind <- eventReactive(list(input$go_ind,isolate(input$tab_being_displayed),input$regio_ag_ind),{
  
  
  # selectare regiune
  region <- as.numeric(input$regio_ag_ind)
  reg_param <- input$regio_ind
  reg_scen <- input$regio_scen_ind

  hist_per <- input$hist_per_ind
  scen_per <- input$scen_per_ind
  # print(hist_per)
  # region <- 3
  # reg_param <- "heatuspring"
  # reg_period <- "mean_scen"
  # reg_scen <-  "rcp85"
  # hist_per <- c(1971,1980)
  # scen_per <- c(2081,2100)
  
  
  reg_scenform <- ifelse(reg_scen  == "rcp45",  "RCP4.5", "RCP8.5")
  
  dat <- readRDS(paste0("www/data/tabs/anomalies/indicators/",c("region","county", "uat")[region],"_anomalies_annual_",reg_param,"_",reg_scen,"_1971_2100.rds"))
  name_anom <- names(dat)
  
  
  dat_anomalies <- dat %>% data.table::rbindlist(idcol = 'name')  %>%
    as_tibble()
  # schimba nume sa se potriveasca cu functia
  names(dat_anomalies)[2:5] <- c("data", "scen_param_min",  "scen_param_mean", "scen_param_max")
  
  # print(head(dat_anomalies))
  # schimbare du funct calc_func
  dat_changes <- change_scen(dat_anomalies, reg_param, hist_per, scen_per )
  
  switch(region,
         reg_name <- "NUTS2",
         reg_name <- "NUTS3",
         reg_name <- "LAU (UAT)"
  )
  print(reg_name)
  


  switch(region,
         shape <- shape_region %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_county %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_uat %>% right_join( dat_changes, by = c("code" = "name"))
  )
  
  # print(head(shape))
  #print( length(names(dat_anomalies)))
  #print( paste(reg_param, region))
  # returneaza ca lista sa poti duce ambele variabile
  list(shape = shape,
       reg_name = reg_name, reg_scenform = reg_scenform, dat_anomalies = dat_anomalies, 
       reg_val = length(names(dat_anomalies)), reg_paraminit = reg_param, reg_hist_per = hist_per,
       reg_scen_per = scen_per,  name_anom =  name_anom )
  
})


# harta -------------------------------------------------------------------


output$map.ind <- renderLeaflet({
  leaflet(data = start_county,
    options = leafletOptions(
      minZoom = 6, maxZoom = 12
    )
  ) %>%
    setView(25, 46, zoom = 6) %>%
    setMaxBounds(20, 43.5, 30, 48.2) %>% 
    leaflet::addMapPane(name = "polygons", zIndex = 410) %>% 
    leaflet::addMapPane(name = "maplabels", zIndex = 420) %>%
    # addProviderTiles("CartoDB.PositronNoLabels") %>% 
    addProviderTiles(
      "CartoDB.PositronNoLabels"
    ) %>% 
    addProviderTiles(
      "CartoDB.PositronOnlyLabels",
      options = leaflet::pathOptions(pane = "maplabels") )%>%
    clearShapes() %>%
   
    addEasyButton(
      easyButton (
        icon    = "glyphicon glyphicon-home", title = "Reset zoom",
        onClick = JS("function(btn, map){ map.setView([46, 25], 6); }")
      )
    ) 
})


observe({ 
  req(input$tab_being_displayed == "Indicators")  # Only display if tab is 'Climate variables'
  
  # adauga values pentru legenda
  reg_period <- input$regio_period_ind
  
  shape <- level_ag_ind()$shape
  
  # selecteaza variabila pentru plotare
  shape$values <- shape %>% data.frame() %>% dplyr::select(matches(reg_period)) %>% unlist()
  
  
  source("sections/maps/details_settings_ind.R", local = T)
  
  opacy <- input$transp_ind
  data <- shape
  palm <- pal
  
  leafletProxy("map.ind",  data = data)  %>%
    clearShapes() %>%
    addPolygons (
      fillColor = ~palm(values), 
      label = ~paste("<font size='2'><b>Region type:",level_ag_ind()$reg_name, "<br/>Name units:",name,
                     "</b></font><br/>
                     <font size='1' color='#E95420'>Click to 
                     get values and graph</font>") %>% lapply(htmltools::HTML),
      #  labelOptions = labelOptions(textsize = "13px"),
      color = "grey",
      weight = 0.5, smoothFactor = 0.1,
      opacity = 0.5, 
      fillOpacity = opacy ,
      layerId = ~code,
      options = pathOptions(pane = "polygons"),
      group = "region",
      highlightOptions = highlightOptions(
        weight = 2,
        color = "#666",
        fillOpacity = 0.2,
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
