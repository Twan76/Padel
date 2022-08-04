#' carte_france_padel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom leaflet renderLeaflet leafletOutput

mod_carte_france_padel_ui <- function(id){
  ns <- NS(id)
  tagList(
          # column(4,selectInput("fond_carte_padel", label = h5("Fond de carte"), choices = names(providers), selected = names(providers)[1], multiple = F)),
          leafletOutput("Map_Padel")
  )
}
    
#' carte_france_padel Server Functions
#'
#' @noRd 
mod_carte_france_padel_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}

# # MAP PORTEFEUILLE LEAFLET
# output$Map_Padel <- renderLeaflet({
#   
#   dataset <- datasetInput_Portefeuille()
#   
#   doublon <- which(duplicated(dataset[,c(1:3)]))
#   if(length(doublon)>0){
#     dataset <- dataset[-doublon,]
#   }
#   
#   # Si pas de CD selectionne dans le portefeuille actuel
#   if (length(dataset[,1])==0){
#     
#     m <- leaflet(options = leafletOptions(minZoom = 6, maxZoom = 16)) %>% addProviderTiles(input$fond_carte_portefeuille) %>% setView(lng = 2.333333, lat = 46.866667, zoom = 6)
#     m %>%
#       
#       addMeasure(position = "bottomleft",
#                  primaryLengthUnit = "meters",
#                  primaryAreaUnit = "sqmeters",
#                  activeColor = "grey",
#                  completedColor = "grey", localization = "fr")
#     
#   }
#   
#   else{
#     
#     # COMPTE LE NOMBRE D'EMPLOYES PAR VILLE
#     city_size <- as.data.frame(table(dataset[,10]))
#     colnames(city_size) <- c("Nom_Ville", "Nombre_Employe")
#     city_size[,1] <- as.character(city_size[,1])
#     city_size[,2] <- as.character(city_size[,2])
#     
#     ville_match <- merge(x = city_size, y = villes, by="Nom_Ville", all.x = T)
#     
#     ville_match[,6] <- as.numeric(str_replace(as.character(ville_match[,6]), ",","."))
#     ville_match[,7] <- as.numeric(str_replace(as.character(ville_match[,7]), ",","."))
#     
#     
#     # Modification des codes régions pour supprimer les homonymes hors zone géopgraphique lors de la jointure
#     for (i in 1:length(ville_match[,1])){
#       if (is.na(ville_match[i,3])){
#       }else{
#         if (nchar(ville_match[i,3])==4){
#           ville_match[i,3] <- paste("00",substring(ville_match[i,3],1,1), sep = "")
#         }
#         else if (nchar(ville_match[i,3])==5 & substr(ville_match[i,3],1,2)=="97"){
#           ville_match[i,3] <- substr(ville_match[i,3],1,3)
#         }else{
#           ville_match[i,3] <- paste("0",substring(ville_match[i,3],1,2), sep = "")
#         }
#       }
#     }
#     
#     # Filtrage des villes dans la zone géographique du CD
#     liste_regions <- unique(portefeuille[,9])
#     liste_regions <- liste_regions[!is.na(liste_regions)]
#     select_region <- ville_match[,3]%in%liste_regions
#     ville_match <- ville_match[select_region,]
#     
#     
#     # DATA FRAME POUR AFFICHER LA VILLE DU CD
#     select_ville_cd <- toupper(dataset_ville_cd[,1])%in%input$id_cd_portefeuille
#     ville_cd <- dataset_ville_cd[select_ville_cd,]
#     colnames(ville_cd) <- c("CD","Nom_Ville")
#     ville_cd_match <- merge(x = ville_cd, y = villes, by="Nom_Ville", all.x = T)
#     ville_cd_match[,6] <- as.numeric(str_replace(as.character(ville_cd_match[,6]), ",","."))
#     ville_cd_match[,7] <- as.numeric(str_replace(as.character(ville_cd_match[,7]), ",","."))
#     
#     
#     # DATA FRAME POUR AFFICHER LES VILLES DES EMPLOYES
#     df <- data.frame(ville = ville_match[,1],
#                      LNG = ville_match[,7],
#                      LAT = ville_match[,6],
#                      nombre = ville_match[,2], stringsAsFactors = F)
#     
#     
#     
#     # VERSION 2.1
#     # Faire apparaitre le taux de couverture par ville
#     
#     couverture <- dataset_Portefeuille_Couverture()
#     if(length(couverture[,1])>0){
#       doublon <- which(duplicated(couverture[,1]))
#       
#       if(length(doublon)>0){  
#         couverture <- couverture[-doublon,] 
#       } 
#       
#       df_couverture <- as.data.frame(table(couverture[,10]))
#       colnames(df_couverture) <- c("ville", "couverture")
#       df <- merge(x = df, y = df_couverture, by= "ville", all.x = T)
#       
#       df[,4] <- as.numeric(df[,4])
#       df[(is.na(df[,5])),5] <- 0
#       df[,5] <- as.numeric(df[,5])
#       
#       df <- mutate(df, pourcentage.couverture = paste(round(couverture/nombre*100, digits = 2), "%", sep = " "))
#     }
#     
#     # Faire apparaitre le nombre de salariés accompagnés et ateliers des personnes par ville
#     couverture <- dataset_Portefeuille_Couverture()
#     if(length(couverture[,1])>0){
#       
#       df_couverture_indiv <- as.data.frame(table(couverture[(couverture[,13]=="Individuel"),10]))
#       df_couverture_col <- as.data.frame(table(couverture[(couverture[,13]=="Collectif"),10]))
#       
#       colnames(df_couverture_indiv) <- c("ville", "individuel")
#       df <- merge(x = df, y = df_couverture_indiv, by= "ville", all.x = T)
#       
#       # Remplace les NA par des 0
#       if (sum(is.na(df[,7]))>0){
#         df[(is.na(df[,7])),7] <- 0
#       }
#       
#       # Cas où le CD ne fait pas d'ateliers
#       if(length(df_couverture_col[,1])>0){
#         colnames(df_couverture_col) <- c("ville", "collectif")
#         df <- merge(x = df, y = df_couverture_col, by= "ville", all.x = T)
#         if (sum(is.na(df[,8]))>0){
#           df[(is.na(df[,8])),8] <- 0
#         }
#       } else if(length(df_couverture_col[,1])==0){
#         df$collectif <- rep(0,length(df[,1]))
#       }
#     }
#     
#     # DISTANCE DEPUIS LE CD
#     km_portefeuille <- as.numeric(input$km_portefeuille)*1000
#     
#     # AFFICHAGE SUR LA CARTE
#     m <- leaflet(options = leafletOptions(minZoom = 6, maxZoom = 16)) %>% addProviderTiles(input$fond_carte_portefeuille) %>% setView(lng = 2.333333, lat = 46.866667, zoom = 6)
#     
#     m %>% 
#       
#       addMarkers(lng=df$LNG, lat=df$LAT, popup=paste("Couverture : ", df$couverture, " (", df$pourcentage.couverture, ")", " / Entretiens : ", df$individuel, " / Ateliers : ", df$collectif, sep = ""), icon = icon_logo,
#                  clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE, zoomToBoundsOnClick = TRUE,
#                                                        spiderfyOnMaxZoom = TRUE, removeOutsideVisibleBounds = TRUE, color = "#000"), label = paste(df$ville, ":", df$nombre, "employés"), labelOptions = labelOptions(noHide = T)) %>%
#       
#       addCircles(lng=df$LNG, lat=df$LAT, radius = sqrt(as.numeric(df$nombre))*100, weight = 1, color = "#000", opacity = 0.05) %>%
#       
#       
#       addAwesomeMarkers(lng=ville_cd_match$Longitude, lat=ville_cd_match$Latitude, popup=paste(ville_cd_match$Nom_Ville, ":", ville_cd_match$CD), icon = icon_cd) %>%
#       
#       addCircles(lng = ville_cd_match$Longitude, lat = ville_cd_match$Latitude, weight = 1, radius = km_portefeuille, color = "#FF7900", opacity = 0.05) %>%
#       
#       addMeasure(position = "bottomleft",
#                  primaryLengthUnit = "meters",
#                  primaryAreaUnit = "sqmeters",
#                  activeColor = "grey",
#                  completedColor = "grey", localization = "fr")
#     
#   }
#   
# })
# 
# ## To be copied in the UI
# mod_carte_france_padel_ui("carte_france_padel_1")
#     
# ## To be copied in the server
# # mod_carte_france_padel_server("carte_france_padel_1")
