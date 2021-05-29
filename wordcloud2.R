library(mongolite)
library(tidyverse)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library(yaml)
library(wordcloud2)

# setwd("/home/formateur/Documents/GitHub/jobio_grp3")
setwd("C:/Users/Ga/Documents/GitHub/jobio_grp3")
yml <- yaml.load_file("config.yml")

user = yml$poleEmp$user
password = yml$poleEmp$psswd
bdd = yml$poleEmp$bdd

myco <- mongo("offres", url=paste("mongodb://",user,":",password,"@127.0.0.1/",bdd,"?authSource=admin",sep =""))

descr = myco$aggregate('[{"$project": {"_id" :0, "description": 1} }]')

for (word in descr){
  text = paste(word)
}

docs <- VCorpus(VectorSource(text))
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "\n")
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

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
d[order(d$freq),]
# head(d, 10)

set.seed(1234)
# wordcloudDash = wordcloud(words = d$word, freq = d$freq, min.freq = 20,
#           max.words=500, random.order=FALSE, rot.per=0.35, 
#           colors=brewer.pal(8, "YlOrRd"))
wc2 = wordcloud2(data = d, color = "random-dark", shape = 'circle')

# plotWords = barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
#         col ="lightblue", main ="Mots les plus fréquents",
#         ylab = "Word frequencies")

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

plotWords = ggplot(data=head(d,10), aes(x=reorder(word,-freq), y=freq)) +
  geom_bar(stat = "identity", width = 0.8) +
  blank_theme
