#' Get top 10 stations that have the most amount of rentals from 2013 to 2015.
#'
#' Draw two plots that visualized most used top 10 stations on barchart and map.
#' @examples
#' getTop10Stations()

getTop10Stations <- function() {
    # stationList : Station List on Tashu System.
    stationList <- c(1:144)
    
    # resultDF : A data frame that contains number of bike rentals In each station for 3 years.
    resultDF <- data.frame(station = c(1:144), rental_count = NA)
    
    # Get number of rentals In each station.
    for (i_station in stationList) {
        locs <- tashuDataFor3year$RENT_STATION == i_station
        rentSubset <- tashuDataFor3year[locs, ]
        
        resultDF[resultDF$station == i_station, ]$rental_count <- NROW(rentSubset)
    }
    
    # Get Top 10 stations that have the most number of rentals
    resultDF <- arrange(resultDF, desc(rental_count))
    resultDF <- head(resultDF, n = 10)
    
    # Get each station's GEO data.(longitude, latitude)
    stationList <- resultDF$station
    
    resultDF$lon <- NA
    resultDF$lat <- NA
    
    for (i_station in stationList) {
        resultDF[resultDF$station == i_station, ]$lon <- tashuStationData[tashuStationData$NUM == i_station, ]$GEODATA_lon
        resultDF[resultDF$station == i_station, ]$lat <- tashuStationData[tashuStationData$NUM == i_station, ]$GEODATA_lat
    }
    
    # visualization 1
    barchart <- ggplot(resultDF, aes(x = reorder(station, rental_count), y = rental_count)) + geom_bar(data = resultDF, stat = "identity", fill = "#53cfff") + 
        geom_text(aes(label = rental_count)) + coord_flip() + theme_light(base_size = 20) + xlab("Station") + ylab("Count") + ggtitle("Most Heavily used Station In 2013 ~ 2015\n") + 
        theme(plot.title = element_text(size = 18))
    
    # Visualization 2
    map <- get_googlemap(center = c(lon = 127.367, lat = 36.363), zoom = 14, markers = data.frame(lon = resultDF$lon, lat = resultDF$lat), maptype = "roadmap") %>% 
        ggmap
    map <- map + geom_text(data = resultDF, aes(label = station)) + scale_size(range = c(0, 10))
    
    multiplot(barchart, map)
    
}
