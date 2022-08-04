#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import readxl
#' @noRd

# Lecture fichier ville
file_map_ville  <- paste(getwd(),"/map_villes.xlsx", sep="")
villes <- suppressMessages(read_excel(file_map_ville))
villes <- as.data.frame(villes)
villes <- villes[,c(2:7)]
colnames(villes) <- c("Nom_Ville", "Code_Postal", "Code_INSEE", "Region", "Latitude", "Longitude")

# Lecture fichier tournois padel
tournois_padel  <- paste(getwd(),"/TournoisPadel.xlsx", sep="")
tournois <- suppressMessages(read_excel(tournois_padel))
tournois <- as.data.frame(tournois)
tournois[,4] <- as.Date(tournois[,4],origin="1899-12-30")
tournois[,5] <- as.Date(tournois[,5],origin="1899-12-30")

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(title = "Tournois Padel Tennis",
               tabPanel(icon = icon("child"), 'Accompagnement',
                        sidebarPanel(
                          # Filtrage avec les dates
                          dateRangeInput("date", "Date", start = min(tournois[,4]), end = max(tournois[,5]) , min = min(tournois[,4]) , max=max(tournois[,5]) , format = "dd-mm-yyyy", language = "fr", weekstart = 1),
                          
                          # Type d'epreuve
                          checkboxGroupInput("epreuve_padel", "Type Epreuve", inline=F, sort(unique(tournois[,2])), sort(unique(tournois[,2]))),
                          
                          # Niveau
                          checkboxGroupInput("niveau_padel", "Niveau", inline=F, choices = c("P25", "P100","P250", "P500", "P1000","P2000"), selected = c("P25", "P100","P250", "P500", "P1000","P2000"))
                        ),
                        mainPanel(
                          mod_affichage_table_ui("affichage_table_1")
                        )
               )
    )
    
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "Padel"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
