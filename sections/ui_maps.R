ui_maps <- tabPanel("Graphs", icon = icon("globe-europe"), value = "#maps", id = "#maps",
                    sidebarLayout(fluid = T,
                                  sidebarPanel(
                                    
                                    
                                    selectInput("Period", label = "Period",
                                                c("2071-2100 vs. 1971-2000" =  "20710301-21001130",
                                                  "2021-2050 vs. 1971-2000" =  "20210301-20501130"),  
                                                width = "600px",
                                                selected = "2071-2100 vs. 1971-2000"),
                                    
                                    selectInput("Scenario", label = "Scenario",
                                                c("RCP4.5" =  "rcp45",
                                                  "RCP8.5" =  "rcp85") ,
                                                width = "600px",
                                                selected = "RCP4.5"),
                                    
                                    selectInput("Parameter", label = "Parameter",
                                                c("Tmean" =  "tasAdjust", "Prec" = "prAdjust",
                                                  "Tmin" = "tasminAdjust", "Tmax" =  "tasmaxAdjust"),
                                                selected = "Tmean", width = "600px"),
                                    
                                    selectInput("Season", label = "Season",
                                                c("DJF" =  "DJF", "MAM" =  "MAM", 
                                                  "JJA" =  "JJA", "SON" = "SON" ),
                                                width = "600px", selected = "SON")
                                  ),
                                  
                                  mainPanel(
                                    tabsetPanel(
                                      tabPanel("Changes",
                                            
                                               fluidRow(
                                                 
                                                 h5(textOutput("tabtext"), style = "text-align:center;"),
                                                 plotOutput("coolplot")
                                                 
                                                 #downloadButton('downloadData', 'Download PNG')
                                                 
                                                 
                                               ),
                                      )
                                      
                                    )
                                    
                                    
                                    
                                  )
                    )
)


