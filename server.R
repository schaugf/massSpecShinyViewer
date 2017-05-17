# Server for Mass Spec Data Visualization
# Geoffrey F. Schau

#runApp('massSpec')

library(shiny)
library(ggplot2)

source('massSpecUtils.R')

dat <- read.csv(file.path('data', 'sampleData.csv'))
uniprot <- read.csv(file.path('data', 'uniprotList.tab'), sep='\t')
f_uniprot <- .FormatUniprot()

data.cols <- c('Counter','Accession','Description','Sum_Coverage',
              'Sum_Proteins','Sum_UniquePeptides','Sum_Peptides',
              'Sum_PSMs','PeptidesA2','PeptidesB2','PeptidesC2',
              'PSMA2','PSMB2','PSMC2','CoverageA2','CoverageB2',
              'CoverageC2','ScoreA2','ScoreB2','ScoreC2','AAs','MW_kDa','calc.pl')
colnames(dat) <- data.cols

shinyServer(function(input, output) {

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
