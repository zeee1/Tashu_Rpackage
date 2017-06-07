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

  for(rentStat in rentStationList){
    resultDF[resultDF$RENT_STATION == rentStat,]$Rent_lon <- tashuStationData[tashuStationData$KIOSKNUM == rentStat,]$GEODATA_lon
    resultDF[resultDF$RENT_STATION == rentStat,]$Rent_lat <- tashuStationData[tashuStationData$KIOSKNUM == rentStat,]$GEODATA_lat
  }

  for(returnStat in returnStationList){
    resultDF[resultDF$RETURN_STATION == returnStat,]$Return_lon <- tashuStationData[tashuStationData$KIOSKNUM == returnStat,]$GEODATA_lon
    resultDF[resultDF$RETURN_STATION == returnStat,]$Return_lat <- tashuStationData[tashuStationData$KIOSKNUM == returnStat,]$GEODATA_lat
  }

  #Todo : Create pathList(station, lon, lat, check)
  resultDF$index <- c(1:10)
  pathList <- data.frame(station = as.integer(), lon = as.integer(), lat = as.integer(), check = as.integer())

  for(index in 1:10){
    path <- resultDF[resultDF$index == index,]
    pathList <- rbind(pathList, data.frame(station = path$RENT_STATION, lon = path$Rent_lon, lat = path$Rent_lat, check = index))
    pathList <- rbind(pathList, data.frame(station = path$RETURN_STATION, lon = path$Return_lon, lat = path$Return_lat, check = index))
  }

  map <- get_googlemap(center = c(lon = 127.361197,lat = 36.358494), zoom = 13,
                       markers = data.frame(lon = rentStationGeoDF$lon, lat = rentStationGeoDF$lat),
                       maptype = "roadmap") %>% ggmap

  colorList <- c("#558de8", "#e82e40", "#1ebc09", "#f26f18", "#d12baa", "#2bd1b8")
  #파 빨 검 주 보 민


  map <- map+
    geom_text(data = rentStationGeoDF, aes(label = name))+
    geom_path(data = pathList, aes(x = lon, y = lat, color = check))


}
