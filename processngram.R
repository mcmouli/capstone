
# Loading required libraries to read ngrams created with the data processing steps.

library(stringr)
library(tm)

# Ngrams Loading

N2gram <- readRDS("twogram.RData")
N3gram <- readRDS("threegram.RData") 
N4gram <- readRDS("fourgram.RData")

names(N2gram)[names(N2gram) == 'word1'] <- 'w1'
names(N2gram)[names(N2gram) == 'word2'] <- 'w2'
names(N3gram)[names(N3gram) == 'word1'] <- 'w1'
names(N3gram)[names(N3gram) == 'word2'] <- 'w2'
names(N3gram)[names(N3gram) == 'word3'] <- 'w3'
names(N4gram)[names(N4gram) == 'word1'] <- 'w1'
names(N4gram)[names(N4gram) == 'word2'] <- 'w2'
names(N4gram)[names(N4gram) == 'word3'] <- 'w3'
names(N4gram)[names(N4gram) == 'word4'] <- 'w4'

message<-""




## Next word predictor 
wordPredict <- function(inword) {
  new_word <- stripWhitespace(removeNumbers(removePunctuation(tolower(inword),preserve_intra_word_dashes = TRUE)))
  
  inword <- strsplit(new_word, " ")[[1]]
  
  n <- length(inword)
  
  if (n == 1) {inword <- as.character(tail(inword,1)); findinN2gram(inword)}
  
  ################ check trigram
  else if (n == 2) {inword <- as.character(tail(inword,2)); findinN3gram(inword)}
  
  ############### check quadgram
  else if (n >= 3) {inword <- as.character(tail(inword,3)); findinN4gram(inword)}
}



findinN2gram <- function(inword) {
  if (identical(character(0),as.character(head(N2gram[N2gram$w1 == inword[1], 2], 1)))) {

        message<<-"Oops we dont find the word - pleas use - it" 
    as.character(head("it",1))
  }
  else {
    message <<- "finding the next word possible from the Bigram data -  "
    as.character(head(N2gram[N2gram$w1 == inword[1],2], 1)) 

  }
}

findinN3gram <- function(inword) {
  
  if (identical(character(0),as.character(head(N3gram[N3gram$w1 == inword[1]
                                                      & N3gram$w2 == inword[2], 3], 1)))) {
    as.character(wordPredict(inword[2]))
    
  }
  else {
    message<<- "finding the next word possible from the trigram data "
    as.character(head(N3gram[N3gram$w1 == inword[1]
                             & N3gram$w2 == inword[2], 3], 1))

  }
}

findinN4gram <- function(inword) {
  # testing print(inword)
  if (identical(character(0),as.character(head(N4gram[N4gram$w1 == inword[1]
                                                      & N4gram$w2 == inword[2]
                                                      & N4gram$w3 == inword[3], 4], 1)))) {
    as.character(wordPredict(paste(inword[2],inword[3],sep=" ")))
  }
  else {
    message <<- "finding the next word possible from quadragram data"
    as.character(head(N4gram[N4gram$w1 == inword[1] 
                             & N4gram$w2 == inword[2]
                             & N4gram$w3 == inword[3], 4], 1))

  }       
}
