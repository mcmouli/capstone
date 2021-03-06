#########################################################################
#                                                                       #
#         Step 1 - Data input processing and Sampling                   #
#                                                                       #
#########################################################################

#Load all the required libraries for this assignment

library(stringi)
library(ggplot2)
library(tm)
library(RColorBrewer)
library(XML)
library(wordcloud)
library(caret)
library(NLP)
library(openNLP)
library(RWeka)
library(qdap)
library(parallel)
library(doParallel)
library(foreach)
library(markovchain)
set.seed(1234)

# Reading data from the downloaded folders & files though there are multiple locales we are considering here only en_US folder which has 
# 3 files blogs, twitter and news

en_US_blogs<-readLines(paste(getwd(),"/data/en_US/en_US.blogs.txt", sep=""))

en_US_twitter<-suppressWarnings(readLines(paste(getwd(),"/data/en_US/en_US.twitter.txt", sep="")))

en_US_news<-suppressWarnings(readLines(paste(getwd(),"/data/en_US/en_US.news.txt", sep="")))


#Sampling the overall dataset for further processing


en_US_blogs_sample<-sample(en_US_blogs, 10000)
en_US_twitter_sample<-sample(en_US_twitter, 10000)
en_US_news_sample<-sample(en_US_news, 10000)

#Building corpus

corpus<- c(en_US_blogs_sample, en_US_news_sample, en_US_twitter_sample)

#corpus<- c(en_US_blogs, en_US_news, en_US_twitter)

#removing the datasets read in order to free up memory

remove(en_US_news, en_US_twitter, en_US_blogs, en_US_news_sample, en_US_twitter_sample, en_US_blogs_sample)



#########################################################################
#                                                                       #
#         Step 2 - Data Cleansing and Tokenization                      #
#                                                                       #
#########################################################################


corpus<-removeNumbers(corpus)
corpus<-removePunctuation(corpus)
corpus<-stripWhitespace(corpus)

corpus<-tolower(corpus)
corpus<-corpus[which(corpus!="")]
corpus <- data.frame(corpus, stringsAsFactors = FALSE)

saveRDS(corpus, file = "cleanedcorpus.RDATA")


######################### 
#Uni-Gram
#########################

# Tokenizer function to get Uni-Gram
cleanedcorpus<-readRDS("cleanedcorpus.RDATA")

N1g <- NGramTokenizer(cleanedcorpus, Weka_control(min = 1, max = 1,delimiters = " \\r\\n\\t.,;:\"()?!"))
N1g <- data.frame(table(N1g))
N1g <- N1g[order(N1g$Freq,decreasing = TRUE),]

names(N1g) <- c("word1", "freq")
head(N1g)
N1g$word1 <- as.character(N1g$word1)

write.csv(N1g[N1g$freq > 1,],"N1g.csv",row.names=F)
N1g <- read.csv("N1g.csv",stringsAsFactors = F)
saveRDS(N1g, file = "N1g.RData")


#########################
#Bi-Gram
#########################
# Tokenizer function to get Bi-Gram
N2g <- NGramTokenizer(cleanedcorpus, Weka_control(min = 2, max = 2,delimiters = " \\r\\n\\t.,;:\"()?!"))
N2g <- data.frame(table(N2g))
N2g <- N2g[order(N2g$Freq,decreasing = TRUE),]
names(N2g) <- c("words","freq")
head(N2g)
N2g$words <- as.character(N2g$words)
string2 <- strsplit(N2g$words,split=" ")
N2g <- transform(N2g, 
                    one = sapply(string2,"[[",1),   
                    two = sapply(string2,"[[",2))
N2g <- data.frame(word1 = N2g$one,word2 = N2g$two,freq = N2g$freq,stringsAsFactors=FALSE)

## saving files 
write.csv(N2g[N2g$freq > 1,],"N2g.csv",row.names=F)
N2g <- read.csv("N2g.csv",stringsAsFactors = F)
saveRDS(N2g,"N2g.RData")


#########################
#Tri-Gram
#########################


# Tokenizer function to get Tri-gram
N3g <- NGramTokenizer(cleanedcorpus, Weka_control(min = 3, max = 3,delimiters = " \\r\\n\\t.,;:\"()?!"))
N3g <- data.frame(table(N3g))
N3g <- N3g[order(N3g$Freq,decreasing = TRUE),]
names(N3g) <- c("words","freq")
head(N3g)
##################### 
N3g$words <- as.character(N3g$words)
String3 <- strsplit(N3g$words,split=" ")
N3g <- transform(N3g,
                     one = sapply(String3,"[[",1),
                     two = sapply(String3,"[[",2),
                     three = sapply(String3,"[[",3))
# N3g$words <- NULL
N3g <- data.frame(word1 = N3g$one,word2 = N3g$two, 
                      word3 = N3g$three, freq = N3g$freq,stringsAsFactors=FALSE)
# saving files
write.csv(N3g[N3g$freq > 1,],"N3g.csv",row.names=F)
N3g <- read.csv("N3g.csv",stringsAsFactors = F)
saveRDS(N3g,"N3g.RData")

########################################################
#Quad-Gram
########################################################

N4g <- NGramTokenizer(cleanedcorpus, Weka_control(min = 4, max = 4,delimiters = " \\r\\n\\t.,;:\"()?!"))
N4g <- data.frame(table(N4g))
N4g <- N4g[order(N4g$Freq,decreasing = TRUE),]

names(N4g) <- c("words","freq")
N4g$words <- as.character(N4g$words)

String4 <- strsplit(N4g$words,split=" ")
N4g <- transform(N4g,
                      one = sapply(String4,"[[",1),
                      two = sapply(String4,"[[",2),
                      three = sapply(String4,"[[",3), 
                      four = sapply(String4,"[[",4))
# N4g$words <- NULL
N4g <- data.frame(word1 = N4g$one,
                       word2 = N4g$two, 
                       word3 = N4g$three, 
                       word4 = N4g$four, 
                       freq = N4g$freq, stringsAsFactors=FALSE)
# saving files
write.csv(N4g[N4g$freq > 1,],"N4g.csv",row.names=F)
N4g <- read.csv("N4g.csv",stringsAsFactors = F)
saveRDS(N4g,"N4g.RData")
