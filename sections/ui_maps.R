ui_maps <- tabPanel(
  "Maps and graphs", icon = icon("chart-line"), value = "#maps", id = "#maps",
  h4("Maps and graphs"),
  
  HTML("Here are shown relevant maps and graphs for essential climate variables (CVs) and indicators that can 
                         be used for climate change analysis in Romania. The maps can be downloaded as PNG file, and
                         the raster data used to compute the maps can be downloaded for each visualised variable in GeoTIFF format."),
  tags$br(""),
  tabsetPanel( 
    tabPanel(
      h5("Climate variables"),
      tags$h6(" "),
      HTML("The climate variables' (CVs) changes are computed for each season and at
           the annual scale as differences between future periods (2021-2050 and 2071-2100)
           and the historical period (1971-2000). The changes are computed as absolute (°C) 
           for air temperature and relative (%) for precipitation."),
      
      tags$br(""),
      
      # Variables ---------------------------------------------------------------
      
      sidebarLayout(
        fluid = T,
        
        sidebarPanel(
          width = 3,
          h5("Selection Options"),
          selectInput("Parameter", label = "Parameter",
                      c("Mean temperature" =  "tasAdjust", "Precipitation" = "prAdjust",
                        "Mean min.temperature" = "tasminAdjust", "Mean max.temperature" =  "tasmaxAdjust"),
                      selected = "Temperature", width = "220px"),
          selectInput("Period", label = "Period",
                      c("2071-2100 vs. 1971-2000" =  "20710301-21001130",
                        "2021-2050 vs. 1971-2000" =  "20210301-20501130"),  
                      width = "220px",
                      selected = "2071-2100 vs. 1971-2000"),
          
          selectInput("Scenario", label = "Scenario",
                      c("RCP4.5" =  "rcp45",
                        "RCP8.5" =  "rcp85") ,
                      width = "220px",
                      selected = "RCP4.5"),
          
          selectInput("Season", label = "Season",
                      c("Annual" = "Annual", "DJF" =  "DJF", "MAM" =  "MAM", 
                        "JJA" =  "JJA", "SON" = "SON" ),
                      width = "220px", selected = "Annual"),
          # downloadButton('downloadPlot', 'Download   PNG', 
          #                style = "padding: 5px 20px 5px 24px;margin: 5px 5px 5px 5px; "),
          # h5(""),
          # downloadButton('downloadRaster', 'Download GeoTIFF',
          #                style = "padding: 5px 10px 5px 10px;margin: 5px 5px 5px 5px; ")
        ),
        
        mainPanel(
          width = 9,
          fluidRow(
            style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
            
            column(
              width = 6, 
              
              plotOutput("plot.change", inline = T) %>% withSpinner(size = 0.5),
              
              p(textOutput("text.change"), style = "text-align:justify;"),
              #style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
              
              
              #style = "padding-left: 50px;",
              downloadLink('downpchange', label = 'Download  PNG'),
              "|",
              downloadLink('downrchange', 'Download GeoTIFF')
              
              
            ),
            
            column(
              width = 6, 
              
              h5(textOutput("plot.anom.tit"), style = "text-align:center;"),
              # div(
              plotly::plotlyOutput("plot.anom", inline = T, height = "240px") %>% 
                withSpinner(size = 0.5),
              # 
              # ),
              p(textOutput("text.anom"), style = "text-align:justify;"),
              
              
              #fluidRow(
              tags$div(class = "header",
                       downloadLink('down.plot.anom', label = 'Download  PNG')
              )    
              #  )
              # )
            )
          ),
          
          fluidRow(
            style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
            column(
              width = 6, plotOutput("plot.scen", inline = T) %>% withSpinner(size = 0.5),
              
              downloadLink('downpmean', label = 'Download  PNG'),
              "|",
              downloadLink('downrmean', 'Download GeoTIFF')
              
            ),
            column(
              width = 6, plotOutput("plot.hist", inline = T) %>% withSpinner(size = 0.5),
              
              downloadLink('downphist', label = 'Download  PNG'),
              "|",
              downloadLink('downrhist', 'Download GeoTIFF')
              
              
            )
          )
        )
      )
    ),
    
    # Indicators --------------------------------------------------------------
    
    tabPanel(
      h5("Indicators"),
      tags$h6(" "),
      HTML("The climate indices changes are computed at the annual scale as differences between future periods (2021-2050 and 2071-2100)
           and the historical period (1971-2000). The changes are computed as relative (%) for precipitation and as 
           absolute ( Σ°C, number of days) for the rest of the indices."),
      tags$br(""),
      
      sidebarLayout(
        fluid = T,
        
        sidebarPanel(
          width = 3,
          h4("Selection Options"),
          selectInput("Indicator", label = "Indicator",
                      c(
                        "Heat units Spring" = "heat u spring","Heat units Fall" = "heat u fall",
                        "Scorching number of days" = "scorch no", "Scorching units" = "scorch u",
                        "Cold units" =  "coldu", "Frost units 10" = "frostu 10",
                        "Frost units 15" = "frostu 15","Frost units 20" = "frostu 20",
                        "Precipitation vegetation" = "pr veget", "Precipitation Fall" = "pr fall",
                        "Precipitation Winter" = "pr winter"
                      ), selected = "Heat units Spring", width = "220px"),
          
          p(textOutput("text.desc.ind"), style = "text-align:justify;"),
          
          selectInput("Period.ind", label = "Period",
                      c("2071-2100 vs. 1971-2000" =  "2071-2100",
                        "2021-2050 vs. 1971-2000" =  "2021-2050"),  
                      width = "220px",
                      selected = "2071-2100 vs. 1971-2000"),
          
          selectInput("Scenario.ind", label = "Scenario",
                      c("RCP4.5" =  "rcp45",
                        "RCP8.5" =  "rcp85") ,
                      width = "220px",
                      selected = "RCP4.5")
          # downloadButton('downloadPlot', 'Download   PNG', 
          #                style = "padding: 5px 20px 5px 24px;margin: 5px 5px 5px 5px; "),
          # h5(""),
          # downloadButton('downloadRaster', 'Download GeoTIFF',
          #                style = "padding: 5px 10px 5px 10px;margin: 5px 5px 5px 5px; ")
        ),
        
        mainPanel(
          width = 9,
          fluidRow(
            style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
            column(
              width = 6, 
              plotOutput("plot.change.ind", inline = T) %>% withSpinner(size = 0.5),
              p(textOutput("text.change.ind"), style = "text-align:justify;"),
              #style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
              #style = "padding-left: 50px;",
              downloadLink('downpchange.ind', label = 'Download  PNG'),
              "|",
              downloadLink('downrchange.ind', 'Download GeoTIFF')
            ),
            
            column(
              width = 6,
              h5(textOutput("plot.anom.tit.ind"), style = "text-align:center;"),
              # div(
              plotly::plotlyOutput("plot.anom.ind", inline = T, height = "240px") %>% 
                withSpinner(size = 0.5),
              # 
              # ),
              p(textOutput("text.anom.ind"), style = "text-align:justify;"),
              #fluidRow(
              tags$div(class = "header",
                       downloadLink('down.plot.anom.ind', label = 'Download  PNG')
              )    
              #  )
              # )
            )
          ),
          fluidRow(
            style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
            column(
              width = 6, plotOutput("plot.scen.ind", inline = T) %>% withSpinner(size = 0.5),
              
              downloadLink('downpmean.ind', label = 'Download  PNG'),
              "|",
              downloadLink('downrmean.ind', 'Download GeoTIFF')
              
            ),
            column(
              width = 6, plotOutput("plot.hist.ind", inline = T) %>% withSpinner(size = 0.5),
              
              downloadLink('downphist.ind', label = 'Download  PNG'),
              "|",
              downloadLink('downrhist.ind', 'Download GeoTIFF')
              
              
            )
          )
          
          
          
        )
      )
    ),
    
    # Details vars ------------------------------------------------------
    
    tabPanel(value = "Explore in detail",
             title = h5("Explore in detail"),
             tags$h6(" "),
             HTML("The climate variables and indicators are aggregated at the NUTS2 (Regions), NUTS3 (Counties) 
           and LAU (Local administrative units) 
           (see <a href='https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Romania#Local_administrative_units' target='_blank'> Romania administrative units</a> )."),
           tags$br(""),
           
           tabsetPanel( 
             id = "tab_being_displayed",
             
             tabPanel(
               value = "Climate variables",
               title = h5("Climate variables"),
               
               sidebarLayout(
                 fluid = T,
                 
                 sidebarPanel(
                   width = 3,
                   h5("Map settings"),
                   wellPanel(
                     selectInput("regio_ag", label = "Select type of administrative unit",
                                 c(
                                   "NUTS2" = 1,"NUTS3" = 2, "LAU (UAT)"= 3
                                 ), selected = 2, width = "220px"), 
                     selectInput("regio_period", label = "Parameter to display on the map",
                                 c(
                                   "Historical period mean" = "mean_hist", 
                                   "Scenario period mean" = "mean_scen",
                                   "Changes in selected variable" = "change"),
                                 selected = "mean_scen", width = "220px"
                                 
                     ),
                     sliderInput("transp", "Transparency",
                                 min = 0, max = 1, ticks = F,
                                 value = 0.5, step = 0.1,
                                 width = "220px")
                   ),
                   
                   h5("Select parameters to compute changes"),
                   wellPanel(
                     
                     selectInput("regio_param", label = "Variable",
                                 c("Mean temperature" =  "tasAdjust", "Precipitation" = "prAdjust",
                                   "Mean min.temperature" = "tasminAdjust", "Mean max.temperature" =  "tasmaxAdjust"),
                                 selected = "tasAdjust", width = "220px"),
                     
                     sliderInput("hist_per", "Historical period", 1971, 2005, value = c(1971, 2000),step = 1,
                                 dragRange = F, sep = "", width = "220px"),
                     
                     sliderInput("scen_per", "Scenario period", 2006, 2100, value = c(2021, 2050),step = 1,
                                 dragRange = F, sep = "",  width = "220px"),
                     
                     selectInput("regio_scen", label = "Scenario",
                                 c("RCP4.5" =  "rcp45",
                                   "RCP8.5" =  "rcp85") ,
                                 width = "220px",
                                 selected = "RCP4.5"),
                     
                     selectInput("regio_season", label = "Season",
                                 c("Annual" = "Annual", "DJF" =  "DJF", "MAM" =  "MAM", 
                                   "JJA" =  "JJA", "SON" = "SON" ),
                                 width = "220px", selected = "Annual"),
                     
                     
                     actionButton("go", "Update values and map", icon("sync"))
                   )
                   
                   
                   
                 ),
                 
                 mainPanel(
                   width = 9,
                   
                   wellPanel(
                     # htmlOutput("params_name"),
                     htmlOutput("cnty")
                   ),
                   
                   wellPanel(
                     leafletOutput("map"),
                   ),
                   tabsetPanel(
                     fluidRow(
                       h5(textOutput("plot_regio_evo_tit"), style = "text-align:center;")
                     ),
                     tabPanel(
                       value = "Graph",
                       title = h6("Graph"),
                       
                       plotly::plotlyOutput("plot_regio_evo")%>% 
                         withSpinner(size = 0.5),
                       downloadLink('down_plot_regio', label = 'Download  PNG')
                     ), 
                     
                     tabPanel(value = "Data",
                              title = h6("Data"),
                              DT::dataTableOutput("change_regio")
                     )
                     #verbatimTextOutput("sum")
                     
                   ) 
                   
                 )
               )
             ),
             
             # Details ind ------------------------------------------------------
             tabPanel(
               value = "Indicator",
               title = h5("Indicators"),
               
               sidebarLayout(
                 fluid = T,
                 
                 sidebarPanel(
                   width = 3,
                   h5("Map settings"),
                   wellPanel(
                     selectInput("regio_ag_ind", label = "Select type of administrative unit",
                                 c(
                                   "NUTS2" = 1,"NUTS3" = 2, "LAU (UAT)"= 3
                                 ), selected = 2, width = "220px"), 
                     selectInput("regio_period_ind", label = "Parameter to display on the map",
                                 c(
                                   "Historical period mean" = "mean_hist", 
                                   "Scenario period mean" = "mean_scen",
                                   "Changes in selected variable" = "change"),
                                 selected = "mean_scen", width = "220px"
                                 
                     ),
                     sliderInput("transp_ind", "Transparency",
                                 min = 0, max = 1, ticks = F,
                                 value = 0.5, step = 0.1,
                                 width = "220px")
                   ),
                   
                   h5("Select parameters to compute changes"),
                   wellPanel(
                     
                     selectInput("regio_ind", label = "Indicator",
                                 c(
                                   "Heat units Spring" = "heat u spring","Heat units Fall" = "heat u fall",
                                   "Scorching number of days" = "scorch no", "Scorching units" = "scorch u",
                                   "Cold units" =  "coldu", "Frost units 10" = "frostu 10",
                                   "Frost units 15" = "frostu 15","Frost units 20" = "frostu 20",
                                   "Precipitation vegetation" = "pr veget", "Precipitation Fall" = "pr fall",
                                   "Precipitation Winter" = "pr winter"
                                 ), selected = "Heat units Spring", width = "220px"),
                     
                     sliderInput("hist_per_ind", "Historical period", 1971, 2005, value = c(1971, 2000),step = 1,
                                 dragRange = F, sep = "", width = "220px"),
                     
                     sliderInput("scen_per", "Scenario period", 2006, 2100, value = c(2021, 2050),step = 1,
                                 dragRange = F, sep = "",  width = "220px"),
                     
                     selectInput("regio_scen_ind", label = "Scenario",
                                 c("RCP4.5" =  "rcp45",
                                   "RCP8.5" =  "rcp85") ,
                                 width = "220px",
                                 selected = "RCP4.5"),
                
                     
                     
                     actionButton("go", "Update values and map", icon("sync"))
                   )
                   
                   
                   
                 ),
                 
                 mainPanel(
                   width = 9
                 )
                 
                 
               )
             )
           )
    )
    # footer ------------------------------------------------------------------
  )
)






