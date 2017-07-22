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

# main prog
while(1){
  startTime <- Sys.time()
  source('youbike_crawler.R', echo = TRUE)
  sleepTime <- startTime + 15*60 - Sys.time()
  sleepTime <- sleepTime %>% as.numeric
  sleepTime <- sleepTime*60
  if (sleepTime > 0)
    Sys.sleep(sleepTime)
}
# output data and restore env
setwd(oriDir)
