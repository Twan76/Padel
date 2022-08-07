#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import readxl
#' @import stringr
#' @import shinythemes
#' @noRd

# Lecture fichier ville
file_map_ville  <- paste(getwd(),"/map_villes.xlsx", sep="")
villes <- suppressMessages(read_excel(file_map_ville))
villes <- as.data.frame(villes)
villes <- villes[,c(2:7)]
colnames(villes) <- c("Nom_Ville", "Code_Postal", "Code_INSEE", "Region", "Latitude", "Longitude")
villes[,5] <- as.numeric(str_replace(as.character(villes[,5]), ",","."))
villes[,6] <- as.numeric(str_replace(as.character(villes[,6]), ",","."))

# Lecture fichier tournois padel
tournois_padel  <- paste(getwd(),"/TournoisPadel.xlsx", sep="")
tournois_padel <- suppressMessages(read_excel(tournois_padel))
tournois_padel <- as.data.frame(tournois_padel)
tournois_padel[,4] <- as.Date(tournois_padel[,4],origin="1899-12-30")
tournois_padel[,5] <- as.Date(tournois_padel[,5],origin="1899-12-30")

# Jointure fichier
# Liaison entre les 2 tables pour voir si pas d'oublis
tournois <- merge(x = tournois_padel, y = villes, by.x = "Ville", by.y = "Nom_Ville", all.x = TRUE)
# Ré-agencement
keep_row_tableau <- c(2:6,1,7,10:11)
tournois <- tournois[,keep_row_tableau]

# On remplace le code postal par le département afin de créer un filtre qui pourrait nous servir pour le futur
for (i in 1:length(tournois[,1])){
  if (is.na(tournois[i,7])){
  }else{
    if (nchar(tournois[i,7])==4){
      tournois[i,7] <- paste("0",substring(tournois[i,7],1,1), sep = "")
    }else{
      tournois[i,7] <- substring(tournois[i,7],1,2)
    }
  }
}

names(tournois)[7] <- "Département"

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(title = "Padel", theme = shinytheme("flatly"),
               tabPanel(title ="A la recherche de tournois",
                        sidebarPanel(
                          dateRangeInput("date", "Date", start = min(tournois[,4]), end = max(tournois[,5]), min = min(tournois[,4]), max=as.Date(paste(substr(Sys.Date(),1,4),"-12-31",sep="")), format = "dd-mm-yyyy", language = "fr", weekstart = 1),
                          checkboxGroupInput("epreuve_padel", "Epreuve", inline=F, choices = sort(unique(tournois[,2])), selected = sort(unique(tournois[,2]))),
                          checkboxGroupInput("niveau_padel", "Niveau", inline=F, choices = c("P25", "P100", "P250", "P500", "P1000", "P2000"), selected = sort(unique(tournois[,3])))
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel('Cartographie',
                                     mod_carte_france_padel_ui("carte_france_padel_1")
                            ),
                            tabPanel('Données',
                                     mod_affichage_table_ui("affichage_table_1")
                            )
                          )
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
