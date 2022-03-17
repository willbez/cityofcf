setwd("//cf-file01/bezbatchenko/R Scripts/MapPics/")

library(shiny)
library(leaflet)
library(sf)

streets <- st_read("tl_2021_39153_roads_clipped.shp")

noncity <- st_read("OtherCities.shp")

loomisWater <-  streets[grep("Loomis", streets$FULLNAME), "geometry"] %>%
                  unlist %>% 
                  as.numeric() %>%
                  matrix(ncol = 2, byrow = F)

ritchieWater <- streets[grep("Ritchie", streets$FULLNAME), "geometry"] %>%
                    unlist %>% 
                    as.numeric() %>%
                    matrix(ncol = 2, byrow = F)

magnoliaWater <- streets[grep("Magnolia", streets$FULLNAME), "geometry"] %>%
                    unlist %>% 
                    as.numeric() %>%
                    matrix(ncol = 2, byrow = F)

wSteels <- streets[grep("W Steels", streets$FULLNAME), "geometry"] %>%
                    unlist() %>%
                    as.numeric() %>%
                    matrix(ncol = 2)

wSteels <- wSteels[wSteels[,1] < -81.5361681,]

wSteels <- rbind(c(-81.5361681, 41.1808393), wSteels)

df <- data.frame() %>%
  rbind(c(paste("Keyser-Swain House", 
                "851 W Bath Rd", 
                "Cuyahoga Falls, OH 44223", 
                "<a href = 'https://www.cityofcf.com/departments/parks-recreation'>Project Information</a>",
                sep = "<br/>"), "Parks and Recreation", 41.166791198354524, -81.53334377037784, "orange"),
        c(paste("Northampton Town Hall ADA Improvements", 
                "851 W Bath Rd", 
                "Cuyahoga Falls, OH 44223",
                "<a href = 'https://www.cityofcf.com/departments/parks-recreation'>Project Information</a>",
                sep = "<br/>"), "Parks and Recreation", 41.16663176875887, -81.5360323823644, "orange"),
        c(paste("Brookledge Golf Club Clubhouse", 
                "1621 Bailey Rd", 
                "Cuyahoga Falls, OH 44221",
                "<a href = 'https://www.cityofcf.com/departments/parks-recreation'>Project Information</a>",
                sep = "<br/>"), "Parks and Recreation", 41.12675787654844, -81.4605702731217, "orange"),
        c(paste("Electric Division Building",
                "222 Cochran Rd",
                "Cuyahoga Falls, OH 44223",
                "<a href = 'https://www.cityofcf.com/departments/electric'>Project Information</a>",
                sep = "<br/>"), "Electric", 41.167221277630375, -81.50010717785338, "blue")
  )

colnames(df) <- c("Project", "Dept", "Lat", "Long", "Color")

df$Lat <- as.numeric(df$Lat)

df$Long <- as.numeric(df$Long)

shinyUI(fluidPage(
  main_content <- mainPanel(
      leafletOutput("my_leaf")
    )
))