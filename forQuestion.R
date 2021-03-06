# install packages
pkgs.needs <- c("ggmap", "jsonlite", "dplyr", "stringr", "RSelenium")
pkgs.installed <- installed.packages()[,"Package"]
new.pkgs <- pkgs.needs[!(pkgs.needs %in% pkgs.installed)]
if(length(new.packages)) install.packages(new.pkgs)                        
library(dplyr)      # data manipulation & pipe line
library(stringr)    # str_pad
library(RSelenium)  # selenium
library(ggmap)
library(jsonlite)

# set working directory
oriDir <- getwd()
mainDir <- "/Users/jen/Documents/ntuHackson2017"
setwd(mainDir)
# seleniumDir <- "./seleniumDownload"
# ifelse(!dir.exists(file.path(seleniumDir)), dir.create(file.path(seleniumDir)), FALSE)
# setwd(seleniumDir)


# default mapt
map <- get_map(location = 'Taipei', zoom = 12)

file_list <- list.files(pattern = "*.txt")
for(j in c(1:length(file_list))){
# clean
json <- read_json(file_list[j])
df <- data.frame()
for (i in c(1:length(json$retVal))){
  data <- json$retVal[[i]] %>% as.data.frame
  df <- rbind(df, data) 
}
df$tot <- df$tot %>% as.character %>% as.numeric
df$lng <- df$lng %>% as.character %>% as.numeric
df$lat <- df$lat %>% as.character %>% as.numeric
df$bikes <- df$sbi %>% as.character %>% as.numeric
df$space <- df$bemp %>% as.character %>% as.numeric
# ploting
# jpeg(paste0('plot_', substring(file_list[j],1,19), '.jpg'), width=800, height=600)
ggmap(map, darken = 0.5) + 
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('red1')), data = df %>% subset(bikes == 0)) +
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('cyan')), data = df %>% subset(space == 0)) +
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('gray')), data = df %>% subset(bikes != 0 & space != 0)) +
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('yellow')), data = df %>% subset(bikes <= 3 & bikes>0)) +
  scale_size_continuous(range = c(0,2))
ggsave(paste0('plot_', substring(file_list[j],1,19), '.jpg'), dpi=300, width=6, height=5)
}