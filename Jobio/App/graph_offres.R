library(mongolite)
library(dplyr)

myco=mongo("offres", url = "mongodb://fdelys:*{5nw7^yLHP$a@127.0.0.1/bdd_projet9_secf?authSource=admin") 

dfOffresb <- myco$aggregate(' [ {"$group": {"_id": {"tc":"$appellationlibelle", "nc":"$intitule"}, "N": {"$sum":1}}}]')

