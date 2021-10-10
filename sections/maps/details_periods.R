
#plot(shape["code"])
# shape <- read_sf("misc/data/ro_uat_poligon_simp.shp") %>% st_set_crs (3844) %>% st_transform(4326)
# names(shape)[1] <- "code"

level_ag <- eventReactive(list(input$go,input$tab_being_displayed,input$regio_ag),{
  
  
  
  # selectare regiune
  region <- as.numeric(input$regio_ag)
  
  
  reg_param <- input$regio_param
  reg_scen <- input$regio_scen
  reg_season <- input$regio_season
  hist_per <- input$hist_per
  scen_per <- input$scen_per
  print(hist_per)
  # region <- 2
  # reg_param <- "prAdjust"
  # reg_period <- "mean_scen"
  # reg_scen <-  "rcp45"
  # reg_season <- "DJF"
  
  
  reg_scenform <- ifelse(reg_scen  == "rcp45",  "RCP4.5", "RCP8.5")
  
  dat <- readRDS(paste0("www/data/tabs/anomalies/variables/",c("region","county", "uat")[region],"_anomalies_",ifelse(reg_season == "Annual", "annual", "seasons"),"_",reg_param,"_",reg_scen,"_1971_2100.rds"))
  
  dat_anomalies <- dat$anomalies
  # schimbare du funct calc_func
  dat_changes <- change_scen(dat_anomalies, reg_season, reg_param, hist_per, scen_per )
  
  # region name 
  
  switch(region,
         reg_name <- "NUTS2",
         reg_name <- "NUTS3",
         reg_name <- "LAU (UAT)"
  )
  #print(reg_name)
  
  
  # parameter name 
  switch (
    which(c("tasAdjust","tasminAdjust","tasmaxAdjust","prAdjust" ) %in%  reg_param ),
    reg_paramnam  <- "Tmean",
    reg_paramnam <- "Tmin",
    reg_paramnam <- "Tmax",
    reg_paramnam <- "Precipitation"
  )
  
  
  switch(region,
         shape <- shape_region %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_county %>% right_join(dat_changes, by = c("code" = "name")),
         shape <- shape_uat %>% right_join( dat_changes, by = c("code" = "name"))
  )
  
  
  
  
  #print( paste(reg_param, region))
  # returneaza ca lista sa poti duce ambele variabile
  list(shape = shape, reg_paramnam  = reg_paramnam ,
       reg_name = reg_name, reg_season = reg_season, reg_scenform = reg_scenform, dat_anomalies = dat_anomalies, 
       reg_val = length(names(dat_anomalies)), reg_paraminit = reg_param)
  
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

#vairabile pentru legenda proxi
pal2.leg <- reactiveValues(leg = NULL, titl = NULL )

observe({ 
  req(input$tab_being_displayed == "Explore in detail") # Only display if tab is 'Explore in detail'
  
  reg_period <- input$regio_period

  shape <- level_ag()$shape

  shape$values <- shape %>% data.frame() %>% dplyr::select(matches(reg_period)) %>% unlist()
  
  
  source("sections/maps/details_settings.R", local = T)
  
  opacy <- input$transp
  data <- shape
  palm <- pal
  pal2.leg$leg <- pal2
  pal2.leg$titl<-  leaflet_titleg 

  
  leafletProxy("map",  data = data)  %>%
    clearShapes() %>%
    addPolygons (
      fillColor = ~palm(values), 
      label = ~paste("<font size='2'><b>Region type:",level_ag()$reg_name, "<br/>Name units:",name,
                     "</b></font><br/>
                     <font size='1' color='#ff0000'>Click to 
                     get values and graph</font>") %>% lapply(htmltools::HTML),
      #  labelOptions = labelOptions(textsize = "13px"),
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
      title = paste0("<html>", gsub(",","",toString(rep("&nbsp;", 5))), pal2.leg$titl,"</html>"),
      "bottomright", pal = pal2.leg$leg, values = ~values, opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    ) 
  #}
})



# mouseover data ----------------------------------------------------------



# mouse click data --------------------------------------------------------

# validate_event <- reactive({
#   # I have used OR condition here, you can use AND also
#   req(input$map_shape_click) | req(input$regio_ag)
# })


values  <- reactiveValues(id = NULL, param = NULL, regio = NULL, scenario = NULL, season = NULL, reg_paramnam = NULL, name = NULL,
                          code = NULL) #%>% isolate()



observeEvent(list(isolate(input$go),input$tab_being_displayed,input$regio_ag),{
  
  values$id <- level_ag()$reg_val
  values$param <-  level_ag()$reg_paraminit
  values$regio <-  level_ag()$reg_name
  values$scenario <- level_ag()$reg_scenform
  values$season <- level_ag()$reg_season
  values$reg_paramnam <- level_ag()$reg_paramnam
  # regiune implicita pe baza unui random number
  first_sel <- sample(1:length(level_ag()$shape$code),1)
  values$name <- level_ag()$shape$name[first_sel]
  values$code <- level_ag()$shape$code[first_sel]
})



observeEvent(list(isolate(input$go),input$map_shape_click$id),{ 
  values$id <- which(names(level_ag()$dat_anomalies) %in% input$map_shape_click$id)
  values$name <- level_ag()$shape$name[level_ag()$shape$code == input$map_shape_click$id]
  values$code <- level_ag()$shape$code[level_ag()$shape$code == input$map_shape_click$id]
  
}) 





#req(input$tab_being_displayed == "Explore in detail") # Only display if tab is 'Explore in detail'

# output$params_name <- renderUI(
#   HTML(
#     paste(
#       "<b>Region</b>",level_ag()$reg_name,"<b>Climate Scenario</b>",level_ag()$reg_scenform,"<b>Parameter</b>",level_ag()$reg_season, level_ag()$reg_paramnam)
#   )
# )


output$cnty <- renderUI({
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
      <td style='padding:5px 10px 5px 5px'>",level_ag()$shape$name[level_ag()$shape$code ==   values$code],"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_hist[level_ag()$shape$code ==   values$code ], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_scen[level_ag()$shape$code ==   values$code ], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$change[level_ag()$shape$code ==   values$code], 1),"</td>
     </tr>
      </table>"
    )
  )
})


