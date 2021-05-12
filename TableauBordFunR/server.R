source("StatBivCor.R")
source("MoteurRecherche.R")
source("PersMesPost.R")
source("DiagCirc.R")
source("MesFctTemps.R")
source("DiagGenreFil.R")



server <- function(input, output) { output$plot1 = renderPlot(evoltp)
                                    output$plot2 = renderPlot(barplot(df1gg$Nombre_de_personne,names.arg = df1gg$Nombre_de_message_posté, xlab = "Nombre de messages postés" , ylab = "nombre de personnes", axis.lty = 15, col = "blue", cex.lab=1.5, cex.axis=0.75)+ title("Nombre de personnes en fonction du nombre de messages postés",cex.main=2, font.main = 1))
                                    output$plot3 = renderPlot(grphproppost)
                                    output$plot4 = renderPlot(camembert)
                                    output$tb1 = renderTable(datenbpost)
                                    output$df1gg = renderTable(df1gg)
                                    output$top10pp = renderTable(top10pp)
                                    output$proppost = renderTable(proppost)
                                    output$dfm = renderTable(dfm)
                                    output$bx1=renderPlot(univ1)
                                    output$rs1=renderTable(resume1,rownames = TRUE)
                                    output$bx2=renderPlot(univ2)
                                    output$rs2=renderTable(resume2,rownames = TRUE)
                                    output$crl1=renderPlot(corl)
                                    output$extrTabClt = renderTable(extraitTabClt)
                                    output$Ins = renderPlot(ggplot(ratio_ss, aes(cluster, ratio)) + geom_line() +geom_point()+scale_x_discrete(limits= as.numeric(c(1:10)))+labs(title ="Graphe représentant l'inertie en fonction du nombre de clusters de fil de discussions",x = "Nombre de cluster", y = "Inertie"))
                                    output$clt = renderPlotly(ggplotly(plotct))
                                    output$image = renderImage({list(src = "/home/maison/ProjetLangageInformatique/RProjects/ProjetFunR/www/wordcloud.png", width = 1200)}, deleteFile = FALSE)
                                    output$image2 = renderImage({list(src = "/home/maison/ProjetLangageInformatique/RProjects/ProjetFunR/www/mostCommonWords.png", width = 1200)}, deleteFile = FALSE)
                                    output$image3 = renderImage({list(src = "/home/maison/ProjetLangageInformatique/RProjects/ProjetFunR/www/scoreSIA.png")}, deleteFile = FALSE)
                                    output$reche=DT::renderDataTable(rech)
}


# Changer le chemin absolu des images en fonction de l'endroit où l'on position le projet R