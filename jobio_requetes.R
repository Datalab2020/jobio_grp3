library(mongolite)
library(ggplot2)
library(wesanderson)
library(lubridate)
library(jsonlite)
library(dplyr)
library(packcircles)
library(corrplot)
library(treemapify)
library(tidyverse)
library(splitstackshape)
library(leaflet)
library(gapminder)
library(stringr)
library(stringi)
library(leaflet.extras)
library(purrr)
library(inlmisc)


myco=mongo("offres", url = "mongodb://cmatto:%28cCo%27NR8.%227xx@127.0.0.1/bdd_projet9_secf?authSource=admin") #changer code pour cacher apparition mot de passe 

###-----------------------------------------------------------NB JOB
#Aggregation nombre job
cartejob = myco$aggregate('[{
    "$addFields": {
        "latitude": "$lieuTravail.latitude",
        "longitude": "$lieuTravail.longitude",
        "dep_ville": "$lieuTravail.libelle"
    }
}, {
    "$project": {
        "appellationlibelle": 1,
        "dateActualisation": 1,
        "id": 1,
        "intitule": 1,
        "typeContrat": 1,
        "latitude": 1,
        "longitude":1,
        "dep_ville":1
    }
}]')


#Extraire le nombre département from departement columns
cartejob_dep =  as.data.frame(as.numeric(gsub("([0-9]+).*$", "\\1", cartejob$dep_ville)))

#Concatenation des 2 dataframes
mapjob = cbind(cartejob, cartejob_dep)

#Changer le titre de la dernière colonne
names(mapjob)[length(names(mapjob))] <- "departement"

#Groupby nombre de job par departement
map_jobdep = mapjob %>% group_by(departement, longitude, latitude) %>% summarize(nb_jobdep = n())

#Groupby nombre de contrat par departement
map_contratdep = mapjob %>% group_by(departement, typeContrat) %>% summarize(nb_contratdep = n())

#Nom des villes
nomville = as.data.frame(word(cartejob$dep_ville, start = 3, end = -1))

#Concatenation
mapville = cbind(mapjob, nomville)

#Changement nom colonne
names(mapville)[length(names(mapville))] <- "ville"

#Filtre contrat
mapvilleCDI = mapville%>%filter(mapville$typeContrat=="CDI")
mapvilleCDD = mapville%>%filter(mapville$typeContrat=="CDD")
mapvilleMIS = mapville%>%filter(mapville$typeContrat=="MIS")

###-------------------------------------------------------------SALAIRE
#Aggregation salaire
cartesalaire = myco$aggregate('[{
    "$addFields": {
        "latitude": "$lieuTravail.latitude",
        "longitude": "$lieuTravail.longitude",
        "dep_ville": "$lieuTravail.libelle",
        "salaire": "$salaire.libelle"
    }
}, {
    "$project": {
        "appellationlibelle": 1,
        "dateActualisation": 1,
        "id": 1,
        "intitule": 1,
        "typeContrat": 1,
        "latitude": 1,
        "longitude":1,
        "dep_ville":1,
         "salaire":1
    }
}]')

#Selection job avec salaire
mapsalaire= cartesalaire %>% drop_na(salaire)

mapsalairetype=cartesalaire %>% drop_na(salaire)

#Création colonne pour catégorie salaire, mensuel, annuel
mapsalaire$salaire<- ifelse(grepl("Mensuel", mapsalaire$salaire), "Mensuel", ifelse(grepl("Annuel", mapsalaire$salaire), "Annuel", ifelse(grepl("Horaire", mapsalaire$salaire), "Horaire", "NO_MONEY!"))) 


dfsalaire= cbind(mapsalairetype,mapsalaire$salaire)
names(dfsalaire)[length(names(dfsalaire))]<-"typesalaire" 


#Creation colonne avec juste salaire
chiffresalaire = as.data.frame(str_extract(string = dfsalaire$salaire, pattern = "de [0-9]+"))
names(chiffresalaire)[length(names(chiffresalaire))]<-"money" 
chiffresalaire$money<-gsub("de ","",as.character(chiffresalaire$money))
chiffresalaire=as.numeric(as.character(chiffresalaire$money))

newsalaire= cbind(dfsalaire,chiffresalaire)


#Filtre en fonction type salaire
cartehoraire = newsalaire%>%filter(newsalaire$typesalaire=="Horaire")
cartemensuel = newsalaire%>%filter(newsalaire$typesalaire=="Mensuel")
carteannuel = newsalaire%>%filter(newsalaire$typesalaire=="Annuel")


###--------------------------------------------------

