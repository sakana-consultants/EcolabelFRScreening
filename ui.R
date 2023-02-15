#---- Analyse des stocks pertinents Ecolabel Pêche Durable  ----
#
# Interface Shiny - fichier ui
#
# Code written by: 
#         Sébastien Metz - Sakana Consultants
# Initial Code: August 2019
#

dashboardPage(
  dashboardHeader(
    title = "Ecolabel Pêche Durable FranceAgriMer - Analyse des données CIEM",
    titleWidth = 1000
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Vue globale", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Stock particulier", tabName = "stock", icon = icon("bar-chart")),
      menuItem("Référentiel", tabName = "referentiel", icon = icon("th"))
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
        .skin-blue .main-header .logo {
                              background-color: #3c8dbc;
                              }
                              .skin-blue .main-header .logo:hover {
                              background-color: #3c8dbc;
                              }
                              ')
                         )
              ),
    tabItems(
      # First tab content
      tabItem(
        tabName = "dashboard",
        h2("Vue globale - Notation d'après évaluations CIEM"),
        fluidRow(
          column(12,
                 p("Clé: position dans le diagramme de Kobe: 
                   0: absent - 1: rouge - 2: jaune - 3: orange - 4: vert"),
                 tableOutput("tabKobe")
          
          # box(title = "Index de Kobe",
          #     width = 12,
          #     status = "primary",
          #     solidHeader = TRUE,
          #     
          )
        )
      ),
      tabItem(
        tabName = "stock",
        h2("Stock particulier"),
        fluidRow(
          box(title = "Inputs",
              width = 12,
              status = "warning",
              solidHeader = TRUE,
              selectizeInput(
                inputId = "stockID",
                label = "Stock",
                choices = (stockMenu),
                selected = "Sélectionner un Stock",
                multiple = TRUE,
                options = list(maxItems = 1, placeholder = 'sélectionner un stock'),
                width = '300px')
               )
        ),
        fluidRow(
          box(title = "Evolution de la biomasse",
              width = 4,
              status = "primary",
              solidHeader = TRUE,
              plotOutput("gr_B", 
                         click = "biomasse_click")
          ),
          box(title = "Diagramme de Kobe",
              width = 4,
              solidHeader = TRUE,
              status = "primary",
              plotOutput("gr_K", 
                         click = "mortalite_click")
          ),
          box(title = "Evolution de la mortalité",
              width = 4,
              solidHeader = TRUE,
              status = "primary",
              plotOutput("gr_F", 
                         click = "mortalite_click")
          )
        ),
        fluidRow(
          box(title = "Evolution des débarquements",
              width = 4,
              status = "primary",
              solidHeader = TRUE,
              plotOutput("gr_Land", 
                         click = "catch_click")
          ),
          box(title = "Evolution des rejets",
              width = 4,
              solidHeader = TRUE,
              status = "primary",
              plotOutput("gr_R", 
                         click = "mortalite_click")
          )
        )
      ),
      tabItem(
        tabName = "referentiel",
        h2("Rappel sur le référentiel"),
        fluidRow(
          column(
            width = 6,
            box(
              title = titlePR1,
              width = NULL,
              status = "primary",
              p(uiOutput("textePR1"))
            ),
            box(
              title = "PR2 : Il existe un cadre de gestion international permettant de maintenir dans les limites de précaution le stock concerné par la demande d’écolabellisation.",
              width = NULL, status = "primary",
              p(
                "La plupart des stocks étant partagés entre les zones économiques exclusives (ZEE) de plusieurs Etats côtiers et les eaux internationales, la robustesse du système de gestion international du stock est un facteur de garantie que le stock concerné ne passe pas au- dessous du seuil de précaution, et donc que le respect de l'exigence fixée au PR1 ci-dessus soit maintenu.",
                br(), br(),
                "Pour que le stock soit éligible à une demande de labellisation, il doit exister au minimum un système de régulation de l’accès par des licences et/ou un système de suivi et de gestion des quantités capturables ou de l’effort de pêche autorisé."
              )
            )
          ),
          column(
            width =6,
            box(
              width = NULL, status = "primary",
              title = "PR3", 
              p(
              )
            ),
            box(
              title = "PR4", width = NULL, status = "primary",
              p(
                "Ce prérequis sera contrôlé par l’auditeur de la même manière que le prérequis 1, c'est-à-dire en considérant la déclinaison 1 ou la déclinaison 2 selon le niveau de connaissance du stock.", 
                br(), br(),
                "Le(s) espèce(s) non commercialisée(s) dont la population est impactée ne doi(ven)t être :", 
                br(),
                "- ni dans la liste rouge régionale et mondiale de l'UICN en catégorie En danger critique (CR), En danger (EN) ou Vulnérable (VU) ;", 
                br(),
                "- ni dans les annexes de la CITES en tant qu'espèce(s) interdite(s) à la commercialisation (annexe I)", 
                br(),
                "- ni dans la liste du CIEM des espèces indicatrices d’écosystèmes marins vulnérables (EMV) - ni dans les conventions nationales, régionales ou internationales (ex : la convention OSPAR)"
              )
            )
          )
        )
      )
    )
  )
)