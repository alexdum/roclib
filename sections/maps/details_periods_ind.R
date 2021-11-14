
#plot(shape["code"])
# shape <- read_sf("misc/data/ro_uat_poligon_simp.shp") %>% st_set_crs (3844) %>% st_transform(4326)
# names(shape)[1] <- "code"


# recptie data ------------------------------------------------------------
level_ag_ind <- eventReactive(list(input$go_ind,isolate(input$tab_being_displayed2),input$regio_ag_ind),{
  
  
  # selectare regiune
  region <- as.numeric(input$regio_ag_ind)
  reg_param <- input$regio_ind
  reg_scen <- input$regio_scen_ind
  
  hist_per <- input$hist_per_ind
  scen_per <- input$scen_per_ind
  # print(hist_per)
  # region <- 3
  # reg_param <- "coldu"
  # reg_period <- "mean_scen"
  # reg_scen <-  "rcp85"
  # hist_per <- c(1971,1980)
  # scen_per <- c(2081,2100)
  
  # print(hist_per)
  # print(scen_per)
  reg_scenform <- ifelse(reg_scen  == "rcp45",  "RCP4.5", "RCP8.5")
  
  dat <- readRDS(paste0("www/data/tabs/anomalies/indicators/",c("region","county", "uat")[region],"_anomalies_annual_",reg_param,"_",reg_scen,"_1971_2100.rds"))
  name_anom <- names(dat)
  
  
  dat_anomalies <- dat %>% data.table::rbindlist(idcol = 'name')  %>%
    as_tibble()
  
  # schimba nume sa se potriveasca cu functia
  names(dat_anomalies)[2] <- c("data")
  
  # pentru date implicite din slider cu sezon rece
  ani.hist <- dat_anomalies$data[format(dat_anomalies$data, "%Y") <= "2005"] %>% format("%Y") %>% as.numeric()
  ani.scen <- dat_anomalies$data[format(dat_anomalies$data, "%Y") > "2005"] %>% format("%Y")  %>% as.numeric()
  dat_anomalies.hist <- range(ani.hist)
  dat_anomalies.scen <- range(ani.scen)
  updateSliderInput(
    session, "hist_per_ind", min = dat_anomalies.hist[1], max = dat_anomalies.hist[2]
  ) 
  updateSliderInput(
    session, "scen_per_ind", min = dat_anomalies.scen[1], max = dat_anomalies.scen[2]
  ) 
  
  # print(head(dat_anomalies))
  # schimbare cu funct calc_func in functie de anii disponibili
  hist.per2 <- c(ani.hist[which.min(abs(ani.hist  -  hist_per[1]))], ani.hist[which.min(abs(ani.hist  -  hist_per[2]))])
  scen.per2 <- c(ani.scen[which.min(abs(ani.scen  -  scen_per[1]))], ani.scen[which.min(abs(ani.scen  -  scen_per[2]))])
  
  dat_changes <- change_scen(dat_anomalies, reg_param,  hist.per2, scen.per2)
  
  # parameter name 
  switch (
    which(c("heatuspring","heatufall","scorchno","scorchu", "coldu","frostu10", "frostu15","frostu20","prveget", "prfall", "prwinter" ) %in%  reg_param ),
    reg_paramnam  <- "Heat units Spring",
    reg_paramnam <- "Heat units Fall",
    reg_paramnam <- "Scorching number of days",
    reg_paramnam <- "Scorching units",
    reg_paramnam <- "Cold units",
    reg_paramnam <- "Frost units 10",
    reg_paramnam <- "Frost units 15",
    reg_paramnam <- "Frost units 20",
    reg_paramnam <- "Precipitation vegetation",
    reg_paramnam <- "Precipitation Fall",
    reg_paramnam <- "Precipitation Winter"
  )
  
  switch(region,
         reg_name <- "NUTS2",
         reg_name <- "NUTS3",
         reg_name <- "LAU (UAT)"
  )
  #print(reg_name)
  
  
  
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
       reg_scen_per = scen_per,  name_anom =  name_anom, reg_paramnam = reg_paramnam)
  
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
    ) %>%
    leaflet.extras::addSearchOSM (
      options = 
        leaflet.extras::searchOptions(
          collapsed = T,
          zoom = 9,
          autoCollapse = TRUE, minLength = 2,
          hideMarkerOnCollapse = TRUE
        )
    ) 
})


# # vairabile pentru legenda proxi
# pal2.legind <- reactiveValues(leg = NULL, titl = NULL )

observe({ 
  
  req(input$tab_being_displayed2 == "Indicators") # Only display if tab is 'Indicators'

 #req(input$tab_being_displayed == "Explore in detail")
  #print(input$tab_being_displayed )
  # adauga values pentru legenda
  reg_period2 <- input$regio_period_ind
  
  shape2 <- level_ag_ind()$shape
  
  # selecteaza variabila pentru plotare
  shape2$values <- shape2 %>% data.frame() %>% dplyr::select(matches(reg_period2)) %>% unlist()
  
  # legenda/culori/intervale leaflet, vezi leg_leaf_ind  din utils/map_funct.R
  pals <- leg_leaf_ind(input = shape2, param = level_ag_ind()$reg_paraminit, reg_period = reg_period2)
  palm2 <- pals$pal
  
  opacy2 <- input$transp_ind
  data2 <- shape2
  
  leafletProxy("map.ind",  data = data2)  %>%
    clearShapes() %>%
    addPolygons (
      fillColor = ~palm2(values), 
      label = ~paste("<font size='2'><b>Region type:",level_ag_ind()$reg_name, "<br/>Name units:",name,
                     "</b></font><br/>
                     <font size='1' color='#E95420'>Click to 
                     get values and graph</font>") %>% lapply(htmltools::HTML),
      #  labelOptions = labelOptions(textsize = "13px"),
      color = "grey",
      weight = 0.5, smoothFactor = 0.1,
      opacity = 0.5, 
      fillOpacity = opacy2 ,
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
    )  %>%
    clearControls() %>% 
    addLegend(
      title = ifelse (
        strsplit(reg_period2,"_")[[1]][1] == "mean" ,
        paste0("<html>", pals$leaflet_titleg,"</html>"),
        paste0("<html>", gsub(",","",toString(rep("&nbsp;", 5))), pals$leaflet_titleg,"</html>")
      ),
      "bottomright", pal = pals$pal2, values = shape2$values, opacity = 1,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
    ) %>%
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
    )
}) 

