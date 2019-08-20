#' Visualize top 10 stations that were most used from 2013 to 2015.
#'
#' Draw a plot that visualized most used top 10 stations on barchart.
#' @return Data frame that contains top 10 most used stations from 2013 to 2015
#'
#' @export
<<<<<<< HEAD
#' @importFrom stats reorder
#' @importFrom ggplot2 ggplot geom_bar aes geom_text coord_flip xlab ylab ggtitle theme theme_light element_text
#' @importFrom utils head
=======
#' @importFrom utils head
#' @importFrom stats reorder lag filter
#' @importFrom ggplot2 ggplot geom_bar aes geom_text coord_flip xlab ylab ggtitle theme theme_light element_text
>>>>>>> 69ed2f80b1268ee896326b867e3490f40392d7c7
#' @examples
#' \dontrun{top10_stations()}

top10_stations <- function() {
    rent_cnt <- data.frame(table(tashu$RENT_STATION))
    return_cnt <- data.frame(table(tashu$RETURN_STATION))
    names(rent_cnt) <- c("station_no", "count")
    names(return_cnt) <- c("station_no", "count")

    station_cnt <- merge(rent_cnt, return_cnt, by = "station_no", all = TRUE)
    station_cnt[is.na(station_cnt)] <- 0

    station_cnt["total_cnt"] <- rowSums(station_cnt[2:3])
    sort_station_cnt <- head(station_cnt[order(-station_cnt$total_cnt), ], 10)

    options(scipen = 100)
    stations_top10 <- reorder(sort_station_cnt$station_no, sort_station_cnt$total_cnt)
    ggplot(sort_station_cnt,
           aes(x = stations_top10, y = total_cnt)) +
      geom_bar(data = sort_station_cnt, stat = "identity", fill = "#53cfff") +
      geom_text(aes_string(label = "total_cnt")) +
      coord_flip() +
      theme_light(base_size = 20) +
      xlab("Station") +
      ylab("Count") +
      ggtitle("Most Popular Bike Station In 2013 ~ 2015\n") +
      theme(plot.title = element_text(size = 18))
}