# Carte leaflet nombre offres
map1=leaflet(mapville) %>%
  addTiles(group = "Esri World Imagery") %>%
  addCircleMarkers(lng = mapvilleCDD$longitude, lat = mapvilleCDD$latitude,
                   data = mapvilleCDD,
                   fillOpacity = 0.9,
                   color = "orange",
                   radius = 5,
                   popup = paste0(
                     "ville: ",
                     mapvilleCDD$ville,
                     "<br/>",
                     "departement: ",
                     mapvilleCDD$departement,
                     "<br/>",
                     "type_contrat: ",
                     mapvilleCDD$typeContrat,
                     "<br/>",
                     "Intitule:",
                     mapvilleCDD$intitule,
                     sep = ""
                   ),
                   stroke = FALSE,
                   group = "CDD"
  ) %>%
  addCircleMarkers(
    data = mapvilleCDI,lng = mapvilleCDI$longitude, lat = mapvilleCDI$latitude,
    fillOpacity = 0.9,
    color = "lightgreen",
    radius = 5,
    popup = paste0(
      "ville: ",
      mapvilleCDI$ville,
      "<br/>",
      "departement: ",
      mapvilleCDI$departement,
      "<br/>",
      "type_contrat: ",
      mapvilleCDI$typeContrat,
      "<br/>",
      "Intitule:",
      mapvilleCDI$intitule,
      sep = "" ),
    stroke = FALSE,
    group = "CDI"
  )  %>%
  addCircleMarkers(
    data = mapvilleMIS,lng = mapvilleMIS$longitude, lat = mapvilleMIS$latitude,
    fillOpacity = 0.9,
    color = "lightpink",
    radius = 5,
    popup = paste0("ville: ", mapvilleMIS$ville, "<br/>",
                   "departement: ", mapvilleMIS$departement, "<br/>",
                   "type_contrat: ", mapvilleMIS$typeContrat, "<br/>",
                   "Intitule:", mapvilleMIS$intitule,
                   "Salaire:", newsalaire$chiffresalaire, "<br/>", sep=""),
    stroke = FALSE,
    group = "MIS") %>%
  leaflet::addLayersControl(
    overlayGroups = c("CDD", "CDI","MIS"),
    options = layersControlOptions(collapsed = FALSE)
  )   %>%
  addMarkers(
    clusterOptions = markerClusterOptions()) %>%
  setView(lng = 2.0589, lat = 45.3601, zoom = 5) %>%
  leaflet.extras::addResetMapButton() %>%
  leaflet.extras::addSearchOSM()



#Carte salaire
map2=leaflet(newsalaire) %>%
  addTiles(group = "Esri World Imagery") %>%
addMarkers(
  data = cartehoraire,lng = cartehoraire$longitude, lat = cartehoraire$latitude,
  icon = list(iconUrl="https://icons.iconarchive.com/icons/grafikartes/flat-retro-modern/24/time-machine-icon.png",iconSize = c(12, 12)),
  popup = paste0("ville: ", cartehoraire$dep_ville, "<br/>",
                 "type_contrat: ", cartehoraire$typeContrat, "<br/>",
                 "Intitule: ", cartehoraire$intitule, "<br/>",
                 "Salaire: ", cartehoraire$chiffresalaire, "<br/>",
                 sep=""),
  group = "Horaire") %>%
  addMarkers(
    data = cartemensuel,lng = cartemensuel$longitude, lat = cartemensuel$latitude,
    icon = list(iconUrl="https://icons.iconarchive.com/icons/emey87/trainee/32/Calender-month-icon.png",iconSize = c(12, 12)),
    popup = paste0("ville: ", cartemensuel$dep_ville, "<br/>",
                   "type_contrat: ", cartemensuel$typeContrat, "<br/>",
                   "Intitule: ", cartemensuel$intitule, "<br/>",
                   "Salaire: ", cartemensuel$chiffresalaire, "<br/>",sep=""),
    group = "Mensuel") %>%
  addMarkers(
    data = carteannuel,lng = carteannuel$longitude, lat = carteannuel$latitude,
    icon = list(iconUrl="https://icons.iconarchive.com/icons/custom-icon-design/pretty-office-11/32/cash-icon.png",iconSize = c(12, 12)),
    popup = paste0("ville: ", carteannuel$dep_ville, "<br/>",
                   "type_contrat: ", carteannuel$typeContrat, "<br/>",
                   "Intitule: ", carteannuel$intitule, "<br/>",
                   "Salaire: ", carteannuel$chiffresalaire, "<br/>",sep=""),
    group = "Annuel") %>%
  leaflet::addLayersControl(
    overlayGroups = c("Horaire", "Mensuel","Annuel"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  setView(lng = 2.0589, lat = 45.3601, zoom = 5) %>%
  leaflet.extras::addResetMapButton() %>%
  leaflet.extras::addSearchOSM()



