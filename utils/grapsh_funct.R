gg_evolution <-  function(input, obs_anom, scen_anom_min, scen_anom_mean, scen_anom_max, parameter  ) {
  
  if(parameter == "prAdjust") {
    cols = c("#d8b365","#5ab4ac")
  } else {
    cols = c("#4575b4","#d73027")
  }
  
  
  gg <- ggplot(input) + 
    geom_ribbon(aes(x = data, ymax = scen_anom_max, ymin = scen_anom_min), alpha = 0.5, fill = "gray") +
    scale_x_date(breaks = c(as.Date("1971-01-01"), seq(as.Date("2000-01-01"), as.Date("2100-12-31"), by = "20 years")), date_labels = "%Y") +
    geom_bar(aes(x = data, y = obs_anom, fill = symb, group =1),
             stat = "identity", width = 400, show.legend = F,  color = "black") + 
    geom_line(aes(data, scen_anom_mean),  color = "black", size = 0.8) +
    scale_y_continuous(
      paste0("Anomaly (", ifelse(parameter == "prAdjust", "%", "°C"),")")
    ) + #breaks = seq(-8,8, 2.0),limits = c(-4,8)) +  
    scale_fill_manual( values = cols) +
    labs( x = "") + theme_bw() +
    theme(
      legend.position = "none"
      # axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 9)
    ) 
  
  #limitele plotului pentru logo
  pxmax <- ggplot_build(gg)$layout$panel_params[[1]]$y.range[2]
  pxmax <- pxmax - ((pxmax*10)/100)
  # pentru pozitie logo
  plot_box <- tibble(xmin = 1971,
                     xmax = 1980,
                     ymin = 0,
                     ymax =  pxmax,
                     xrange = xmax - xmin,
                     yrange = ymax - ymin)
  
  gpl <- gg + 
    annotation_raster(logo, interpolate = T, 
                      ymin = plot_box$ymax - plot_box$yrange*0.285, 
                      ymax =  pxmax, 
                      xmin = 750, 
                      xmax = 5300) +
    annotate("text", label = paste("@SUSCAP", Sys.Date()), x = as.Date(3000, origin = "1970-01-01"), 
             y = plot_box$ymax - plot_box$yrange*0.31, size = 2, fontface = 'italic', hjust = 0.5)
  
  return(gpl)
}



plotly_evolution <- function(input, obs_anom, scen_anom_min, scen_anom_mean, scen_anom_max, parameter) {
  
  if(parameter == "prAdjust") {
    cols = c("#d8b365","#5ab4ac")
  } else {
    cols = c("#4575b4","#d73027")
  }
  
  
  # pentru pozitie logo
  plot_box <- tibble(xmin = 1971,
                     xmax = 1980,
                     ymin = 0,
                     ymax = max(input[,"scen_anom_max"]),
                     xrange = xmax - xmin,
                     yrange = ymax - ymin)
  gg <- ggplot(input) + 
    geom_ribbon(aes(x = data, ymax = scen_anom_max, ymin = scen_anom_min), alpha = 0.5, fill = "gray") +
    scale_x_date(breaks = c(as.Date("1971-01-01"), seq(as.Date("2000-01-01"), as.Date("2100-12-31"), by = "20 years")), date_labels = "%Y") +
    geom_bar(aes(x = data, y = obs_anom, fill = symb, group =1),
             stat = "identity", width = 400, show.legend = F,  color = "black") + 
    geom_line(aes(data, scen_anom_mean),  color = "black", size = 0.8) +
    scale_y_continuous(
      paste0("Anomaly (", ifelse(parameter == "prAdjust", "%", "°C"),")")
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
                      ymax = max(scen_anom_max), 
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
      #   text = anom()$anom.tit,
      #   y = 0.9,
      #   font = list(size = 12.5)
      # ),
      yaxis = list(
        title = paste0("Anomaly (", ifelse(parameter == "prAdjust", "%", "°C"),")"),
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
  
  return(gp)
}