
#source("sections/ui_about.R", local = T)
source("sections/graphs_ui.R", local = T)
#source("sections/ui_maps.R", local = T)

# meta tags https://rdrr.io/github/daattali/shinyalert/src/inst/examples/demo/ui.R
ui <- shinyUI(
  
  ui <- function(req) { 
    fluidPage(theme = shinytheme("darkly"),
               tags$head(
                # includeHTML("google-analytics.html"),
                 tags$style(type = "text/css", "body {padding-top: 70px;}"),
              
               ),
              useShinyjs(),
              navbarPage("RoCliB", collapsible = F, fluid = T, id = "tabs", position =  "fixed-top",
                         selected = "#maps",
                         
                         # Statistics & Facts ------------------------------------------------------
                         graphs_ui
                         
                         # maps ------------------------------------------------------
                        # maps_ui,
                         
                         #  NO2 Analysis----------------------------------------------------------
                        # no2_ui,
                         
                         # About -------------------------------------------------------------------
                        # about_ui
              )
    )
  }
)
