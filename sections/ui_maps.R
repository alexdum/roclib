ui_maps <- tabPanel(
  "Maps", icon = icon("globe-europe"), value = "#maps", id = "#maps",
  h4("Maps"),
  
  HTML("Here are shown relevant maps for essential climate variables (CVs) and indicators that can 
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
      
      sidebarLayout(
        fluid = T,
        
        sidebarPanel(
          width = 3,
          
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
          
          selectInput("Season", label = "Annual/Season",
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
              
             
              fluidRow(
                #style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
                
                style = "padding-left: 50px;",
                downloadLink('downpchange', label = 'Download  PNG'),
                "|",
                downloadLink('downrchange', 'Download GeoTIFF')
              ),
              p(textOutput("text.change"), style = "text-align:justify;")
            ),
            column(
              width = 6, 
              
              h5(textOutput("plot.anom.tit"), style = "text-align:center;"),
              # div(
              plotly::plotlyOutput("plot.anom", inline = T, height = "310px") %>% withSpinner(size = 0.5),
              #   style="margin-top: 0px;"
              # ),
              
             
              fluidRow(
                style = "padding-left: 50px;",
                downloadLink('down.plot.anom', label = 'Download  PNG')
              ),    
              p(textOutput("text.anom"), style = "text-align:justify;")
            )
          ),
          
          fluidRow(
            style = "border-style: solid;border: 1px solid #e3e3e3;;border-radius: 4px;",
            column(
              width = 6, plotOutput("plot.scen", inline = T) %>% withSpinner(size = 0.5),
              fluidRow(
                style = "padding-left: 50px; padding-top: 0px;",
                downloadLink('downpmean', label = 'Download  PNG'),
                "|",
                downloadLink('downrmean', 'Download GeoTIFF')
              )
            ),
            column(
              width = 6, plotOutput("plot.hist", inline = T) %>% withSpinner(size = 0.5),
              fluidRow(
                style = "padding-left: 50px; padding-top: 0px;",
                downloadLink('downphist', label = 'Download  PNG'),
                "|",
                downloadLink('downrhist', 'Download GeoTIFF')
                
              )
            )
          )
        )
      )
    )
  )
)