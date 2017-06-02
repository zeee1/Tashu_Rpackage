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


    # visualization
    p <- ggplot(resultDF, aes(x = reorder(station, usage), y = usage)) + geom_bar(data = resultDF, stat = "identity", fill = "#53cfff") + coord_flip() + theme_light(base_size = 20) + xlab("Station") +
        ylab("Count") + ggtitle("Most Heavily used Station In 2013 ~ 2015\n") + theme(plot.title = element_text(size = 18))



    return(p)
}
