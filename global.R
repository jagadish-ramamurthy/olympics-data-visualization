setwd(
  "D:/OneDrive/OneDrive - TCDUD.onmicrosoft.com/Semester 2/Data Visualization/Assigments/Assignment 3"
)

packages_list <- c("dplyr", "shiny", "shinyWidgets", "shinydashboard", "sf", "leaflet", "highcharter")
new_packages <-  packages_list[!(packages_list %in% installed.packages()[, "Package"])]
if(length(new_packages)) install.packages(new_packages)

#setting up necessary libraries
library(dplyr)
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(sf)
library(leaflet)
library(highcharter)

# reading the olympic and the city datasets.
df_olympics <-
  read.csv("dataset/athlete_events.csv", fileEncoding = "UTF-8-BOM")

df_cities <-
  read.csv("dataset/cities_locations.csv", fileEncoding = "UTF-8-BOM")

df_sports_images <-
  read.csv("dataset/sports_images.csv", fileEncoding = "UTF-8-BOM")

sf_world_shape_files <-
  read_sf(dsn = "dataset/world-shape-files") %>% rename(Country = NAME_LONG)

df_olympics <- df_olympics %>%
  filter(df_olympics$Season == "Summer")

# df_medal_colors <- 
#   read.csv("dataset/medal_colors.csv", fileEncoding = "UTF-8-BOM")

df_olympics <- merge(df_olympics, df_cities) %>%
  arrange(df_olympics$Year)

# df_olympics <-  merge(df_olympics, df_medal_colors) %>%
#   arrange(df_olympics$Year)

df_olympics$Medal <- factor(df_olympics$Medal, levels = c("Bronze", "Silver", "Gold", "<NA>"))

df_olympic_regions <- df_olympics %>%
  select(Year, Season, City, Latitude, Longitude) %>%
  unique() %>%
  arrange(Year)

df_individual_medal_year <- df_olympics %>%
  select(Year, Country, Medal) %>%
  na.omit() %>%
  group_by(., Year, Country) %>%
  count(., Medal, name = "Count")  %>%
  arrange(Year, Country)

df_all_medals_year <- df_individual_medal_year %>%
  group_by(., Year, Country) %>%
  summarise(TotalMedals = sum(Count)) %>%
  arrange(Year, Country)

df_medals_countries <- df_all_medals_year %>%
  group_by(., Country) %>%
  summarise(TotalMedals = sum(TotalMedals)) %>%
  arrange(TotalMedals)

df_gender_count <- df_olympics %>%
  select(Year, Country, Sex, Name) %>%
  unique() %>%
  group_by(., Year, Country) %>%
  count(., Sex, name = "Count") %>%
  arrange(Year, Country)

df_sports_medal_year <- df_olympics %>%
  select(Year, Country, Sport, Medal) %>%
  group_by(., Year, Country, Sport) %>%
  na.omit() %>%
  count(., Medal, name = "Count")  %>%
  arrange(Year, Country)

df_sports <- df_olympics %>%
  select(Year, Sport) %>%
  unique() %>%
  arrange(Year, Sport)

df_sports <- merge(df_sports, df_sports_images)
