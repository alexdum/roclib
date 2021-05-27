theme.maps <- theme(
  legend.position = c(.94, .91),
  legend.justification = c("right", "top"),
  legend.background = element_rect(fill = "lightgrey", colour = "lightgrey"),
  #plot.caption = element_text(vjust = 30, hjust = 0.040, size = 7.5),
  plot.title = element_text(vjust = -7.5, hjust = 0.5, size = 13),
  #plot.title = element_blank(),
  #plot.caption = element_blank(),
  #axis.text = element_blank(),
  axis.title = element_blank(),
  axis.ticks = element_blank(),
  #axis.ticks.length = unit(0, "pt"), #length of tick marks
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  plot.margin = margin(0, 0, 0, 0, "cm")
) 