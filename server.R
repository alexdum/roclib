server <- shinyServer(function(input, output, session) {
  
  source(file = "utils/tabs_url.R", local = T)
   #observeEvent(input$RegiuneInput,
    #            updateSelectInput(session, "judetInput", "Judet",
     #                             choices = unique(date$NUME[date$CMR==input$RegiuneInput])))

  source(file = "sections/maps/texts.R", local = T)
  source(file = "sections/maps/maps.R", local = T)
  source(file = "sections/maps/graphs.R", local = T)
  
  # run code before accesing section
  outputOptions(output, "plot.anom.tit", suspendWhenHidden = FALSE)
  outputOptions(output, "plot.anom", suspendWhenHidden = FALSE)
  outputOptions(output, "text.anom", suspendWhenHidden = FALSE)
  outputOptions(output, "down.plot.anom", suspendWhenHidden = FALSE)
   
})

