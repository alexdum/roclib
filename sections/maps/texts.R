


# text titlu si salvare png si fisier -------------------------------------

text.maps <- reactive({
  
  if(input$Parameter == "tasAdjust") param <- "mean air temperature"
  if(input$Parameter == "tasminAdjust") param <- "mean minimum air temperature"
  if(input$Parameter == "tasmaxAdjust") param <- "mean minimum air temperature"
  if(input$Parameter == "prAdjust") param <- "precipitation"
 
  scen <- ifelse (input$Scenario == "rcp45",  "RCP4.5", "RCP8.5")
  period <- ifelse(grepl(2071, input$Period, fixed = TRUE), "2071-2100", "2021-2050")
  season <- input$Season
  if (season == "Annual") season <- tolower(season)
  unit <- ifelse(param == "precipitation", "%", "°C")
  
 text.change <-  paste0("Calculated change in" ,season," ",param, " (",unit,") for the period ",period ,"
                        compared with 1971-2000. The map is based on an ensemble with ten climate scenarios 
  for the ",scen," scenario. The maps below show more information about the ensembles averages 
  over two period of times.")
  
 text.anom <- paste0("The diagram shows the calculated change in " ,season, " ",param, " (",unit,") in 
                    Romania during the years 1971-2100 compared with normal (mean for 1971-2100). 
                    The bars show historic data from observations. The black line shows the ensemble
                    mean of ten climate scenarios. The grey field shows the range in variation between the highest 
                    and lowest value for the members of the ensemble.")
  
  list(
    text.change = text.change,
    text.anom = text.anom
  )
  
})

output$text.change <- renderText({
  text.maps()$text.change
})

output$text.anom <- renderText({
  text.maps()$text.anom
})