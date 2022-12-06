setwd("~/Downloads/Output_CSVs")
library(tidyverse)

oneCO <- read_csv("CO_data_24hr_20130601.csv")
names(oneCO) = gsub(pattern = "CO_", replacement = "", x = names(oneCO))
CO_names <- names(oneCO)

oneNO <- read_csv("NO_data_24hr_20130601.csv")
names(oneNO) = gsub(pattern = "NO_", replacement = "", x = names(oneNO))
NO_names <- names(oneNO)

oneNO2 <- read_csv("NO2_data_24hr_20130601.csv")
names(oneNO2) = gsub(pattern = "NO2_", replacement = "", x = names(oneNO2))
NO2_names <- names(oneNO2)

oneO3 <- read_csv("O3_data_24hr_20130601.csv")
names(oneO3) = gsub(pattern = "O3_", replacement = "", x = names(oneO3))
O3_names <- names(oneO3)

oneSO2 <- read_csv("SO2_data_24hr_20130601.csv")
names(oneSO2) = gsub(pattern = "SO2_", replacement = "", x = names(oneSO2))
SO2_names <- names(oneSO2)

tempCO = list.files(pattern="^CO*")
COcsvs = lapply(tempCO, read.delim)
tempNO = list.files(pattern="^NO_d*")
NOcsvs = lapply(tempNO, read.delim)
tempNO2 = list.files(pattern="^NO2_d*")
NO2csvs = lapply(tempNO2, read.delim)
tempO3 = list.files(pattern="^O3*")
O3csvs = lapply(tempO3, read.delim)
tempSO2 = list.files(pattern="^SO2*")
SO2csvs = lapply(tempSO2, read.delim)

CO <- dplyr::bind_rows(COcsvs, .id = "index")
colnames(CO)[2] <- "columns"
COdf <- CO %>%
  separate(columns, into=CO_names, sep=",") %>%
  mutate(species = "CO") %>% 
  select(species,index:T23)

NO <- dplyr::bind_rows(NOcsvs, .id = "index")
colnames(NO)[2] <- "columns"
NOdf <- NO %>%
  separate(columns, into=NO_names, sep=",") %>%
  mutate(species = "NO") %>% 
  select(species,index:T23)

NO2 <- dplyr::bind_rows(NO2csvs, .id = "index")
colnames(NO2)[2] <- "columns"
NO2df <- NO2 %>%
  separate(columns, into=NO2_names, sep=",") %>%
  mutate(species = "NO2") %>% 
  select(species,index:T23)

O3 <- dplyr::bind_rows(O3csvs, .id = "index")
colnames(O3)[2] <- "columns"
O3df <- O3 %>%
  separate(columns, into=O3_names, sep=",") %>%
  mutate(species = "O3") %>% 
  select(species,index:T23)

SO2 <- dplyr::bind_rows(SO2csvs, .id = "index")
colnames(SO2)[2] <- "columns"
SO2df <- SO2 %>%
  separate(columns, into=SO2_names, sep=",") %>%
  mutate(species = "SO2") %>% 
  select(species,index:T23)

rm(CO,COcsvs,NO,NO2,NO2csvs,NOcsvs,O3,O3csvs,
   oneCO,oneNO,oneNO2,oneO3,oneSO2,SO2,SO2csvs,
   CO_names,NO_names,NO2_names,O3_names,SO2_names,
   tempCO,tempNO,tempNO2,tempO3,tempSO2)

alldata <- bind_rows(COdf,NOdf,NO2df,O3df,SO2df, .id="species_no")

names(alldata)[names(alldata) == 'x'] <- 'site'

alldata2 <- alldata %>%
  pivot_longer(cols = "T0":"T23", 
               names_to = "hour",
               values_to = "concentration")
alldata2$hour = as.numeric(gsub(pattern = "T", replacement = "", x = alldata2$hour))


alldata3 <- alldata2 %>%
  mutate(day = ifelse(
    index == 45 & hour > 19, 0, index
  ))

alldata4 <- alldata3 %>%
  select(species,day,hour,site,Lat,Lon,concentration)

library("zoo")
as.Date(15856)
# [1] "2013-05-31"

alldata5 <- alldata4 %>%
  mutate(dayplus = as.numeric(day) + 15856) %>%
  mutate(date = as.Date(dayplus)) %>%
  select(species,day,date,hour,site,Lat,Lon,concentration)

O3final <- alldata5 %>%
  filter(species=="O3")


#write_csv(alldata5, "~/Documents/RobesonOutputData.csv")

#write_csv(O3final, "~/Documents/RobesonOzoneOutput.csv")
