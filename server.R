server <- function(input, output, session) {
   #observeEvent(input$RegiuneInput,
    #            updateSelectInput(session, "judetInput", "Judet",
     #                             choices = unique(date$NUME[date$CMR==input$RegiuneInput])))

  filtered <- reactive({
    date1 %>% 
      filter(model == input$Model) %>%
      filter(scen == input$Scenario) %>%
      
      filter(season == input$Season)%>%
      
      filter(param == input$Parameter)
  })
  
  

  
  # updateSelectInput(session, "County", choices = judet, selected = "Alba")
  # locc = sort(meta1$name)
  # updateSelectInput(session, "Localities", choices = locc, selected = "")
  

    
  output$coolplot <- renderPlot({
     
    if(input$Parameter == "precAdjust"){
      
       ggplot() + 
        geom_tile(data= filtered(), aes(x=Lon, y=Lat,
                                        fill=value))+
        scale_fill_gradientn(name = "mm",
                             limits = c(50,
                                        600),
                             breaks = brks.p,
                             colors = cols.p)+
        geom_sf(fill="transparent", data = judete)+
        geom_sf_text(aes(label = JUDET),colour = "red",size = 3.15,data = judete)+
    
       labs(caption = "Database: @MeteoRomania")+
       theme_bw() +
       guides(fill = guide_colourbar(barwidth = 1.0, barheight = 11.6, title.position="top"))+
       theme( legend.position = "right")
    #fig <- plot_ly(filtered(), y = ~Pp, color = ~month, type = "box")
    #fig <- fig %>% layout(title = "Modifying The Algorithm For Computing Quartiles")
   
    }else{
      
        ggplot() +
        
        geom_raster(data= filtered(), aes(x=Lon, y=Lat,
                                        fill=value),interpolate = T)+
        geom_sf(fill="transparent", data = judete)+
        geom_sf_text(aes(label = JUDET),colour = "darkgrey",size = 3.15,data = judete)+
        # make title bold and add space
        
        scale_fill_gradientn(name = "°C",
                             limits = c(-6,
                                        35),
                             breaks = brks,
                             colors = cols)+ # change color scale
        #geom_tile(data = hill_spdf, aes(x = x, y = y, fill = value)) +
        #scale_fill_gradient(low = "black", high = "white") +
        #new_scale_fill() +
        #geom_tile(data = dem_spdf, aes(x = x, y = y, fill = value), alpha=0.4)
        
        labs(caption = "Database: @MeteoRomania")+
        theme_bw() +
        guides(fill = guide_colourbar(barwidth = 1.0, barheight = 14.0, title.position="top"))+
        theme( legend.position = "right" )   #c(.93,.72)
    
    }
  
      })
  
  output$downloadPlot <- downloadHandler(
    filename = function(){paste("input$coolplot",'.png',sep='')},
    content = function(file){
      ggsave(file,plot=input$coolplot)
       }
     )
  
  
   
}

