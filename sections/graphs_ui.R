graphs_ui <- tabPanel("Multi_annual", icon = icon("layer-group"), value = "maps", id =  "#facts",
                     sidebarLayout(fluid = T,
                                   sidebarPanel(
                                     
                                                      
                                                          selectInput("Model", label = "Model",
                                                                          choices = unique(date1$model),width = "600px"),
                                                          selectInput("Scenario", label = "Scenario",
                                                                         choices =unique(date1$scen),width = "600px"),
                                              
                                                          selectInput("Parameter", label = "Parameter",
                                                                         choices =unique(date1$param),width = "600px"),
                                                          
                                                          selectInput("Season", label = "Season",
                                                                         choices =unique(date1$season),width = "600px"),
                                                          width = 4, position = "left"),
                                   # sidebarPanel(width = 2,
                                   #              #h3(format(updd, "%b %d, %Y")),
                                   #              h4(paste(infect, "Cases"),  style = "color:red"),
                                   #              h4(paste(recov, "Recovered"), style = "color:green"),
                                   #              h4(paste(decs, "Deaths"), style = "color:#636363"),        
                                   #              # dateRangeInput("daterange", "Date range:",
                                   #              #                start = min(dats.nod),
                                   #              #                end   = max(dats.nod),
                                   #              #                min = as.character(min(dats.nod)),
                                   #              #                max = as.character(max(dats.nod))),
                                   #              
                                   #              # sliderInput("opacity", "Opacity", 0.8, min = 0.1,
                                   #              #             max = 1, step = .1),,
                                   #              # submitButton("Apply Changes",icon("refresh")),
                                   #              
                                    #),
                                   mainPanel(
                                     tabsetPanel(
                                       tabPanel(" Multi-mean",
                                                fluidRow(
                                                  h3("2006-2100"),
                                                  #h5(first.case),
                                                  # h5("The first death cases reported on Mar 22, 2020."),
                                                  # h5(cfr),
                                                  # column(6,
                                                  #        
                                                  #        h4("Daily confirmed, recovered and death cases", style = "text-align:center;"),
                                                  #        
                                                  #        dygraphOutput("dygraph")
                                                         
                                                  ),
                                                  
                                                 
                                                
                                                fluidRow(
                                            
                                                         h4("", style = "text-align:center;"),
                                                         plotOutput("coolplot"),
                                                         downloadButton('downloadData', 'Download PNG')
                                                         
                                                  
                                                ),
                                                
                                                
                                                
                                       #          fluidRow(
                                       #            
                                       #            column(6,
                                       #                   
                                       #                   h4("Age of deaths", style = "text-align:center;"),
                                       #                   plotly::plotlyOutput("hist.decs")
                                       #                   
                                       #                   
                                       #            ),
                                       #            column(6,
                                       #                   h4("Country source of infection", style = "text-align:center;"),
                                       #                   plotly::plotlyOutput("hist2")
                                       #                   
                                       #            )  
                                       # 
                                        )
                                        
                                        )
                                     )
                                   )
)


