# Proteomics Analysis Tool Utilities

.FormatUniprot <- function(.uniprot) {
  # make a list of uniprot IDs, list of go_terms, and list of go_ids
  .uniprot_IDS <- NULL
  .go_TERMS <- NULL
  .go_IDS <- NULL
  for (.i in 1:nrow(.uniprot)) {
    .go_terms <- trimws(strsplit(as.character(.uniprot[.i,2]),split=';')[[1]])
    .go_ids <- NULL
    for (.j in 1:length(.go_terms)) {
      .start <- regexpr('\\[',.go_terms[.j])[1]
      .stop <- regexpr('\\]',.go_terms[.j])[1]
      .go_ids <- c(.go_ids, substr(.go_terms[.j],.start,.stop))
    }
    .uniprot_IDS <- c(.uniprot_IDS, as.character(.uniprot[.i, 1]))
    .go_TERMS <- append(.go_TERMS, list(.go_terms))
    .go_IDS <- append(.go_IDS, list(.go_ids))
  }
  .f_uniprot <- list(.uniprot_IDS, .go_TERMS, .go_IDS)
  .f_uniprot
}

.SubsetDataByGO <- function(.dat,.f_uniprot,.go_term) {
  if (.go_term == 'All') {
    .dat
  } else {
    .subsetData <- NULL
    .acc <- NULL
    for (.i in 1:length(.f_uniprot[[2]])){
      if (.go_term %in% .f_uniprot[[2]][[.i]]) {
        .acc <- c(.acc, .f_uniprot[[1]][.i])
      }
    }
    .dat[match(.acc, as.character(.dat$Accession)), ]
  }
}

.GetAllGOTerms <- function(.f_uniprot) {
  .allGOterms <- NULL
  for (.i in 1:length(.f_uniprot[[2]])) {
    .allGOterms <- union(.allGOterms, .f_uniprot[[2]][[.i]])
  }
  .allGOterms
}



  
