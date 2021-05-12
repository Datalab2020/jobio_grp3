source("LibrairieIdf.R")

#Graphe message en fonction temps
df_data = mongo_db1$aggregate('[{"$group": {"_id": "$content.created_at"}}]')
df2 = data.frame(df_data)
df2 = df2 %>%mutate(new_date = format(as.Date(X_id),"%Y-%m"), heure = hour(as.Date(X_id)))

evoltp = df2 %>%
  group_by(new_date ) %>%
  count() %>%
  ggplot(aes(x=new_date, y=n, group= 1, color= "red")) + 
  geom_line(arrow = arrow(), size = 2) +
  xlab("Temps") + 
  ylab("Nombre de messages")+
  labs(fill = "Progression des message")+
  theme(legend.position = "none",axis.text.x = element_text(size = 16),axis.text.y = element_text(size = 16), axis.title.x = element_text(size = 16),axis.title.y = element_text(size = 16),plot.title = element_text(size = 25))+ggtitle("Nombre de messages postés")

datenbpost = df2 %>%group_by(new_date ) %>%count()%>%rename(date = new_date, nombre_messages_postés = n)

