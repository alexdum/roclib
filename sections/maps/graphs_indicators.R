
# tabs input ------------------------------------------------------------
anom.ind <- reactive({
  # dateele
  # modificari in situatia cu Annual
  
  
  anom <- paste0("www/data/tabs/anomalies/indicators/anomalies_annual_", gsub(" ", "",input$Indicator),"_",input$Scenario.ind,"_1971_2100.rds") %>%
    readRDS()
  # filtreaza daca ai date sezoniere
  
  # textul pentru titlu
  var1 <- toupper(input$Indicator)
  
  var2 <- ifelse(input$Scenario.ind == "rcp45",  "RCP4.5", "RCP8.5")
  
  anom.tit = paste(var1,"Historical and", var2,  "1971 - 2100")
  
  list(anom = anom, anom.tit = anom.tit)
  #print(var1)
})



# anomalies plot ---------------------------------------------------------------

anomPlots.ind <- reactive({
  
  # if(input$Parameter == "prAdjust") {
  #   cols = c("#d8b365","#5ab4ac")
  # } else {
  cols = c("#4575b4","#d73027")
  # }
  
  
  # pentru pozitie logo
  plot_box <- tibble(xmin = 1971,
                     xmax = 1980,
                     ymin = 0,
                     ymax = anom.ind()$anom$scen_anom_max %>% max(),
                     xrange = xmax - xmin,
                     yrange = ymax - ymin)
  
  
  #tt <- readRDS("www/data/tabs/anomalies/indicators/anomalies_annual_coldu_rcp45_1971_2100.rds")
  gg <- ggplot(anom.ind()$anom) + 
    geom_ribbon(aes(x = date, ymax = scen_anom_max, ymin = scen_anom_min), alpha = 0.5, fill = "gray") +
    scale_x_date(breaks = c(as.Date("1971-01-01"), seq(as.Date("2000-01-01"), as.Date("2100-12-31"), by = "20 years")), date_labels = "%Y") +
    # geom_bar(aes(x = data, y = obs_anom, fill = symb, group =1),
    #          stat = "identity", width = 400, show.legend = F,  color = "black") + 
    geom_line(aes(date, scen_anom_mean),  color = "black", size = 0.8) +
    scale_y_continuous(
      #paste0("Anomaly (", ifelse(input$Parameter == "prAdjust", "%", "°C"),")")
      "Anomaly"
    ) + #breaks = seq(-8,8, 2.0),limits = c(-4,8)) +  
    scale_fill_manual( values = cols) +
    labs( x = "") + theme_bw() +
    theme(
      legend.position = "none"
      # axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 9)
    ) 
  gpl <- gg + 
    annotation_raster(logo, interpolate = T, 
                      ymin = plot_box$ymax - plot_box$yrange*0.285, 
                      ymax = anom.ind()$anom$scen_anom_max %>% max(), 
                      xmin = 750, 
                      xmax = 5300) +
    annotate("text", label = paste("@SUSCAP", Sys.Date()), x = as.Date(3000, origin = "1970-01-01"), 
             y = plot_box$ymax - plot_box$yrange*0.31, size = 2, fontface = 'italic', hjust = 0.5)
  
  
  
  gp <- plotly::ggplotly(gg, dynamicTicks = F)  %>% 
    plotly::layout(
      autosize=T,
      # height = 350,
      hovermode = "compare", 
      # title = list(
      #   text = anom.ind()$anom.tit,
      #   y = 0.9,
      #   font = list(size = 12.5)
      # ),
      yaxis = list(
        #title = paste0("Anomaly (", ifelse(input$Parameter == "prAdjust", "%", "°C"),")"),
        title  = "Anomaly",
        titlefont = list(
          size = 11.5
        )
      ),
      margin = list(
        b = 0,
        t = 20
      )
      #,
      # xaxis = list(
      # #   type = 'date',
      #   tickangle = 45
      # ) 
    ) %>% config(
      displaylogo = FALSE,
      modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "lasso2d", "zoom", "toggleSpikelines", "zoom", "select2d",
                                 "hoverCompareCartesian", "hoverClosestCartesian","autoScale2d"),
      displayModeBar = T
    )
  
  # gp$x$layout$width <- NULL
  # gp$x$layout$height <- NULL
  # gp$width <- NULL
  # gp$height <- NULL
  
  
  
  list(anom.plotly = gp, anom.ggplot = gpl) 
  
})


output$plot.anom.tit.ind <- renderText({
  paste(anom.ind()$anom.tit, " - anomalies")
})

output$plot.anom.ind <- plotly::renderPlotly(
  {
    anomPlots.ind()$anom.plotly
  })

output$down.plot.anom.ind <- downloadHandler(
  filename = function() {paste0(anom.ind()$anom.tit %>% gsub(" " ,"_", .) %>% gsub("-_" ,"", .) %>% tolower() ,".png")},
  content = function(file) {
    png(file, width = 800, height = 400, units = "px", res = 100)
    print(anomPlots.ind()$anom.ggplot)
    dev.off()
  })






