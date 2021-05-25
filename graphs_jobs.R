library(mongolite)
library(tidyverse)
library(yaml) 
library(ggplot2)

# setwd("C:/Users/Ga/Documents/GitHub/jobio_grp3")
setwd("/home/formateur/Documents/GitHub/jobio_grp3")
yml <- yaml.load_file("config.yml")

user = yml$poleEmp$user
password = yml$poleEmp$psswd
bdd = yml$poleEmp$bdd

myco <- mongo("offres", url=paste("mongodb://",user,":",password,"@127.0.0.1/",bdd,"?authSource=admin",sep =""))

#df avec tous les contrats
contrat = myco$aggregate('[{"$project": {"_id" :0, "typeContrat": 1} }]')

#group by natureContrat
contrat2 = myco$aggregate('[{"$project": {"_id" :0, "typeContrat": 1}},{"$group" : {"_id":"$typeContrat", "nbContrats" : {"$sum" : 1}}}]')

#On renomme la colonne _id
names(contrat2)[1] = "nomContrat"

p<-ggplot(data=contrat2, aes(x=nomContrat, y=nbContrats)) +
  geom_bar(stat = "identity", width = 0.5)
p

# -------------------

# exp = myco$aggregate('[{"$project": {"_id" :0, "experienceLibelle": 1} }]')
# exp2 = myco$aggregate('[{"$project": {"_id" :0, "experienceLibelle": 1}},{"$group" : {"_id":"$experienceLibelle", "expExigee" : {"$sum" : 1}}}]')
exp3 = myco$aggregate('[{"$project": {"_id" :0, "experienceExige": 1} }]')
exp4 = myco$aggregate('[{"$project": {"_id" :0, "experienceExige": 1}},{"$group" : {"_id":"$experienceExige", "nbExpExigee" : {"$sum" : 1}}}]')
names(exp4)[1] = "expExigee"
exp4$expExigee = c('Expérience souhaitée', 'Débutants acceptés', 'Expérience exigée')

#--------------------

salaire = myco$aggregate('[{"$addFields": {"salaireLib": "$salaire.libelle"}},{"$project": {"_id" :0, "salaireLib": 1} }]')
salaire2 = myco$aggregate('[{"$addFields": {"salaireLib": "$salaire.libelle"}},{"$project": {"_id" :0, "salaireLib": 1}},{"$group" : {"_id":"$salaireLib", "groupe" : {"$sum" : 1}}}]')
