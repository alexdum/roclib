
#source("sections/ui_about.R", local = T)
#source("sections/ui_graphs.R", local = T)
source("sections/ui_maps.R", local = T)
source("sections/ui_about.R", local = T)

# meta tags https://rdrr.io/github/daattali/shinyalert/src/inst/examples/demo/ui.R
ui <- shinyUI(
  
  ui <- function(req) { 
    fluidPage(theme = shinytheme("united"),
              tags$head(
                
                # includeHTML("google-analytics.html"),
                tags$style(
                  type = "text/css", 
                  "header {
                    border: 1px solid blue;
                    height: 150px;
                    display: flex;                   /* defines flexbox */
                      flex-direction: column;          /* top to bottom */
                      justify-content: space-between;  /* first item at start, last at end */
                  }",
                  "section {
                    border: 1px solid blue;
                    height: 150px;
                    display: flex;                   /* defines flexbox */
                      align-items: flex-end;           /* bottom of the box */
                  }",
                  "body {padding-top: 70px;}",
                  # responsive images
                  "img {max-width: 100%; width: 100%; height: auto}",
                  # inaltime navbaer
                  #'.navbar-brand{display:none;}'
                )
                
              ),
              useShinyjs(),
              navbarPage("RoCliB data explorer", 
                         # tags$head(
                         #   tags$style(HTML(
                         #     ' .navbar-nav>li>a {
                         #      padding-top: 5px;
                         #   padding-bottom: 5px;
                         #   
                         #              }',
                         #   '.navbar {min-height:5px !important;}'
                         #   ))
                         # ),
                         
                         collapsible = T, fluid = T, id = "tabs", position =  "fixed-top",
                         selected = "#about",
                         
                         # Statistics & Facts ------------------------------------------------------
                         #ui_graphs
                         
                         # maps ------------------------------------------------------
                         ui_maps,
                         
                         #  NO2 Analysis----------------------------------------------------------
                         # no2_ui,
                         
                         # About -------------------------------------------------------------------
                         about_ui
              )
    )
  }
)
