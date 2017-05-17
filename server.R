# Server for Mass Spec Data Visualization
# Geoffrey F. Schau

#runApp('massSpec')

library(shiny)
library(ggplot2)

source('massSpecUtils.R')
#setwd('~/Dropbox/projects/johnsProteins/massSpecShinyViewer/')
dat <- read.csv(file.path('data', 'sampleData.csv'))
uniprot <- read.csv(file.path('data', 'uniprotList.tab'), sep='\t')
f_uniprot <- .FormatUniprot()
allGoTerms <- .GetAllGOTerms()
dat.fields <- colnames(dat)

shinyServer(function(input, output) {
  
  output$datFields <- renderUI({
    selectInput('variable', 'Choose Variable:', dat.fields) 
  })
  
  output$goTerms <- renderUI({
    selectInput('go_term', 'Select GO Term:', c('All',allGoTerms))
  })
  
  goTermText <- reactive({
    input$go_term
  })
  
  output$caption <- renderText({
    goTermText()
  })
  
  output$distPlot <- renderPlot({
    pd <- .SubsetDataByGO(input$go_term)
    p <- ggplot(pd) + 
      geom_histogram(aes_string(x=input$variable), bins=input$bins)
    p
  })

})