# reactive values ---------------------------------------------------------

# regiune implicita pe baza unui random number pentru prima accesare

values.ind  <- reactiveValues(id = NULL, name = NULL, code = NULL)
observeEvent(list(isolate(input$go_ind),isolate(input$tab_being_displayed2), input$regio_ag_ind),{
  
  first_sel <- sample(1:length(level_ag_ind()$shape$code),1)
  values.ind$name <- level_ag_ind()$shape$name[first_sel]
  values.ind$code <- level_ag_ind()$shape$code[first_sel]
  values.ind$id <- level_ag_ind()$name_anom[level_ag_ind()$name_anom %in% as.numeric(values.ind$code)]
  # print(paste(values$id ,"observe"))
  # print(names(level_ag_ind()$dat_anomalies))
  # print(values$code)
  # print(paste("values$id react values", values$id))
})

# pentru selectie pe click din leaflet
observeEvent(input$map.ind_shape_click$id,{ 
  values.ind$id <- level_ag_ind()$name_anom[level_ag_ind()$name_anom %in% input$map.ind_shape_click$id]
  #print(paste(values$id ,"click"))
  values.ind$name <- level_ag_ind()$shape$name[level_ag_ind()$shape$code == input$map.ind_shape_click$id]
  values.ind$code <- level_ag_ind()$shape$code[level_ag_ind()$shape$code == input$map.ind_shape_click$id]
  
}) 
data_sub_ind <- eventReactive(list(input$go_ind,values.ind$id), {
  #print(dim( level_ag()$dat_anomalies))
  dd <- level_ag_ind()$dat_anomalies
  #print(paste("values$id plot",values$id))
  dd <- dd %>% filter(as.numeric(name) == values.ind$id)
  #print(head(dd))
  #print(head(dd))
  list(dd = dd)
})

output$cnty_ind <- renderUI({
  HTML(
    paste0(
      "<table>
        <strong>",
      level_ag_ind()$reg_name," ",level_ag_ind()$reg_scenform," ", level_ag_ind()$reg_paramnam
      ,"</strong>
      <tr>
      <th style='padding:5px 10px 5px 5px'>Name Region</th>
      <th style='padding:5px 10px 5px 5px'>Mean ",level_ag_ind()$reg_hist_per[1],"-",level_ag_ind()$reg_hist_per[2],"</th>
      <th style='padding:5px 10px 5px 5px'>Mean ",level_ag_ind()$reg_scen_per[1],"-",level_ag_ind()$reg_scen_per[2],"</th>
      <th style='padding:5px 10px 5px 5px'>Change ",level_ag_ind()$reg_scen_per[1],"-",level_ag_ind()$reg_scen_per[2]," 
      vs. ",level_ag_ind()$reg_hist_per[1],"-",level_ag_ind()$reg_hist_per[2],"</th>
      </tr>
      <tr>
      <td style='padding:5px 10px 5px 5px'>",level_ag_ind()$shape$name[level_ag_ind()$shape$code ==   values.ind$code],"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag_ind()$shape$mean_hist[level_ag_ind()$shape$code ==   values.ind$code ], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag_ind()$shape$mean_scen[level_ag_ind()$shape$code ==   values.ind$code ], 1),"</td>
      <td style='padding:5px 10px 5px 5px'>",round(level_ag_ind()$shape$change[level_ag_ind()$shape$code ==   values.ind$code], 1),"</td>
     </tr>
      </table>",
     "<font size='2' color='#E95420'>Click on the region of interest to update the values and graph below the map </font>"
    )
  )
})


output$plot_regio_evo_tit_ind <- renderText({
  # print(level_ag()$shape$name[level_ag()$shape$code == values$id])
  # paste(values$name, values$season, tolower(values$reg_paramnam),"Historical and", values$scenario,  "1971 - 2100")
  paste(level_ag_ind()$shape$name[level_ag_ind()$shape$code == values.ind$code], level_ag_ind()$reg_name,level_ag_ind()$reg_scenform,level_ag_ind()$reg_season,level_ag_ind()$reg_paramnam)
  
})

# grafic ------------------------------------------------------------------

# grafic plot
output$plot_regio_evo_ind <- renderPlotly({
  
  # print(head(data_sub()$dd))
  #
  gg <- plotly_evolution(data_sub_ind()$dd, "obs_anom", "scen_anom_min", "scen_anom_mean","scen_anom_max", parameter =  level_ag_ind()$reg_paraminit)
  gg
  
})


# date grafic ------------------------------------------------------------------



output$change_regio_ind <- DT::renderDT({
  
  DT::datatable(data_sub_ind()$dd, extensions = 'Buttons', rownames = F,
                options = list(
                  dom = 'Bfrtip',
                  pageLength = 5, autoWidth = TRUE,
                  buttons = c('pageLength','copy', 'csv', 'excel'),
                  pagelength = 10, lengthMenu = list(c(10, 25, 100, -1), c('10', '25', '100','All')
                  )
                  
                )
  )
  
})
