

# tabs input ------------------------------------------------------------
anom <- reactive({
  
  # modificari in situatia cu Annual
  period <- ifelse(input$Season == "Annual", "annual", "seasons")
   
  anom <- paste0("www/data/tabs/anomalies/anomalies_", period, "_", input$Parameter,"_",input$Scenario,"_1971_2100.rds") %>%
          readRDS()
  # filtreaza daca ai date sezoniere
  if(input$Season != "Annual") anom <- anom %>% filter(season == input$Season)
  anom
 # print(tab)
})



# anomalies plot ---------------------------------------------------------------

output$plot.anom <- plotly::renderPlotly({
  
  gp <- ggplot(anom()) + 
    geom_bar(aes(x = data, y = obs_anom, fill = symb, group =1),
             stat = "identity", width = 400, show.legend = F,  color = "black") + 
    geom_ribbon(aes(x = data, ymax = scen_anom_max, ymin = scen_anom_min), alpha = 0.5, fill = "gray") +
    geom_line(aes(data, scen_anom_mean),  color = "black", size = 0.8) +
    scale_x_date(breaks = c(as.Date("1971-01-01"), seq(as.Date("1980-01-01"), as.Date("2100-12-31"), by = "10 years")), date_labels = "%Y") +
    #scale_y_continuous("Mean air temperature anomaly (°C)", breaks = seq(-8,8, 2.0),limits = c(-4,8)) +  
    scale_fill_manual(values = c("#4575b4","#d73027")) +
    labs( x = "") + theme_bw() +
    theme(legend.position = "none") 
  
  gp <- plotly::ggplotly(gp, dynamicTicks = T) %>% plotly::layout(hovermode = "compare")
  gp
  
})




#


