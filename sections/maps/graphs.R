
# tabs input ------------------------------------------------------------
anom <- reactive({
  
  # dateele
  # modificari in situatia cu Annual
  period <- ifelse(input$Season == "Annual", "annual", "seasons")
  
  anom <- paste0("www/data/tabs/anomalies/anomalies_", period, "_", input$Parameter,"_",input$Scenario,"_1971_2100.rds") %>%
    readRDS()
  # filtreaza daca ai date sezoniere
  if(input$Season != "Annual") anom <- anom %>% filter(season == input$Season)
  
  # textul pentru titlu
  if(input$Parameter == "tasAdjust") var1 <- "Tmean"
  if(input$Parameter == "tasminAdjust") var1 <- "Tmin"
  if(input$Parameter == "tasmaxAdjust") var1 <- "Tmax"
  if(input$Parameter == "prAdjust") var1 <- "Precipitation"
  var2 <- ifelse (input$Scenario == "rcp45",  "RCP4.5", "RCP8.5")
  
  anom.tit = paste(input$Season, tolower(var1),"Historical and", var2,  "1971 - 2100")
  
  list(anom = anom, anom.tit = anom.tit)
  # print(tab)
})



# anomalies plot ---------------------------------------------------------------

anomPlots <- reactive({
  
  if(input$Parameter == "prAdjust") {
    cols = c("#d8b365","#5ab4ac")
  } else {
    cols = c("#4575b4","#d73027")
  }
  
  gg <- ggplot(anom()$anom) + 
    
    geom_ribbon(aes(x = data, ymax = scen_anom_max, ymin = scen_anom_min), alpha = 0.5, fill = "gray") +
    geom_line(aes(data, scen_anom_mean),  color = "black", size = 0.8) +
    scale_x_date(breaks = c(as.Date("1971-01-01"), seq(as.Date("2000-01-01"), as.Date("2100-12-31"), by = "20 years")), date_labels = "%Y") +
    geom_bar(aes(x = data, y = obs_anom, fill = symb, group =1),
             stat = "identity", width = 400, show.legend = F,  color = "black") + 
    scale_y_continuous(
      paste0("Anomaly (", ifelse(input$Parameter == "prAdjust", "%", "°C"),")")
    ) + #breaks = seq(-8,8, 2.0),limits = c(-4,8)) +  
    scale_fill_manual( values = cols) +
    labs( x = "") + theme_bw() +
    theme(
      legend.position = "none"
      # axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 9)
    )
  
  
  
  gp <- plotly::ggplotly(gg, dynamicTicks = F)  %>% 
    plotly::layout(
      autosize=T,
      # height = 350,
      hovermode = "compare", 
      title = list(
        text = anom()$anom.tit,
        y = 0.9,
        font = list(size = 12.5)
      ),
      yaxis = list(
        title = paste0("Anomaly (", ifelse(input$Parameter == "prAdjust", "%", "°C"),")"),
        titlefont = list(
          size = 11.5
        )
      ),
      margin = list(
        b = 0,
        t = 10
      )
      #,
      # xaxis = list(
      # #   type = 'date',
      #   tickangle = 45
      # ) 
    ) %>% config(displayModeBar = FALSE)
  
  # gp$x$layout$width <- NULL
  # gp$x$layout$height <- NULL
  # gp$width <- NULL
  # gp$height <- NULL
  
  
  
  list(anom.plotly = gp, anom.ggplot = gg) 
  
})


# output$plot.anom.tit <- renderText({  
#   paste(anom()$anom.tit, " - anomalies")
# })

output$plot.anom <- plotly::renderPlotly(
  {
    anomPlots()$anom.plotly
  })

output$down.plot.anom <- downloadHandler(
  filename = function() { paste(textvar()$mean.hist %>% gsub(" " ,"_", . ) %>% tolower() ,"1971-2100.png", sep='') },
  content = function(file) {
    png(file, width = 800, height = 400, units = "px", res = 100)
    print(anomPlots()$anom.ggplot)
    dev.off()
  })






