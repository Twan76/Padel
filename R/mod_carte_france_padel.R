#' carte_france_padel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import leaflet leaflet
#' @importFrom dplyr %>%
#' 

# ICON POUR LES VILLES DES EMPLOYES
icon_logo_padel <- makeIcon(iconUrl=paste(getwd(),"/inst/app/www/raquette_padel.png", sep=""), iconWidth = 30, iconHeight = 30,
                            iconAnchorX = 10, iconAnchorY = 10)

icon_logo <- awesomeIcons(
  icon = 'table-tennis-paddle-ball',
  iconColor = 'black',
  library = 'fa',
  markerColor = "blue"
)

mod_carte_france_padel_ui <- function(id){
  ns <- NS(id)
  tagList(
          leafletOutput(ns("map_padel"))
  )
}
    
#' carte_france_padel Server Functions
#'
#' @noRd
mod_carte_france_padel_server <- function(id, r_global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$map_padel <- renderLeaflet({
      
      # Si pas de CD selectionne dans le portefeuille actuel
      if (length(r_global$dataset())==0){
        
        m <- leaflet(options = leafletOptions(minZoom = 6, maxZoom = 16))  %>% addProviderTiles("OpenStreetMap.France") %>% setView(lng = 2.333333, lat = 46.866667, zoom = 6)
        m %>%
          
          addMeasure(position = "bottomleft",
                     primaryLengthUnit = "meters",
                     primaryAreaUnit = "sqmeters",
                     activeColor = "grey",
                     completedColor = "grey", localization = "fr")
        
      }
      
      else{
        
        # DATA FRAME POUR AFFICHER LES VILLES DES EMPLOYES
        df <- data.frame(ville = r_global$dataset()[,6],
                         LNG = r_global$dataset()[,9],
                         LAT = r_global$dataset()[,8],
                         Epreuve = r_global$dataset()[,2],
                         Niveau = r_global$dataset()[,3],
                         Debut = r_global$dataset()[,4],
                         Fin = r_global$dataset()[,5],
                         stringsAsFactors = F)
        
        # AFFICHAGE SUR LA CARTE
        m <- leaflet(options = leafletOptions(minZoom = 6, maxZoom = 16)) %>% addProviderTiles("OpenStreetMap.France") %>% setView(lng = 2.333333, lat = 46.866667, zoom = 6)
        
        m %>%
          
          addAwesomeMarkers(lng=df$LNG, lat=df$LAT, icon=icon_logo,
                     popup=paste("<b> Ville : </b>", df$ville, " <br/> <b> Niveau : </b>", df$Niveau, " <br/> <b> Epreuve : </b>", df$Epreuve, " <br/> Du ", format(df$Debut, "%d/%m/%Y"), " au ", format(df$Fin, "%d/%m/%Y"), sep = ""),
                     clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE, zoomToBoundsOnClick = TRUE,
                                                           spiderfyOnMaxZoom = TRUE, removeOutsideVisibleBounds = TRUE, color = "#000")) %>%
          
          addMeasure(position = "bottomleft",
                     primaryLengthUnit = "meters",
                     primaryAreaUnit = "sqmeters",
                     activeColor = "grey",
                     completedColor = "grey", localization = "fr")
        
      }
      
    })

  })
}


# ## To be copied in the UI
# mod_carte_france_padel_ui("carte_france_padel_1")
#     
# ## To be copied in the server
# # mod_carte_france_padel_server("carte_france_padel_1")
