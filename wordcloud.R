library(mongolite)
library(tidyverse)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
#source("config.R")

user = 'scantonnet'
password = 'd}#2uyKYL}4e'

myco <- mongo("PE_grp3", url=paste("mongodb://",user,":",password,"@127.0.0.1/Datalab2020?authSource=admin",sep =""))

# test = myco$find(limit = 1)
# 
# test2 = myco$find(fields = '{"description":1}')
# 
# test2 <- sapply(myco$iterate()$batch(),
#        function (e) {
#          return(c(descr = e$description, libelle = e$appellationlibelle))
#        })

test3 = myco$aggregate('[{"$project": {"_id" :0, "description": 1} }]')
text =  paste(test3, collapse='')

docs <- Corpus(VectorSource(text))
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convertir le texte en minuscule
docs <- tm_map(docs, content_transformer(tolower))
# Supprimer les nombres
docs <- tm_map(docs, removeNumbers)
# Supprimer les mots vides anglais
docs <- tm_map(docs, removeWords, stopwords("french"))
# Supprimer votre propre liste de mots non désirés
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
# Supprimer les ponctuations
docs <- tm_map(docs, removePunctuation)
# Supprimer les espaces vides supplémentaires
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)