library(mongolite)
library(tidyverse)
library(yaml) 
library(ggplot2)
library(dplyr)

setwd("C:/Users/Ga/Documents/GitHub/jobio_grp3")
# setwd("/home/formateur/Documents/GitHub/jobio_grp3")
yml <- yaml.load_file("config.yml")

user = yml$poleEmp$user
password = yml$poleEmp$psswd
bdd = yml$poleEmp$bdd

myco <- mongo("offres", url=paste("mongodb://",user,":",password,"@127.0.0.1/",bdd,"?authSource=admin",sep =""))

#--------------------------- Bar chart types de contrats

contrat = myco$aggregate('[{"$project": {"_id" :0, "typeContrat": 1}},{"$group" : {"_id":"$typeContrat", "nbContrats" : {"$sum" : 1}}}]')

#On renomme la colonne _id
names(contrat)[1] = "nomContrat"

#barplot contrats
p<-ggplot(data=contrat, aes(x=nomContrat, y=nbContrats, fill = nomContrat)) +
  geom_bar(stat = "identity", width = 0.8)+
  geom_text(aes(label=nbContrats), vjust=-0.3, size=3.5)+
  theme_minimal()
p

#--------------------------- Pie chart expérience demandée sur les offres

exp = myco$aggregate('[{"$project": {"_id" :0, "experienceExige": 1}},{"$group" : {"_id":"$experienceExige", "nbExpExigee" : {"$sum" : 1}}}]')
names(exp)[1] = "expExigee"
exp$expExigee = c('Expérience souhaitée', 'Débutants acceptés', 'Expérience exigée')

bp<- ggplot(exp, aes(x="", y=nbExpExigee, fill=expExigee))+
  geom_bar(width = 1, stat = "identity")
pie <- bp + coord_polar("y", start=0)
pie <- ggplot(exp, aes(x="", y=nbExpExigee, fill=expExigee)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

# 100 * exp$nb / expTotal

expPer <- exp %>%
  mutate(expExigee = factor(expExigee, 
                       levels = expExigee[length(expExigee):1]),
         cumulative = cumsum(nbExpExigee),
         midpoint = cumulative - nbExpExigee / 2,
         labels = paste0(round((nbExpExigee/ sum(nbExpExigee)) * 100, 1), "%"))

camembertContrat = ggplot(expPer, aes(x = "", y = nbExpExigee, fill = expExigee)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y", start = 0) +
  labs(x = "", y = "", title = "Répartition expérience demandée \n",
       fill = "Légende") + 
  geom_text(aes(x = 1.2, y = midpoint , label = labels), color="black",
            fontface = "bold") + blank_theme +
  scale_fill_brewer(palette="Blues")+
  theme(axis.text.x=element_blank()) 

# ------------------------- KPI % d'offres où le salaire n'est pas indiqué

salaire = myco$aggregate('[{"$addFields": {"salaireLib": "$salaire.libelle"}},{"$project": {"_id" :0, "salaireLib": 1}},{"$group" : {"_id":"$salaireLib", "groupe" : {"$sum" : 1}}}]')

names(salaire)[1] = "salaire"
names(salaire)[2] = "nbSal"

salaire2 = myco$aggregate('[{"$addFields": {"salaireLib": "$salaire.libelle"}},{"$project": {"_id" :0, "salaireLib": 1} }]')

nbOffres = sum(salaire$nbSal) # nombre total d'offres

indexNA = which(is.na(salaire$salaire)) # On cherche l'index du décompte de valeurs nulles
noSalaire = salaire$nbSal[indexNA] # Total des offres dont le salaire n'est pas renseigné
perNoSal = round((100 * noSalaire / nbOffres), digits = 0) # Pourcentage

# salaireOK = sum(salaire$nbSal) - noSalaire Offres dont le salaire est indiqué
