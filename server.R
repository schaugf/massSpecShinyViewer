# Server for Mass Spec Data Visualization
# Geoffrey F. Schau

#runApp('massSpecShinyViewer')

library(shiny)
library(ggplot2)

source("massSpecUtils.R")

dat <- read.csv('data/sampleData.csv')
uniprot <- read.csv('data/uniprotList.tab', sep='\t')

f_uniprot <- .FormatUniprot(uniprot)
allGoTerms <- .GetAllGOTerms(f_uniprot)
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
    pd <- .SubsetDataByGO(dat,f_uniprot,input$go_term)
    p <- ggplot(pd) + 
      geom_histogram(aes_string(x=input$variable), bins=input$bins)
    p
  })

})
