userInterface <- dashboardPage(
  dashboardHeader(titleWidth = "300px", title = HTML(
    paste("120 YEARS OF OLYMPICS DATA VISUALIZATION", img(src = "/images/logo.jpg", width = 65, height = 30), sep = " ")
  )),
  dashboardSidebar(
    disable = FALSE,
    width = "300px",
    
    shinyWidgets::sliderTextInput(
      "olympicYear",
      HTML(paste(img(src = "/images/icon.jpg", width = 25, height = 25), "OLYMPIC YEAR", sep = "")),
      choices = unique(df_olympic_regions$Year),
      selected = min(unique(df_olympic_regions$Year)),
      animate = FALSE,
      grid = TRUE
    ),
    column(12,
           box(width = NULL,
               title = "OLYMPIC SPORTS",
               htmlOutput("sports_table")))
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    fluidPage(
      column(
        8,
        box(
          collapsible = FALSE,
          width = NULL,
          solidHeader = TRUE,
          uiOutput("olympic_mapUI")
        )
      ),
      column(4,
             box(
               solidHeader = TRUE,
               width = NULL,
               highchartOutput("medals_bar_graph", height = "calc(100vh - 500px)")
             )),
      column(7,
             box(
               solidHeader = TRUE,
               width = NULL,
               highchartOutput("sports_bar_graph", height = "350px")
             )),
      column(5,
             box(
               solidHeader = TRUE,
               width = NULL,
               highchartOutput("line_graph", height = "350px")
             ))
    )
  )
)
