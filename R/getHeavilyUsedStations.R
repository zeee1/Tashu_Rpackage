#' Get top 10 stations that have the most amount of rentals from 2013 to 2015.
#'
#' @return The visualized image
#' @examples
#' getHeavilyUsedStations()

getHeavilyUsedStations <- function() {
    # stationList : Target station List : 1,2,3,... 144
    stationList <- c(1:144)

    # resultDF : Number of rentals In each station for 3 years.
    resultDF <- data.frame(station = c(1:144), usage = NA)

    # Get number of rentals In each station.
    for (i_station in stationList) {
        locs <- tashuTotalData$RENT_STATION == i_station
        rentSubset <- tashuTotalData[locs, ]

        resultDF[resultDF$station == i_station, ]$usage <- NROW(rentSubset)
    }

    # Get Top 10 stations that have the most number of rentals
    resultDF <- arrange(resultDF, desc(usage))
    resultDF <- head(resultDF, n = 10)

    # Get each station's GEO data.(longitude, latitude)
    stationList <- resultDF$station

    resultDF$lon <- NA
    resultDF$lat <- NA

    for(i_station in stationList){
      resultDF[resultDF$station == i_station,]$lon <- tashuStationData[tashuStationData$KIOSKNUM == i_station,]$GEODATA_lon
      resultDF[resultDF$station == i_station,]$lat <- tashuStationData[tashuStationData$KIOSKNUM == i_station,]$GEODATA_lat
    }

    par(mfrow = c(2,1))

    # visualization 1
    barchart <- ggplot(resultDF, aes(x = reorder(station, usage), y = usage)) +
      geom_bar(data = resultDF, stat = "identity", fill = "#53cfff") +
      geom_text(aes(label = usage))+
      coord_flip() +
      theme_light(base_size = 20) + xlab("Station") +
      ylab("Count") + ggtitle("Most Heavily used Station In 2013 ~ 2015\n") +
      theme(plot.title = element_text(size = 18))


    map <- get_googlemap(center = c(lon = 127.367,lat = 36.363), zoom = 14,
                         markers = data.frame(lon = resultDF$lon, lat = resultDF$lat),
                         maptype = "roadmap") %>% ggmap
    map <- map+
      geom_text(data = resultDF, aes(label = station))

    multiplot(barchart, map)

}
