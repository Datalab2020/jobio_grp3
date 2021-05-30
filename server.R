source("graphs_jobs_final.R", encoding = "UTF-8")
source("jobio_requetes.R", encoding = "UTF-8")
source("wordcloud2.R", encoding = "UTF-8")


server <- function(input, output) { 
                                    output$plot1 = renderPlot(p)
                                    output$plot2 = renderPlot(camembertContrat)
                                    output$carte1 = renderLeaflet(map1)
                                    output$carte2 = renderLeaflet(map2)
                                    output$wc2 = renderWordcloud2({wc2})
                                    output$barplot=renderPlot(plotWords)
                                    output$plot5=renderPlot(b)

                                    # 
                                    # output$image = renderImage({list(src = "/home/maison/ProjetLangageInformatique/RProjects/ProjetFunR/www/wordcloud.png", width = 1200)}, deleteFile = FALSE)
                                    # output$image2 = renderImage({list(src = "/home/maison/ProjetLangageInformatique/RProjects/ProjetFunR/www/mostCommonWords.png", width = 1200)}, deleteFile = FALSE)
                                    # output$image3 = renderImage({list(src = "/home/maison/ProjetLangageInformatique/RProjects/ProjetFunR/www/scoreSIA.png")}, deleteFile = FALSE)
                                    # output$reche=DT::renderDataTable(rech)
}


# Changer le chemin absolu des images en fonction de l'endroit où l'on position le projet R