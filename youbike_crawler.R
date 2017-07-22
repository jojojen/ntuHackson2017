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

# set download folder 
downloadFolder <- getwd()
eCaps <- list(
  chromeOptions = 
    list(prefs = list(
      "profile.default_content_settings.popups" = 0L,
      "download.prompt_for_download" = FALSE,
      "download.default_directory" = downloadFolder
    )
    )
)
# set remote
url= "http://data.taipei/youbike"
remDr <- remoteDriver(
  remoteServerAddr = "localhost", 
  port = 4444, 
  browserName ="chrome",
  extraCapabilities=eCaps
)
# default mapt
map <- get_map(location = 'Taipei', zoom = 12)

# download
remDr$open()           # open browser
remDr$navigate(url)    # website to crawl
remDr$close()
time <- format(Sys.time(), "%X")
fileName <- paste0("YouBikeTP", "_", time, ".txt")
file.rename("YouBikeTP.gz", fileName)
# clean
json <- read_json(fileName)
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
jpeg(paste0('plot_', time, '.jpg'), width=800, height=600)
ggmap(map, darken = 0.5) + 
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('red1')), data = df %>% subset(bikes == 0)) +
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('cyan')), data = df %>% subset(space == 0)) +
  geom_point(aes(x = lng, y = lat, size = 1, colour = I('gray')), data = df %>% subset(bikes != 0 & space != 0)) +
  scale_size_continuous(range = c(0,2))
dev.off()

setwd(oriDir)