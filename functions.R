#you need to get yandex geocoder apikey to achive the data
#WARNING: API limit -- 25000 searches per day 


geoYandex<-function(location) #this function returns latitude and longitude
{
  stopifnot(is.character(location))
  loc <- location
  location <- gsub(",", "", location)
  location <- gsub(" ", "+", location)
  posturl <- paste(location)
  url_string <- paste("https://geocode-maps.yandex.ru/1.x/?lang=ru_RU&apikey=<YOUR APIKEY>&geocode=...",
                      posturl, sep = "")
  url_string <- URLencode(url_string)
  xmlText <- paste(readLines(url_string, warn=FALSE), "\n", collapse="")
  data<-xmlParse(xmlText, asText=TRUE)
  xml_data <- xmlToList(data)
  pos<-xml_data$GeoObjectCollection$featureMember$GeoObject$Point$pos
  if (is.null(pos)){
    position = "NA"
  } else{
    lon<-c(word(pos,1))
    lat<-as.numeric(word(pos,2))
    position <- paste(lon, " ", lat)}
  return (position)
}

getAdress<-function(location) # and this returns adress, as it is indexed by yandex
{
  stopifnot(is.character(location))
  loc <- location
  location <- gsub(",", "", location)
  location <- gsub(" ", "+", location)
  posturl <- paste(location)
  url_string <- paste("https://geocode-maps.yandex.ru/1.x/?lang=ru_RU&apikey=<TOU MAY NEED APIKEY>&geocode=...",
                      posturl, sep = "")
  url_string <- URLencode(url_string)
  xmlText <- paste(readLines(url_string, warn=FALSE), "\n", collapse="")
  data<-xmlParse(xmlText, asText=TRUE)
  xml_data <- xmlToList(data)
  name<-xml_data$GeoObjectCollection$featureMember$GeoObject$metaDataProperty$GeocoderMetaData$text
  if (is.null(name)){
    name = "NA"
  }
  return (name)
}
