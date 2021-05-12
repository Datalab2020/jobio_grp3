ui <- dashboardPage(
  dashboardHeader(
    title = "Tableau de bord sur le cour : APPRENDRE LE PYTHON",
    titleWidth = 900
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Résumé", icon = icon("fas fa-tasks"),tabName = "og1"),
      menuItem("Analyse Messages ",icon = icon("fas fa-clipboard"), tabName = "og2"),
      menuItem("Statistique ",icon = icon("fas fa-calculator"),  tabName = "og3"),
      menuItem("Clusters", icon = icon("fas fa-object-group"),tabName = "og4"),
      menuItem("Analyse Sentiments",icon = icon("fas fa-comment"), tabName = "og5"),
      menuItem("Moteur de recherche de fil de discussions",icon = icon("fas fa-search"), tabName = "og6")
    ), width = 300, img(src = "funmoocfp.0b96f3cb73da.png", height = 140, width = 250)
  ),
  dashboardBody(
    tabItems( 
      tabItem(tabName = "og1",
              infoBox("Nombre d'utilisateur :",tot1, icon = icon("users"), fill = TRUE, color = "green"),
              infoBox("Nombre de méssages postés totaux :", tot2, icon = icon("comments"), fill = TRUE, color = "orange"),
              infoBox("Pourcentage de fils résolus : ", paste("",new_data[2,1],"%"), icon = icon("check-square"), fill = TRUE, color = "fuchsia"),
              box(plotOutput("plot1")),
              box(plotOutput("plot2")),
              box( plotOutput("plot3")),
              box( plotOutput("plot4"))
              ),
      tabItem(tabName = "og2", 
              box(title = "Table représentant le nombre de messages postés",tableOutput("tb1"),width = 3), 
              box(title = "Table représentant le nombre de messages postés par personne",tabsetPanel(tabPanel("Résumé_graphe",tableOutput("df1gg")),tabPanel("Top_10_personne_messages_postées",tableOutput("top10pp"))),width = 4),
              box(title = "Table représentant la proportion du type de fil",tableOutput("proppost"),width = 3)
              ),
      tabItem(tabName = "og3",
              fluidRow(box(title = "Etude univariée du nombre de méssages totaux par fil",tabsetPanel(tabPanel("Diagramme_Boite",plotOutput("bx1")), tabPanel("Résumé_Statistique",tableOutput("rs1")))),
              box(title = "Etude univariée de la somme du nombre de votes par fil",tabsetPanel(tabPanel("Diagramme_Boite",plotOutput("bx2")), tabPanel("Résumé_Statistique",tableOutput("rs2"))))),
              fluidRow(box(title = "Matrice de corrélation entre le nombre total de messages et la somme de votes par fil",plotOutput("crl1"), width=4, height=475), 
              box(tableOutput("extrTabClt"), "Explication du nom des colonnes : comments_count correspond au nombres de méssages totaux par fil, compteur correspond à la somme du nombre de votes par fil",width =6 , height = 450))),
      tabItem(tabName = "og4",
              box(plotOutput("Ins"), width=8, height=450),
              box(plotlyOutput("clt"), width=8, height=450)
              ),
      tabItem(tabName = "og5",
              tabsetPanel(tabPanel("WordCloud",imageOutput('image')), 
              tabPanel("Occurrence_mots",imageOutput('image2')), 
              tabPanel("Sentiment_analysis", imageOutput('image3')))),
      tabItem(tabName = "og6",
              box(title = "Moteur de recherche de fils de discussions", dataTableOutput('reche'),width = 10))
      
    )
  ),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"))
)