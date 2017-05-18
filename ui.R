c# UI for Mass Spec Data Visulization
# Geoffrey F. Schau

# Layout Description
# - input field for GO term
# - radio button for x-variable
# - radio button for y-variable

library(shiny)

fluidPage(
  titlePanel('Mass Spec Visualization Tool'),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput('goTerms')
    ),
    
    mainPanel(
      h3(textOutput("caption")) ,
      plotOutput("distPlot")
    )
  )
)