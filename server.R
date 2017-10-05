# Server for Mass Spec Data Visualization
# Geoffrey F. Schau

#runApp('massSpecShinyViewer')

library(shiny)
library(reshape)
library(ggplot2)
library(RColorBrewer)

source("massSpecUtils.R")

dat <- read.csv('data/sampleData.csv')
dat.fields <- colnames(dat)

uniprot <- read.csv('data/uniprotList.tab', sep='\t')
f_uniprot <- .FormatUniprot(uniprot)
allGoTerms <- .GetAllGOTerms(f_uniprot)

shinyServer(function(input, output) {

  # in.dat <- reactive({read.csv(input$dataFile$datapath,
  #                              header = input$header,
  #                              sep = input$sep,
  #                              quote = input$quote)})
  # 
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
    #dat <- in.dat()
    
    #in.file <- input$dataFile
    #if (is.null(in.file))
    #  return(NULL)
    
    # dat <- read.csv(in.file$datapath, header=input$header)
    # dat.fields <- colnames(dat)
    
    pd <- .SubsetDataByGO(dat,f_uniprot,input$go_term)
    pd <- pd[,c(2,9:11)]
    pd <- melt.data.frame(pd,id.vars='Accession')
    
    titleText <- 'Not enough data to compute significance'
    comp1 <- try(t.test(pd$value[pd$variable=='X..Peptides.A2'],pd$value[pd$variable=='X..Peptides.B2']))
    comp2 <- try(t.test(pd$value[pd$variable=='X..Peptides.A2'],pd$value[pd$variable=='X..Peptides.C2']))
    comp3 <- try(t.test(pd$value[pd$variable=='X..Peptides.B2'],pd$value[pd$variable=='X..Peptides.C2']))
    
    try(if (comp1$p.value & comp2$p.value & comp3$p.value) {
      titleText <- try(paste('Student t-test P-values: \n A2 : B2 = ',
                             round(comp1$p.value,3), '\n A2 : C2 = ',
                             round(comp2$p.value,3), '\n B2 : C2 = ',
                             round(comp3$p.value,3)))
    })
    
    p <- ggplot(pd) +
      geom_violin(aes(variable,value,fill=variable),adjust=4) +
      geom_dotplot(aes(variable,value),binaxis = 'y',stackdir='center',dotsize = .2,stackratio = .1) +
      xlab('') +
      ylab('# Peptides') +
      scale_fill_manual(values = c('pink','lightblue','lightgreen')) +
      expand_limits(y=0) +
      ggtitle(titleText)
    p
  })
  
  output$pepCount <- renderDataTable({
    # sorted by total peptide counts
    pd <- .SubsetDataByGO(dat,f_uniprot,input$go_term)
    pd <- pd[,c(2,3,6,9,10,11)]
    names(pd) <- c('Accession','Description','UniquePeptides','A2','B2','C2')
    
    pd_sort <- pd[order(pd$UniquePeptides,decreasing=T),]
    pd_sort
  })
  
  output$go_protein_count <- renderDataTable({
    goCounts <- array(dim=length(allGoTerms),data=0)
    pepCounts <- array(dim=length(allGoTerms),data=0)
    for (i in 1:length(allGoTerms)){
      l_dat <- .SubsetDataByGO(dat,f_uniprot,allGoTerms[i])
      goCounts[i] <- nrow(l_dat)
      pepCounts[i] <- sum(l_dat$Sum...Unique.Peptides.)
    }
    ord <- order(pepCounts, decreasing=T)
    gt_o <- allGoTerms[ord]
    go_o <- goCounts[ord]
    gp_o <- pepCounts[ord]
    pd <- data.frame(gt_o, go_o, gp_o)
    names(pd) <- c('GoTerm','ProteinCount','UniquePeptideCount')
    pd
  })
  
})
