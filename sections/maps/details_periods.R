
#plot(shape["code"])
# shape <- read_sf("misc/data/ro_uat_poligon_simp.shp") %>% st_set_crs (3844) %>% st_transform(4326)
# names(shape)[1] <- "code"


# recptie data ------------------------------------------------------------

level_ag <- eventReactive(list(input$go,isolate(input$tab_being_displayed),input$regio_ag),{
  
  
  # selectare regiune
  region <- as.numeric(input$regio_ag)
  
  reg_param <- input$regio_param
  reg_scen <- input$regio_scen
  reg_season <- input$regio_season
  hist_per <- input$hist_per
  scen_per <- input$scen_per
  # print(hist_per)
  # region <- 3
  # reg_param <- "prAdjust"
  # reg_period <- "mean_scen"
  # reg_scen <-  "rcp45"
  # reg_season <- "JJA"
  # hist_per <- c(1971,2000)
  # scen_per <- c(2021,2050)
  
  
  reg_scenform <- ifelse(reg_scen  == "rcp45",  "RCP4.5", "RCP8.5")
  
  dat <- readRDS(paste0("www/data/tabs/anomalies/variables/",c("region","county", "uat")[region],"_anomalies_",ifelse(reg_season == "Annual", "annual", "seasons"),"_",reg_param,"_",reg_scen,"_1971_2100.rds"))
  name_anom <- names(dat$anomalies)
  
  dat_anomalies <- dat$anomalies %>% data.table::rbindlist(idcol = 'name') %>%  filter(if("season" %in% names(.)) season == reg_season else TRUE) %>%
             as_tibble()

 
  # print(head(dat_anomalies))
  # schimbare du funct calc_func
  dat_changes <- change_scen(dat_anomalies, reg_param, hist_per, scen_per )
  
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
  
  
  #print( length(names(dat_anomalies)))
  #print( paste(reg_param, region))
  # returneaza ca lista sa poti duce ambele variabile
  list(shape = shape, reg_paramnam  = reg_paramnam ,
       reg_name = reg_name, reg_season = reg_season, reg_scenform = reg_scenform, dat_anomalies = dat_anomalies, 
       reg_val = length(names(dat_anomalies)), reg_paraminit = reg_param, reg_hist_per = input$hist_per,
       reg_scen_per = input$scen_per,  name_anom =  name_anom )
  
})


# harta leaflet -----------------------------------------------------------


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
  
  # adauga values pentru legenda
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
                     <font size='1' color='#E95420'>Click to 
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
  proxy %>%
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


# reactive values ---------------------------------------------------------


values  <- reactiveValues(id = NULL, name = NULL, code = NULL)

observeEvent(list(isolate(input$go),isolate(input$tab_being_displayed), input$regio_ag),{
  
  #values$id <- level_ag()$reg_val
  #print(level_ag()$reg_val)
  
  # regiune implicita pe baza unui random number
  first_sel <- sample(1:length(level_ag()$shape$code),1)
  values$name <- level_ag()$shape$name[first_sel]
  values$code <- level_ag()$shape$code[first_sel]
  values$id <- level_ag()$name_anom[level_ag()$name_anom %in% as.numeric(values$code)]
  #print(paste(values$id ,"observe"))
  # print(names(level_ag()$dat_anomalies))
  # print(values$code)
  # print(paste("values$id react values", values$id))
})

observeEvent(input$map_shape_click$id,{ 
  values$id <- level_ag()$name_anom[level_ag()$name_anom %in% input$map_shape_click$id]
  #print(paste(values$id ,"click"))
  values$name <- level_ag()$shape$name[level_ag()$shape$code == input$map_shape_click$id]
  values$code <- level_ag()$shape$code[level_ag()$shape$code == input$map_shape_click$id]
  
}) 

data_sub <- eventReactive(list(input$go,values$id), {
  #print(dim( level_ag()$dat_anomalies))
  dd <- level_ag()$dat_anomalies
  #print(paste("values$id plot",values$id))
  dd <- dd %>% filter(as.numeric(name) == values$id)
  #print(head(dd))
  #print(head(dd))
  
  
  list(dd = dd)
})


output$cnty <- renderUI({
  HTML(
    paste0(
      "<table>
        <strong>",
      level_ag()$reg_name," ",level_ag()$reg_scenform," ",level_ag()$reg_season," ", level_ag()$reg_paramnam
      ,"</strong>
      <tr>
      <th style='padding:5px 10px 5px 5px'>Name Region</th>
      <th style='padding:5px 10px 5px 5px'>Mean ",level_ag()$reg_hist_per[1],"-",level_ag()$reg_hist_per[2],"</th>
      <th style='padding:5px 10px 5px 5px'>Mean ",level_ag()$reg_scen_per[1],"-",level_ag()$reg_scen_per[2],"</th>
      <th style='padding:5px 10px 5px 5px'>Change ",level_ag()$reg_scen_per[1],"-",level_ag()$reg_scen_per[2]," 
      vs. ",level_ag()$reg_hist_per[1],"-",level_ag()$reg_hist_per[2],"</th>
      </tr>
      <tr>
      <td style='padding:5px 10px 5px 5px'>",level_ag()$shape$name[level_ag()$shape$code ==   values$code],"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_hist[level_ag()$shape$code ==   values$code ], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$mean_scen[level_ag()$shape$code ==   values$code ], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag()$shape$change[level_ag()$shape$code ==   values$code], 1),"</td>
     </tr>
      </table>",
     "<font size='2' color='#E95420'>Click on the region of interest to update the values and graph below the map </font>"
    )
  )
})


output$plot_regio_evo_tit <- renderText({
  # print(level_ag()$shape$name[level_ag()$shape$code == values$id])
  # paste(values$name, values$season, tolower(values$reg_paramnam),"Historical and", values$scenario,  "1971 - 2100")
  paste(level_ag()$shape$name[level_ag()$shape$code == values$code], level_ag()$reg_name,level_ag()$reg_scenform,level_ag()$reg_season,level_ag()$reg_paramnam)
  
})



# grafic ------------------------------------------------------------------

# grafic plot
output$plot_regio_evo<- renderPlotly({
  
  # print(head(data_sub()$dd))
  #
  gg <- plotly_evolution(data_sub()$dd, "obs_anom", "scen_anom_min", "scen_anom_mean","scen_anom_max", parameter =  level_ag()$reg_paraminit)
  gg
  
})

# grafic descarca
plot_regio_down <- reactive({
  
  gg_evolution(data_sub()$dd, "obs_anom", "scen_anom_min", "scen_anom_mean","scen_anom_max", parameter =level_ag()$reg_paraminit)
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





# date grafic ------------------------------------------------------------------



output$change_regio <- DT::renderDT({
  
  
  
  DT::datatable(data_sub()$dd, extensions = 'Buttons', rownames = F,
                options = list(
                  dom = 'Bfrtip',
                  pageLength = 5, autoWidth = TRUE,
                  buttons = c('pageLength','copy', 'csv', 'excel'),
                  pagelength = 10, lengthMenu = list(c(10, 25, 100, -1), c('10', '25', '100','All')
                  )
                  
                )
  )
  
})

# # click mouseover
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
