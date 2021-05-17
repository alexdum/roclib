server <- shinyServer(function(input, output, session) {
  
  source(file = "utils/tabs_url.R", local = T)
   #observeEvent(input$RegiuneInput,
    #            updateSelectInput(session, "judetInput", "Judet",
     #                             choices = unique(date$NUME[date$CMR==input$RegiuneInput])))

  source(file = "sections/maps/maps.R", local = T)
  source(file = "sections/maps/graphs.R", local = T)
  
  
   
})

