


# text titlu si salvare png si fisier -------------------------------------

text.maps.ind <- reactive({
  
  param <-  tools::toTitleCase(input$Indicator) %>% gsub("u", " Units", .) %>%
    gsub("  ", " ", .) %>% gsub("Pr", "Precipitation", .) %>% gsub("No", "number of days", .)
    
    scen <- ifelse (input$Scenario.ind == "rcp45",  "RCP4.5", "RCP8.5")
    period <- ifelse(grepl(2071, input$Period.ind, fixed = TRUE), "2071-2100 vs. 1971-2000", "2021-2050 vs. 1971-2000")
    
    unit<- ifelse(substr(input$Indicator, 1,2) != "pr", "Σ°C", "mm")
    if (input$Indicator == "scorch no") units <- "days"
    
    text.change <-  paste0("Calculated change in ",param, " (",unit,") for the period ",period ,"
                        compared with 1971-2000. The map is based on an ensemble with ten climate scenarios 
  for the ",scen," scenario. The maps below show more information about the ensembles averages.")
    
    text.anom <- paste0("The diagram shows the calculated change in ",param, " (",unit,") in 
                    Romania during the years 1971-2100 compared with normal (mean for 1971-2100).The black line shows the ensemble
                    mean of ten climate scenarios. The grey field shows the range in variation between the highest 
                    and lowest value for the members of the ensemble.")
    
    list(
      text.change = text.change,
      text.anom = text.anom
    )
    
})

output$text.change.ind <- renderText({
  text.maps.ind()$text.change
})

output$text.anom.ind <- renderText({
  text.maps.ind()$text.anom
})