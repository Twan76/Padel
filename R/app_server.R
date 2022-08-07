#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # # Your application server logic
  r_global <- reactiveValues()
  r_global$dataset <- reactive({
    # Attribue TRUE si l'option sélectionnée correspond, FALSE sinon
    match_epreuve <- (match(tournois[,2],input$epreuve_padel, nomatch=FALSE) > 0)
    match_niveau <- (match(tournois[,3],input$niveau_padel, nomatch=FALSE) > 0)
    match_date <- ((input$date[1] <= tournois[,4]) & (tournois[,4] <= input$date[2])) | ((input$date[1] <= tournois[,5]) & (tournois[,5] <= input$date[2]))
    # Recupère uniquement les lignes qui satisfont les options sélectionnées
    intersec_option <- (match_epreuve == TRUE & match_niveau == TRUE & match_date == TRUE)
    tournois[intersec_option,]
  })
  
  mod_carte_france_padel_server("carte_france_padel_1", r_global = r_global)
  mod_affichage_table_server("affichage_table_1", r_global = r_global)
}
