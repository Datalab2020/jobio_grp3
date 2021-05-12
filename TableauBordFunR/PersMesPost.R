source("LibrairieIdf.R")

#Diagramme en barre
df1er = data.frame(mongo_db1$aggregate('[{"$unwind": {"path": "$content.endorsed_responses"}}, {"$group": {"_id": "$content.endorsed_responses.username","Compteur": {"$sum": 1}}}]'))
df1ner = data.frame(mongo_db1$aggregate('[{"$unwind": {"path": "$content.non_endorsed_responses"}}, {"$group": {"_id": "$content.non_endorsed_responses.username","Compteur": {"$sum": 1}}}]'))
df1c = data.frame(mongo_db1$aggregate('[{"$unwind": {"path": "$content.children"}}, {"$group": {"_id": "$content.children.username","Compteur": {"$sum": 1}}}]'))
df1 = bind_rows (df1er,df1ner,df1c)
df1g = df1%>%group_by(X_id)%>%summarise(Nombre_de_message_posté = sum(Compteur))%>%arrange(desc(Nombre_de_message_posté))%>%rename( Pseudonyme=X_id )
df1gg = df1g%>%group_by(Nombre_de_message_posté)%>%count (length(Pseudonyme))%>%rename(Nombre_de_personne = n)
df1gg = select(df1gg,1,3)

barplot(df1gg$Nombre_de_personne, names.arg = df1gg$Nombre_de_message_posté, xlab = "Nombre de messages postés" , ylab = "nombre de personnes", axis.lty = 15, col = "blue", cex.lab=1.5, cex.axis=0.75)+ title("Nombre de personnes en fonction du nombre de messages postés",cex.main=2, font.main = 1)

tot1 = length(df1g$Pseudonyme)
tot2 = sum(df1g$Nombre_de_message_posté)
top10pp =head(df1g,10)

