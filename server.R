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

shinyServer(function(input, output){
  output$my_leaf <- renderLeaflet(
    {leaflet(data = df) %>% 
        addTiles() %>%
        
        #Outside city
        addPolygons(data = noncity, color = "black", weight = 2.5) %>%
        
        #Loomis et al sewer lining
        addPolylines(data = loomisWater, color = "yellow", weight = 2.5, opacity = 1, fillOpacity = 1, popup = paste("Loomis Ave-Ritchie St-Magnolia Ave Sewer Lining",
                                                                                                                     "<a href = 'https://www.cityofcf.com/departments/water'>Project Information</a>",
                                                                                                                     sep = "<br/>")) %>%
        addPolylines(data = ritchieWater, color = "yellow", weight = 2.5, opacity = 1, fillOpacity = 1, popup = paste("Loomis Ave-Ritchie St-Magnolia Ave Sewer Lining",
                                                                                                                      "<a href = 'https://www.cityofcf.com/departments/water'>Project Information</a>",
                                                                                                                      sep = "<br/>")) %>%
        addPolylines(data = magnoliaWater, color = "yellow", weight = 2.5, opacity = 1, fillOpacity = 1, popup = paste("Loomis Ave-Ritchie St-Magnolia Ave Sewer Lining",
                                                                                                                       "<a href = 'https://www.cityofcf.com/departments/water'>Project Information</a>",
                                                                                                                       sep = "<br/>")) %>%
        
        #Engineering repaving
        addPolylines(data = wSteels, color = "green", weight = 2.5, opacity = 1, fillOpacity = 1, popup = paste("W Steels Corners Rd Repaving",
                                                                                                                "<a href = 'https://www.cityofcf.com/departments/engineering'>Project Information</a>",
                                                                                                                sep = "<br/>")) %>%
        
        #P&R and Electric Projects
        addCircleMarkers(~Long, ~Lat, color = df$Color, opacity = 1, fillOpacity = 1, radius = 5, popup = df$Project, stroke = "black") %>%
        addLegend(title = "Department/Division", colors = c("blue", "green", "orange", "yellow"), labels = c("Electric", "Engineering", "Parks and Recreation", "Water"), position = "bottomleft", opacity = 1) %>% 
        setView(lng = -81.52086850522397, lat = 41.15917814076463, zoom = 12)
    }
    
  )
})
