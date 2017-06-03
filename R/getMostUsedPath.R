#' Get most Used 10 Pathes from 2013 to 2015 And visualize the result on map.
#'
#' @examples
#' getMostUsedPath()

getMostUsedPath <- function(){
  stationList <- c(1:144)
  resultDF <- data.frame(RENT_STATION = as.integer(), RETURN_STATION = as.integer(), count = as.integer())

  for(i_station in stationList){
    rentStationSubset <- tashuTotalData[tashuTotalData$RENT_STATION == i_station,]

    for(j_station in stationList){
      returnStationSubset <- rentStationSubset[rentStationSubset$RETURN_STATION == j_station,]
      resultDF <- rbind(resultDF, data.frame(RENT_STATION = i_station, RETURN_STATION = j_station, count = NROW(returnStationSubset)))
    }
  }

  resultDF <- arrange(resultDF, desc(count))
  resultDF <- head(resultDF, n = 10)

  resultDF$Rent_lon <- NA
  resultDF$Rent_lat <- NA

  resultDF$Return_lon <- NA
  resultDF$Return_lat <- NA

  rentStationList <- resultDF$RENT_STATION

  for(rentStat in rentStationList){
    resultDF[resultDF$RENT_STATION == rentStat,]$Rent_lon <- tashuStationData[tashuStationData$KIOSKNUM == rentStat,]$GEODATA_lon
    resultDF[resultDF$RENT_STATION == rentStat,]$Rent_lat <- tashuStationData[tashuStationData$KIOSKNUM == rentStat,]$GEODATA_lat
  }

  returnStationList <- resultDF$RETURN_STATION

  for(returnStat in returnStationList){
    resultDF[resultDF$RETURN_STATION == returnStat,]$Return_lon <- tashuStationData[tashuStationData$KIOSKNUM == returnStat,]$GEODATA_lon
    resultDF[resultDF$RETURN_STATION == returnStat,]$Return_lat <- tashuStationData[tashuStationData$KIOSKNUM == returnStat,]$GEODATA_lat
  }

  rentStationGeoDF <- data.frame(lon = resultDF$Rent_lon, lat = resultDF$Rent_lat)
  returnStationGeoDF <- data.frame(lon = resultDF$Return_lon, lat = resultDF$Return_lat)
  markerList <- rbind(rentStationGeoDF, returnStationGeoDF)
  pathList <- data.frame(lon,lat,group)

  map <- get_googlemap("daejeon", zoom = 13,
                       markers = data.frame(lon = markerList$lon, lat = markerList$lat),
                       maptype = "roadmap")

  ggmap(map, extent = "device")+
    geom_point(data = resultDF, aes(x = Rent_lon, y = Rent_lat))+
    geom_text(data = resultDF, aes(label = RENT_STATION))

  locationInfo <- data.frame(
    Name = c("강남", "양재", "양재시민의숲", "청계산입구", "판교", "정자"), 
    lon = c(127.028046, 127.035140, 127.038451, 127.054769, 127.111172, 127.108367), 
    lat = c(37.497001, 37.483368, 37.469655, 37.448196, 37.394786, 37.366777)
  )
  
  p3 <- ggmap(get_googlemap("gwacheon", zoom = 11,maptype = "roadmap"))
  p3 <- p3 + geom_point(data = locationInfo, aes(x = lon, y = lat)) +
    geom_text(data = locationInfo, aes(label = Name), size = 4, hjust = 1.2, fontface = "bold")
  p3 + geom_path(data = locationInfo, aes(x = lon, y = lat), color = "blue", alpha = .5, lwd = 1)

  
}
