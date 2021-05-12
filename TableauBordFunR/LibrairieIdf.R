library(tidyverse)
library(mongolite)
library(fBasics)
library(DT)
library(data.table)
library(plotly)
library(ggcorrplot)
source("IdentifiantServeur.R") #Changer le fichier contenant les identifants de connexion au serveur datalab

#Connexion dans la bdd de mongodb voulu après avoir effectué la connexion ssh avec le port 27017 et la connexion à mongodb depuis le terminal
url_path = paste("mongodb://",user,":",password,"@127.0.0.1:27017/admin",sep = "")
mongo_db1 <- mongo(collection = "dataForum",db = "bdd_grp2",url = url_path,verbose = TRUE)
mongo_db2 <- mongo(collection = "dataForumMisePlatTot",db = "bdd_grp2",url = url_path,verbose = TRUE)

