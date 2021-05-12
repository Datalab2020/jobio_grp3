source("LibrairieIdf.R")

#Diagramme circulaire
df=data.frame((mongo_db1$find('{}','{"content.endorsed":1}')))
dfm = df%>%group_by(content)%>%count()
dfm = as.data.frame(dfm)
dfm=mutate(dfm,pourcentage =  n*100/ sum(n))
new_data = round(dfm['pourcentage'])

colorlist =  c("#FF6947", "#0BBF7D")
check = c('Non validé', 'Validé')
camembert = ggplot(new_data, aes(x = "", y = pourcentage, fill= check)) +
  geom_bar(width = 5, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes( label = paste(pourcentage,"%", sep = "")), color = "white", position = position_stack(vjust = 0.5), size = 16)+
  scale_fill_manual(values = colorlist) +theme_void()+labs(fill = "Validation ?")+theme(legend.title = element_text( size=16), legend.text = element_text( size=16),plot.title = element_text(size = 25))+ggtitle("Analyse des messages validés")
                                                                                                             