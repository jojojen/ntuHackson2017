# set working directory
oriDir <- getwd()
mainDir <- "/Users/jen/Documents/ntuHackson2017"
setwd(mainDir)

# install packages
pkgs.needs <- c("ggmap", "mapproj", "jsonlite", "dplyr")
pkgs.installed <- installed.packages()[,"Package"] 
new.pkgs <- pkgs.needs[!(pkgs.needs %in% pkgs.installed)]
if(length(new.packages)) install.packages(new.pkgs)
library(ggmap)
library(mapproj)
library(jsonlite)
library(dplyr)

# clean data
json <- read_json("YouBikeTP.txt")
df <- data.frame()
for (i in c(1:length(json$retVal))){
  data <- json$retVal[[i]] %>% as.data.frame
  df <- rbind(df, data) 
}
df$tot <- df$tot %>% as.character %>% as.numeric
df$lng <- df$lng %>% as.character %>% as.numeric
df$lat <- df$lat %>% as.character %>% as.numeric

# ploting
map <- get_map(location = 'Taipei', zoom = 12)
ggmap(map) + geom_point(aes(x = lng, y = lat, size = tot), data = df)

# output data and restore env
write.csv(df, "result.csv")
setwd(oriDir)