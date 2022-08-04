#' affichage_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom DT DTOutput renderDT datatable
mod_affichage_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    DTOutput(ns("tournois_padel_details"))
  )
}
    
#' affichage_table Server Functions
#'
#' @noRd 
mod_affichage_table_server <- function(id, r_global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$tournois_padel_details <- renderDT({
      # dataset <- datasetInput_TournoisPadel()
      datatable(r_global$dataset(),filter="top", class = 'cell-border stripe', rownames = F)
    })
    
  })
}
    
## To be copied in the UI
# mod_affichage_table_ui("affichage_table_1")
    
## To be copied in the server
# mod_affichage_table_server("affichage_table_1")
