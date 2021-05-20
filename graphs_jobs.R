library(mongolite)
library(tidyverse)
library(yaml) 
library(ggplot2)

setwd("/home/formateur/Documents/GitHub/jobio_grp3")
yml <- yaml.load_file("config.yml")

user = yml$poleEmp$user
password = yml$poleEmp$psswd
bdd = yml$poleEmp$bdd

myco <- mongo("offres", url=paste("mongodb://",user,":",password,"@127.0.0.1/",bdd,"?authSource=admin",sep =""))

#df avec tous les contrats
contrat = myco$aggregate('[{"$project": {"_id" :0, "natureContrat": 1} }]')

#group by natureContrat
contrat2 = myco$aggregate('[{"$project": {"_id" :0, "natureContrat": 1}},{"$group" : {"_id":"$natureContrat", "nbContrats" : {"$sum" : 1}}}]')

barplot(contrat2, width = "natureContrat", height = "nbContrats",
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")

p<-ggplot(data=contrat2, aes(x="_id", y=nbContrats)) +
  geom_bar(stat = "identity")
p

ggplot(contrat2) + geom_bar(aes(x = "nbContrats"), fill = "darkblue", width = .5)
ggplot(rp) + geom_bar(aes(x = departement), fill = "darkblue", width = .5)
ggplot(contrat2) + geom_bar(aes(x = "_id", y = nbContrats), stat = "identity")

x = ggplot(contrat2, aes(x="_id", y=nbContrats)) + 
  geom_bar(stat = "identity", width = 0.5)
x

ggplot(contrat2) + geom_histogram(aes(x = nbContrats))
