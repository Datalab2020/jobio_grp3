source("LibrairieIdf.R")

#Table interractive
rech =datatable(as.data.table(mongo_db1$find(fields = '{"_id": 0,"content.title":1,"content.created_at":1, "content.thread_type":1,"content.endorsed":1}')))
