library(mongolite)
library(tidyverse)
library(yaml) 
library(ggplot2)

setwd("C:/Users/Ga/Documents/GitHub/jobio_grp3")
yml <- yaml.load_file("config.yml")

user = yml$poleEmp$user
password = yml$poleEmp$psswd
bdd = yml$poleEmp$bdd

myco <- mongo("offres", url=paste("mongodb://",user,":",password,"@127.0.0.1/",bdd,"?authSource=admin",sep =""))

#df avec tous les contrats
contrat = myco$aggregate('[{"$project": {"_id" :0, "natureContrat": 1} }]')

#group by natureContrat
contrat2 = myco$aggregate('[{"$project": {"_id" :0, "natureContrat": 1}},{"$group" : {"_id":"$natureContrat", "nbContrats" : {"$sum" : 1}}}]')

names(contrat2)[1] = "nomContrat"

p<-ggplot(data=contrat2, aes(x=nomContrat, y=nbContrats)) +
  geom_bar(stat = "identity", width = 0.5)
p
