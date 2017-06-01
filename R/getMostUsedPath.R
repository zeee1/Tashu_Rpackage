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

  p <- get_googlemap("daejeon", zoom = 12, maptype = "roadmap")%>% ggmap

}
