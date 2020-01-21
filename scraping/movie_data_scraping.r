library(rvest)    
library(stringr)   
library(lubridate)
library(tidyr)
library(dplyr)


#torrent url
url <-'https://www.torrent9.pl/torrents/films/'


#recuperer toutes les pages
all_url <- str_c(url,seq(51,1551,50),sep='')
all_url <- c(url,all_url)


#recuperer les urls sur une page
get_url_by_page <- function(html){
  url_ <- html %>% 
          html_nodes('table td a ')%>%
          html_attr("href")
  url_ <- paste('https://www.torrent9.pl',url_,sep='')
  return(url_)
}


# Pour chaque activity pour chaque page get chaque entreprise et le lien
get_entreprise_of_each_page <- function(html){
  movie_title <-html %>% 
                  html_nodes('.movie-section .pull-left')%>% 
                  html_text() %>% 
                  str_trim()
  
  # movie_url <- html %>% 
  #              html_nodes('.movie-img script')%>% 
  #              html_text()%>% 
  #              str_extract_all("img")

  movie_category <-html %>% 
                    html_nodes('.movie-information ul>li')%>% 
                    html_text() %>% 
                    str_trim()
  a=data.frame(v1 = movie_category) %>% 
    mutate(v1 = strsplit(as.character(v1), ':'))
  b=read.table(text = gsub("\\s", "", a$v1), 
               strip.white=TRUE, header = FALSE)
  b=b[b!='character(0)']
  movie_info_ <- as.data.frame(matrix(b, ncol = 6, byrow = FALSE), stringsAsFactors = FALSE)
  movie_info <- data.frame(movie_info_[2,])
  colnames(movie_info) <- as.character(movie_info_[1,])
  
  
  movie_description <-html %>% 
                    html_nodes('.movie-information p')%>% 
                    html_text()
  movie_description <- movie_description[3]
  
  movie <- cbind.data.frame(movie_title,movie_info,movie_description)
  return(movie)
}


cbind.fill <- function(...){
  nm <- list(...) 
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(data = NA, n-nrow(x), ncol(x))))) 
}


#Scraping all data
all_movie_data <- data.frame()

for(page_url in all_url){

  print(page_url)
  read_page_url <- read_html(page_url)
  liste_page_movie <- get_url_by_page(read_page_url)
  page_movie_data <- data.frame()
  
  for(movie_url in liste_page_movie){
    print(movie_url)
    read_movie_url <- read_html(movie_url)
    movie_data <- get_entreprise_of_each_page(read_movie_url)
    
    page_movie_data <- rbind.data.frame(page_movie_data,movie_data)
  }
  
  all_movie_data <- rbind.data.frame(all_movie_data,page_movie_data)
}


#save
library(writexl)
write_xlsx(all_movie_data, path="F:\\PROJETS\\PROJETS_DATA\\Movie Space\\Data\\all_movie_data.xlsx")
