#---- Analyse des stocks pertinents Ecolabel Pêche Durable  ----
#
# Interface Shiny - fichier global
#
# Code written by: 
#         Sébastien Metz - Sakana Consultants
# Initial Code: August 2019
#

#---- Clear all variables + load libraries ----

source("R/Housekeeping.R")

detachAllPackages()

package.list <-
  c("tidyverse",
    "data.table",
    "shiny",
    "shinydashboard",
    "Hmisc",
    "rlist",
    "xtable",
    "DMwR2")

attachPackages(package.list)

#---- Test or not test? ----

testCode <- TRUE # montre les tests

#---- Loading functions ----

lastYear <- 2018

source("R/GeneralOptions.R")
source("R/Texts.R")
# source("R/Scripts.R")
# source("R/Objects.R")

#---- Loading Data ----

dataICES <- read.csv(
  paste(folderOrigin, 
        "StockAssessmentGraphs_2019.csv", 
        sep = ""), 
  header = TRUE, 
  sep = csvSep,
  stringsAsFactors = TRUE)

speciesList <- read.csv(
  paste(folderOrigin, 
        "species.csv", 
        sep = ""), 
  header = TRUE,
  stringsAsFactors = TRUE,
  sep = csvSep)

speciesListRedux <- 
  speciesList %>%
  select(FAO_code, French) %>%
  rename(speciesKey = FAO_code,
         espece = French)

dataICES <- 
  dataICES %>%
  rename(F = FishingPressure,
         stock = StockSize,
         stockCode = FishStock,
         areasICES = ICES.Areas..splited.with.character.....)

descStock <- 
  dataICES %>%
  select("stockCode",
         "StockKey",
         "StockDatabaseID",
         "StockDescription") %>%
  unique() %>%
  arrange(stockCode)

descStock$speciesKey <- 
  with(descStock,
       factor(
         substr(stockCode, 1, 3)))

descStock$zoneKey <- 
  with(descStock,
       factor(
         substr(
           stockCode, 
           5, 
           nchar(as.character(stockCode)))))

descStock <- 
  dplyr::left_join(descStock, 
                   speciesListRedux)

descStock$nomStock <- 
  with(descStock,
       paste(espece, 
             zoneKey))

stockKey <- 
  descStock %>%
  select("stockCode",
         "nomStock")

dataICES <- dplyr::left_join(dataICES,
                             stockKey)

stockRedux <- 
  descStock %>%
  select("nomStock") %>%
  arrange(nomStock)

# 
# stockList <- as.character(stockRedux$nomStock)

stockMenu <- list.rbind(as.character(stockRedux$nomStock))

dataICES <- 
  dataICES %>%
  select(-c(Report,
            StockKey,
            StockDatabaseID,
            StockDescription))

dataICES$BMSY <- 
  with(dataICES,
       ifelse(
         is.na(MSYBtrigger), 
         Bpa,
         MSYBtrigger))
  

dataICES$indexF <- 
  with(dataICES,
       F / FMSY)
dataICES$indexB <- 
  with(dataICES,
       stock / BMSY)

dataICES$indexKobe <- 
  with(dataICES,
       ifelse(is.na(indexB),
              0,
              ifelse(indexB > 1,
                     3,
                     1)))
                
dataICES$indexKobe <- 
  with(dataICES,
       ifelse(
         is.na(indexF),
         0,
         indexKobe + 
           ifelse(indexF > 1,
                  0,
                  1)))
           
tabKobe <- 
  dataICES %>%
  select("nomStock", 
         "Year", 
         "indexKobe") %>%
  filter(Year >= lastYear - 8,
         Year <= lastYear)

tabKobePT <- 
  tabKobe %>%
  pivot_wider(values_from = "indexKobe",
              names_from = "Year") %>%
  rename(Stock = "nomStock") %>%
  arrange(across(contains(as.character(lastYear)), desc),
          across(contains(as.character(lastYear - 1)), desc),
          across(contains(as.character(lastYear - 2)), desc),
          across(contains(as.character(lastYear - 3)), desc))


