# UI for Mass Spec Data Visulization
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
      
      uiOutput('datFields'),
      
      uiOutput('goTerms'),
      
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    mainPanel(
      h3(textOutput("caption")) ,
      plotOutput("distPlot")
    )
    
  )
)