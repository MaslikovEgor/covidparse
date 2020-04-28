##if have data -- import it in cloud and load
data_old <- readRDS()
data_old <- read.csv()
###################
webpage <- read_html("https://coronavirus.mash.ru/")
tbls <- html_nodes(webpage, "table")
head(tbls)

tbls_ls <- webpage %>%
  html_nodes("table") %>%
  #.[4:6] %>% # once again set particular tables
  html_table(fill = TRUE)


tbls_ls[[1]]

data_updd <- data.frame()


for (val in tbls_ls){
  datval <- as.data.frame(val)
  data_updd <- rbind(data_updd, datval)
}

head(data_updd, 4)

data_updd$adress <- paste(data_updd$Улица, ", ", data_updd$Дом)
data_updd$lonlat <- NA

for (i in 1:length(data_updd$adress)) {
  data_updd$lonlat[i] <- geoYandex(data_updd$adress[i])
  if (i %% 250 == 0){print(i)}
}
for (i in 1:length(data_updd$adress)) {
  data_updd$ya_adress[i] <- getAdress(data_updd$adress[i])
  if (i %% 250 == 0){print(i)}
}

data_full <- rbind(data_old, data_updd)

