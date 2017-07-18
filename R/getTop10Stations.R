#' Get top 10 stations that have the most amount of rentals from 2013 to 2015.
#'
#' Draw a plot that visualized most used top 10 stations on barchart.
#' @return Data frame that contains top 10 most used stations from 2013 to 2015
#' @examples
#' top10StationsData <- getTop10Stations()

getTop10Stations <- function() {
  rent_cnt <- data.frame(table(tashuDataFor3year$RENT_STATION))
  return_cnt <- data.frame(table(tashuDataFor3year$RETURN_STATION))
  names(rent_cnt) <- c("station_no", "count")
  names(return_cnt) <- c("station_no", "count")

  station_cnt <- merge(rent_cnt, return_cnt, by="station_no", all=TRUE)
  station_cnt[is.na(station_cnt)] <- 0

  station_cnt["total_cnt"] <- rowSums(station_cnt[2:3])
  sort_station_cnt <- head(station_cnt[order(-station_cnt$total_cnt),],10)

  # visualization 1
  options(scipen = 100)
  ggplot(sort_station_cnt, aes(x = reorder(station_no, total_cnt), y = total_cnt)) + geom_bar(data = sort_station_cnt, stat = "identity", fill = "#53cfff") +
        geom_text(aes(label = total_cnt)) + coord_flip() + theme_light(base_size = 20) + xlab("Station") + ylab("Count") + ggtitle("Most Heavily used Station In 2013 ~ 2015\n") +
        theme(plot.title = element_text(size = 18))

  return(sort_station_cnt)
  # Visualization 2
  #map <- get_googlemap(center = c(lon = 127.367, lat = 36.363), zoom = 14, markers = data.frame(lon = resultDF$lon, lat = resultDF$lat), maptype = "roadmap") %>% ggmap
  #map <- map + geom_text(data = resultDF, aes(label = station)) + scale_size(range = c(0, 10))

  #multiplot(barchart, map)

}
