# set working directory
oriDir <- getwd()
mainDir <- "/Users/jen/Documents/ntuHackson2017"
setwd(mainDir)

# install packages
pkgs.needs <- c("ggmap", "jsonlite", "dplyr")
pkgs.installed <- installed.packages()[,"Package"] 
new.pkgs <- pkgs.needs[!(pkgs.needs %in% pkgs.installed)]
if(length(new.packages)) install.packages(new.pkgs)
library(ggmap)
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
df$bikes <- df$sbi
df$space <- df$bemp
# ploting
map <- get_map(location = 'Taipei', zoom = 12)
ggmap(map, darken = 0.5) + 
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('red1')), data = df %>% subset(bikes == 0)) +
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('cyan')), data = df %>% subset(space == 0)) +
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('gray')), data = df %>% subset(bikes != 0 & space != 0)) +
  scale_size_continuous(range = c(0,2))
dev.off()
# output data and restore env
setwd(oriDir)
