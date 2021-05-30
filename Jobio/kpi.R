library(mongolite)
library(dplyr)
library(ggplot2)

myco=mongo("offres", url = "mongodb://fdelys:*{5nw7^yLHP$a@127.0.0.1/bdd_projet9_secf?authSource=admin")

handi <- myco$aggregate(' [{"$project" : {"_id":0, "accessibleTH" : 1}}]')
a <- count(filter(handi, accessibleTH == TRUE ))

partn <- myco$aggregate(' [{"$addFields": {"origine": "$origineOffre.origine"}}, {"$project" : {"_id":0, "origine" : 1}}]')
poleemp <- count(filter(partn, origine == 1))
partenaire <- count(filter(partn, origine == 2))

temps <- myco$aggregate(' [{"$addFields": {"emploi": "$dureeTravailLibelleConverti"}}, {"$project" : {"_id":0, "emploi" : 1}}]')
plein <- count(filter(temps, emploi == "Temps plein"))
partiel <- count(filter(temps, emploi == "Temps partiel"))