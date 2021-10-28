
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
                  
                  # addmapane leflet
                  "img.leaflet-tile {
                    max-width: none !important;
                    max-height: none !important;
                  }",
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
                  # sliders color toate 3
                  ".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: #E95420; border-color: #E95420;}",
                  ".js-irs-1 .irs-to,.js-irs-1 .irs-from , .js-irs-1 .irs-bar-edge, .js-irs-1 .irs-bar {background: #E95420; border-color: #E95420;}",
                  ".js-irs-2 .irs-to,.js-irs-2 .irs-from , .js-irs-2 .irs-bar-edge, .js-irs-2 .irs-bar {background: #E95420; border-color: #E95420;}"
                  # inaltime navbaer
                  #'.navbar-brand{display:none;}'
                  #'
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
