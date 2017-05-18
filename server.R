# Server for Mass Spec Data Visualization
# Geoffrey F. Schau

#runApp('massSpecShinyViewer')

library(shiny)
library(ggplot2)
library(RColorBrewer)

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
    paste0(input$go_term, ' (',nrow(.SubsetDataByGO(dat,f_uniprot,input$go_term)),' proteins)')
  })
  
  output$caption <- renderText({
    goTermText()
  })
  
  output$distPlot <- renderPlot({
    pd <- .SubsetDataByGO(dat,f_uniprot,input$go_term)
    pd <- pd[,c(2,9:11)]  # only need protein counts
    pd <- melt.data.frame(pd,id.vars='Accession')
    
    p <- ggplot(pd) + 
      geom_violin(aes(variable,value,fill=variable)) +
      geom_dotplot(aes(variable,value),binaxis = 'y',stackdir='center',dotsize = .2,stackratio = .1) +
      xlab('') +
      ylab('# Peptides') +
      scale_fill_manual(values = c('pink','lightblue','lightgreen'))

    p
    
  })
})
