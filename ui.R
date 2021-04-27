
#source("sections/ui_about.R", local = T)
#source("sections/ui_graphs.R", local = T)
source("sections/ui_maps.R", local = T)

# meta tags https://rdrr.io/github/daattali/shinyalert/src/inst/examples/demo/ui.R
ui <- shinyUI(
  
  ui <- function(req) { 
    fluidPage(theme = shinytheme("yeti"),
               tags$head(
                # includeHTML("google-analytics.html"),
                 tags$style(type = "text/css", "body {padding-top: 70px;}"),
              
               ),
              useShinyjs(),
              navbarPage("RoCliB", collapsible = T, fluid = T, id = "tabs", position =  "fixed-top",
                         selected = "#maps",
                         
                         # Statistics & Facts ------------------------------------------------------
                         #ui_graphs
                         
                         # maps ------------------------------------------------------
                         ui_maps
                         
                         #  NO2 Analysis----------------------------------------------------------
                        # no2_ui,
                         
                         # About -------------------------------------------------------------------
                        # about_ui
              )
    )
  }
)
