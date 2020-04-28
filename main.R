library(RCurl)
library(XML)
library("tidyverse")
library(rvest)
library(httr)
library(ggmap)
library(rjson)
library(plyr)
library(stringr)
library(xml2)
library(RJSONIO)
library(jsonlite)
#########################
webpage <- read_html("https://coronavirus.mash.ru/")
tbls <- html_nodes(webpage, "table")
head(tbls)

tbls_ls <- webpage %>%
  html_nodes("table") %>%
  #.[4:6] %>% #if you only need somw particular tables from the webpage your set it here
  html_table(fill = TRUE)

tbls_ls[[1]]

datat <- data.frame()


for (val in tbls_ls){
  datval <- as.data.frame(val)
  datat <- rbind(datat, datval)
}

head(datat, 4)


###################
datat$adress <- paste(datat$Улица, "+", datat$Дом)

###here are some test
geocodetest <- geoYandex("г. Москва, Ленинский проспект, 90")
geocodetest4 <- geoYandex("Ленинский проспект, 90")
geocodetest2 <- geoYandex("Одинцовский район, пос. Заречье, Весенняя ,  2")
geocodetest5 <- geoYandex("	д. Рогозино, Лесная ,  6") # -- this one gives NA
geocodetest3 <- geoYandex("Московский, Радужная улица ,  13/3")
geocodetestV <- geoYandex("Волгина Академика 8/1")
geocodetestW <- geoYandex("Волгина Академика 8 корпус 1")
###

datat$lonlat <- NA

tic <- print(Sys.time()) 
for (i in 1:length(datat$adress)) {
  datat$lonlat[i] <- geoYandex(datat$adress[i])
  if (i %% 1000 == 0){print(i)}
}
toc <- print(Sys.time()) 

print(toc-tic)


write.csv(datat, "covidadress_upd.csv", fileEncoding = "UTF-8")


