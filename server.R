server <- shinyServer(function(input, output, session) {
  
   #observeEvent(input$RegiuneInput,
    #            updateSelectInput(session, "judetInput", "Judet",
     #                             choices = unique(date$NUME[date$CMR==input$RegiuneInput])))

  source(file = "sections/maps/maps.R", local = T)
  
  
   
})

