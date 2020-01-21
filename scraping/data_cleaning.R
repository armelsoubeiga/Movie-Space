library(readxl)
library(stringr)


#Dedup movie and Save
all_movie_data <- read_excel("F:/PROJETS/PROJETS_DATA/Movie Space/Data/all_movie_data.xlsx")
df <- all_movie_data
df <- df[-grep("Séries",df$Catégories),]
df <- df[-grep("Jeux-PC",df$Catégories),]
df <- df[-grep("Musique",df$Catégories),]
df <- df[-grep("Logiciels",df$Catégories),]

df <- df [!duplicated(df[c(5:8)]),]
colnames(df) <- c('Title','Seed','Leech','Poidsdutorrent','date','Categories','Genre','Plot')
write.table(df, "F:/PROJETS/PROJETS_DATA/Movie Space/Data/movie.csv", row.names=FALSE, sep=";")


#Dedup serie and Save
all_movie_serie_data <- read_excel("F:/PROJETS/PROJETS_DATA/Movie Space/Data/all_movie_serie_data.xlsx")
dt <- all_movie_serie_data
dt <- dt[-grep("Films",dt$Catégories),]
dt <- dt[-grep("Jeux-PC",dt$Catégories),]
dt <- dt[-grep("Musique",dt$Catégories),]
dt <- dt[-grep("Logiciels",dt$Catégories),]
dt <- dt[-grep("Porno",dt$Catégories),]

#dt <- dt[!duplicated(dt[c(5:8)]),]
colnames(dt) <- c('Title','Seed','Leech','Poidsdutorrent','date','Categories','Genre','Plot')
write.table(dt, "F:/PROJETS/PROJETS_DATA/Movie Space/Data/serie.csv", row.names=FALSE, sep=";")



