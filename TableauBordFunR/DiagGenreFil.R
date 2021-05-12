source("LibrairieIdf.R")

#Graphe représentant les genres de fil discussion
mongo_db1$count()
proppost <- mongo_db1$aggregate('[{"$group": {"_id":"$content.thread_type","N": {"$sum": 1 } } }]')
colnames(proppost) <- c("type_post","quantité")
x <- colSums(proppost[-1])
proppost <- mutate(proppost, pourcentage = quantité*100/x)

grphproppost=ggplot(proppost) +
  aes(x = `type_post`) +
  geom_bar(aes(weight=pourcentage), fill = c("darkred","darkgreen"), size =20) +
  theme(legend.position="none",axis.text = element_text(size = 16), axis.title.x = element_blank(),axis.title.y = element_blank(),plot.title = element_text(size = 25)) + xlab("Type de post") +ylab("Pourcentage")+ggtitle("Nombre de messages postés")

 