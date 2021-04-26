graphs_ui <- tabPanel("Maps", icon = icon("globe-europe"), value = "maps", id =  "#facts",
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
                                   
                                   mainPanel(
                                     tabsetPanel(
                                       tabPanel("Multi-mean",
                                                fluidRow(
                                                  h3("2006-2100"),
                                                     
                                                  ),
                                                 fluidRow(
                                            
                                                         h4("", style = "text-align:center;"),
                                                         plotOutput("coolplot"),
                                                         downloadButton('downloadData', 'Download PNG')
                                                         
                                                  
                                                ),
                                             )
                                        
                                        )
                                    
                                     
                                     
                                     )
                                   )
)


