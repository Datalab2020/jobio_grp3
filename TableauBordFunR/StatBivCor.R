source("LibrairieIdf.R")

#Correlation,Cluster, diagramme boite
dfgb = data.frame(mongo_db2$aggregate('[{"$addFields": {"idb": {"$ifNull": ["$thread_id", "$id"]}}}, {"$group": {"_id": "$idb","compteur": {"$sum": "$votes.count"}}}]'))
dfgbb =data.frame(mongo_db2$aggregate('[{"$match": {"comments_count":{ "$ne":null}}}, {"$project": {"id": 1,"comments_count":1}}]'))
dfgbb = dfgbb[,-1]
rename(dfgb,"id"="X_id")
biv = inner_join(dfgbb,dfgb,by = c("id"="X_id"))
bivr = biv[,-1]

#Matrice de Corrélation
corl = ggcorrplot(cor(bivr),lab = TRUE )

#Clustering
ratio_ss <- data.frame(cluster = seq(from = 1, to = 9, by = 1)) 
for (k in 1:9) {
  km_model <- kmeans(bivr, k, nstart = 20)
  ratio_ss$ratio[k] <- km_model$tot.withinss / km_model$totss
}

ggplot(ratio_ss, aes(cluster, ratio)) + geom_line() +geom_point()+scale_x_discrete(limits= as.numeric(c(1:10)))+labs(title ="Graphe représentant l'inertie en fonction du nombre de clusters de fil de discussions",x = "Nombre de cluster", y = "Inertie")

km_model <- bivr %>% 
  kmeans(centers = 3, nstart=20)
bivr$cluster <- km_model$cluster
bivrf = mutate(biv, NumeroCluster = bivr$cluster)
titre = data.frame(mongo_db2$aggregate('[{"$match": {"title":{ "$ne":null}}}, {"$project": {"title":1}}]'))
titre = titre[,-1]
filetbiv = cbind(titre,bivrf)
extraitTabClt = head(filetbiv, 10)

plotct = ggplot(bivr, aes(comments_count, compteur, col = factor(cluster), text = filetbiv$titre)) + geom_point(size = 2, alpha = 0.8, position = "jitter")+labs(title ="Graphe du clustering pour les fils de discussions",x = "Nombre de méssages par fil", y = "Nombre de Votes")+scale_x_discrete(limits= as.numeric(c(1:27)))
ggplotly(plotct)

#Etude statistique univariée sur le nombre de message par fil (comments_counts)
filetbiv$comments_count=as.integer(filetbiv$comments_count)
resume1 = basicStats(filetbiv$comments_count)%>%rename(Résumé_statistique = X..filetbiv.comments_count)%>%slice(3:8)

univ1=ggplot(filetbiv) +aes(x = "", y = comments_count) +geom_boxplot(fill = "#0c4c8a", col = "red") +labs(title = "Diagramme en boite représentant le nombre de messages postés par fil")+theme_bw()

sum(filetbiv$comments_count)

#Etude statistique univariée sur le nombre de votes totaux pas fil (compteur)
filetbiv$compteur=as.integer(filetbiv$compteur)
resume2 = basicStats(filetbiv$compteur)%>%rename(Résumé_statistique = X..filetbiv.compteur)%>%slice(3:8)

univ2=ggplot(filetbiv) +aes(x = "", y = compteur) +geom_boxplot(fill = "#0c4c8a", col = "red") +labs(title = "Diagramme en boite représentant le nombre de votes totaux postés par fil")+theme_bw()

sum(filetbiv$compteur)





