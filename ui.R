# UI for Mass Spec Data Visulization
# Geoffrey F. Schau

# Layout Description
# - input field for GO term
# - radio button for x-variable
# - radio button for y-variable

library(shiny)

data.cols <- c('Counter','Accession','Description','Sum_Coverage',
               'Sum_Proteins','Sum_UniquePeptides','Sum_Peptides',
               'Sum_PSMs','PeptidesA2','PeptidesB2','PeptidesC2',
               'PSMA2','PSMB2','PSMC2','CoverageA2','CoverageB2',
               'CoverageC2','ScoreA2','ScoreB2','ScoreC2','AAs','MW_kDa','calc.pl')

dat.num.cols <- c('Sum_Proteins','Sum_UniquePeptides','Sum_Peptides',
                  'Sum_PSMs','PeptidesA2','PeptidesB2','PeptidesC2',
                  'PSMA2','PSMB2','PSMC2','ScoreA2','ScoreB2','ScoreC2',
                  'AAs','MW_kDa','calc.pl')

allGoTerms <- .GetAllGOTerms()

fluidPage(
  titlePanel('Mass Spec Visualization Tool'),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("variable", "Choose a variable:", 
                  choices = dat.num.cols),
      
      selectInput("go_term", "Choose a GO term:", 
                  choices = c('All', allGoTerms), 
                  'All'),
      
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