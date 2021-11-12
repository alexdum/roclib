


# text titlu si salvare png si fisier -------------------------------------

text.maps.ind <- reactive({
  
  param <-  tools::toTitleCase(input$Indicator) %>% gsub("u", " Units", .) %>%
    gsub("  ", " ", .) %>% gsub("Pr", "Precipitation", .) %>% gsub("No", "number of days", .)
    
    scen <- ifelse (input$Scenario.ind == "rcp45",  "RCP4.5", "RCP8.5")
    period <- ifelse(grepl(2071, input$Period.ind, fixed = TRUE), "2071-2100 vs. 1971-2000", "2021-2050 vs. 1971-2000")
    
    unit<- ifelse(substr(input$Indicator, 1,2) != "pr", "Σ°C", "mm")
    if (input$Indicator == "scorch no") units <- "days"
    
    text.change <-  paste0("Calculated change in ",param, " (",unit,") for the period ",period ,"
                        compared with 1971-2000. The map is based on an ensemble of 10 RCMs 
  for the ",scen," scenario. The maps below show more information about the ensembles averages.")
    
    text.anom <- paste0("The diagram shows the calculated change in ",param, " (",unit,") in 
                    Romania during the years 1971-2100 compared with normal (mean for 1971-2100).The black line shows the ensemble
                    mean of ten climate scenarios. The grey field shows the range in variation between the highest 
                    and lowest value for the members of the ensemble.")
    
    if(input$Indicator == "heat u spring") text.desc <- "Cumulative heat units (ΣTmed. > 0°C) in the period 01 February - 10 April"
    if(input$Indicator == "heat u fall") text.desc <- "Cumulative heat units (ΣTmed. > 0°C) in the period 01 September - 31 October"
    if(input$Indicator == "scorch u") text.desc <- "Scorching heat units (ΣTmax. ≥ 32°C) from 1 June to 31 August"
    if(input$Indicator == "scorch no") text.desc <- "Scorching heat number of days (Tmax. ≥ 32°C) from 1 June to 31 August"
    if(input$Indicator == "coldu") text.desc <- "Cold units (ΣTmed. < 0°C) cumulated during the period 01 November - 31 March"
    if(input$Indicator == "frostu 10") text.desc <- "Frost units (ΣTmin. ≤ -10°C) cumulated in the period 01 December - 28/29 February"
    if(input$Indicator == "frostu 15") text.desc <- "Frost units (ΣTmin. ≤ -15°C) cumulated in the period 01 December - 28/29 February"
    if(input$Indicator == "frostu 20") text.desc <- "Frost units (ΣTmin. ≤ -20°C) cumulated in the period 01 December - 28/29 February"
    if(input$Indicator == "pr veget") text.desc <- "Precipitatin amounts (l/m²) during the autumn wheat growing season, 01 September to 30 June"
    if(input$Indicator == "pr fall") text.desc <- "Precipitation amounts (l/m²) during the autumn sowing period, 01 September - 31 October"
    if(input$Indicator == "pr winter") text.desc <- "Precipitation amounts (l/m²) during the soil water accumulation period, 01 November - 31 March"
    
    list(
      text.change = text.change,
      text.anom = text.anom, 
      text.desc = text.desc
    )
    
})

output$text.change.ind <- renderText({
  text.maps.ind()$text.change
})

output$text.anom.ind <- renderText({
  text.maps.ind()$text.anom
})

output$text.desc.ind <- renderText({
  text.maps.ind()$text.desc
})