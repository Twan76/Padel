library(readxl)

# Lecture des fichiers
setwd("~/Desktop/Padel")
file_map_ville  <- paste(getwd(),"/map_villes.xlsx", sep="")
villes <- suppressMessages(read_excel(file_map_ville))
villes <- villes[,c(2:7)]
colnames(villes) <- c("Nom_Ville", "Code_Postal", "Code_INSEE", "Region", "Latitude", "Longitude")

tournois_padel  <- paste(getwd(),"/TournoisPadel.xlsx", sep="")
tournois <- suppressMessages(read_excel(tournois_padel))

# Liaison entre les 2 tables pour voir si pas d'oublis
oublis <- merge(x = tournois, y = villes, by.x = "Ville", by.y = "Nom_Ville", all.x = TRUE)
