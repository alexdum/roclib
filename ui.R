
#source("sections/ui_about.R", local = T)
source("sections/graphs_ui.R", local = T)
#source("sections/ui_maps.R", local = T)

# meta tags https://rdrr.io/github/daattali/shinyalert/src/inst/examples/demo/ui.R
ui <- shinyUI(
  
  ui <- function(req) { 
    fluidPage(theme = shinytheme("darkly"),
               tags$head(
                 includeHTML("google-analytics.html"),
                 tags$style(type = "text/css", "body {padding-top: 70px;}"),
              #   # pentru leafle t
              #   tags$meta(charset = "UTF-8"),
              #   tags$meta(name = "description", content = "Relevant facts and statistics about COVID-19 spread in Romania."),
              #   tags$meta(name = "keywords", content = "COVID-19, Romania, spread maps, relevant graphs"),
              #   tags$meta(name = "author", content = "Alexandru Dumitrescu"),
              #   tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0")
               ),
              useShinyjs(),
              navbarPage("RoCliB", collapsible = F, fluid = T, id = "tabs", position =  "fixed-top",
                         selected = "#about",
                         
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