output$plot_regio_evo_tit <- renderText({
  # print(level_ag()$shape$name[level_ag()$shape$code == values$id])
  # paste(values$name, values$season, tolower(values$reg_paramnam),"Historical and", values$scenario,  "1971 - 2100")
  paste(level_ag()$shape$name[level_ag()$shape$code == values$code], level_ag()$reg_name,level_ag()$reg_scenform,level_ag()$reg_season,level_ag()$reg_paramnam)
  
})



# grafic ------------------------------------------------------------------

#grafic plot
output$plot_regio_evo<- renderPlotly({
  
  dd <- level_ag()$dat_anomalies[[values$id]]
  if(level_ag()$reg_season != "Annual") dd <- dd[dd$season == level_ag()$reg_season,]
  print(values$param)
  print(values$id)
  print(head(dd))
  gg <- plotly_evolution(dd, "obs_anom", "scen_anom_min", "scen_anom_mean","scen_anom_max", parameter =  level_ag()$reg_paraminit)
  gg
  
})

# grafic descarca
plot_regio_down <- reactive({
  dd <- level_ag()$dat_anomalies[[values$id]]
  if(level_ag()$reg_season != "Annual") dd <- dd[dd$season == level_ag()$reg_season,]
  gg_evolution(dd, "obs_anom", "scen_anom_min", "scen_anom_mean","scen_anom_max", parameter =level_ag()$reg_paraminit)
})

output$down_plot_regio <- downloadHandler(
  
  filename = function() {
    paste0(level_ag()$reg_name,"_",values$name,"_",level_ag()$reg_scenform,"_",level_ag()$reg_season,"_",level_ag()$reg_paramnam,".png") %>%
      tolower()
  },
  content = function(file) {
    png(file, width = 800, height = 400, units = "px", res = 100)
    print(plot_regio_down())
    dev.off()
  })





# date --------------------------------------------------------------------



output$change_regio <- DT::renderDT({
  
  dd <- level_ag()$dat_anomalies[[values$id]]
  if(level_ag()$reg_season != "Annual") dd <- dd[dd$season == level_ag()$reg_season,]
  
  DT::datatable(dd, extensions = 'Buttons', rownames = F,
                options = list(
                  dom = 'Bfrtip',
                  pageLength = 5, autoWidth = TRUE,
                  buttons = c('pageLength','copy', 'csv', 'excel'),
                  pagelength = 10, lengthMenu = list(c(10, 25, 100, -1), c('10', '25', '100','All')
                  )
                  
                )
  )
  
})

# 
# observe({ 
#   
#   #req(input$tab_being_displayed == "Explore in detail") # Only display if tab is 'Explore in detail'
#   
#   # output$params_name <- renderUI(
#   #   HTML(
#   #     paste(
#   #       "<b>Region</b>",level_ag()$reg_name,"<b>Climate Scenario</b>",level_ag()$reg_scenform,"<b>Parameter</b>",level_ag()$reg_season, level_ag()$reg_paramnam)
#   #   )
#   # )
#   
#   event <- input$map_shape_mouseover
#   output$cnty <- renderUI(
#     HTML(
#       paste(
#         "<table>
#         <caption>",
#         level_ag()$reg_name,level_ag()$reg_scenform,level_ag()$reg_season,level_ag()$reg_paramnam
#         ,"</caption>
#       <tr>
#       <th style='padding:5px 10px 5px 5px'>Name Region</th>
#       <th style='padding:5px 10px 5px 5px'>Mean 1971-2010</th>
#       <th style='padding:5px 10px 5px 5px'>Mean 2021-2050</th>
#       <th style='padding:5px 10px 5px 5px'>Mean 2071-2100</th>
#       <th style='padding:5px 10px 5px 5px'>Change 2021-2050</th>
#       <th style='padding:5px 10px 5px 5px'>Change 2071-2100</th>
#       </tr>
#       <tr>
#       <td style='padding:5px 10px 5px 5px'>",level_ag()$shape$name[level_ag()$shape$code == event$id],"</td>
#       <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_hist[level_ag()$shape$code == event$id], 1),"</td>
#       <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_2021_2050[level_ag()$shape$code == event$id], 1),"</td>
#       <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_2071_2100[level_ag()$shape$code == event$id], 1),"</td>
#       <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$change_2021_2050[level_ag()$shape$code == event$id],1),"</td>
#       <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$change_2071_2100[level_ag()$shape$code == event$id], 1),"</td>
#       </tr>
#       </table>"
#       )
#     )
#   )
#   
# })

# output$sum <- renderPrint({
#   
#   dd <- level_ag()$dat_anomalies[[values$id]]
#   if(level_ag()$reg_season != "Annual") dd <- dd[dd$season == level_ag()$reg_season,]
#   print(values$id)
#   
#   summary( dd ) 
# }) 
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)
