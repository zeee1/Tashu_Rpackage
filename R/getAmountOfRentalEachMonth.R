#' Get monthly amount of bike rental from 2013 to 2015.
#'
#' Draw a plot that visualize monthly average amount of bike rental from 2013 to 2015.
#'
#' @export
#' @import lubridate ggplot2
#'
#' @examples
#' getAmountOfRentalEachMonth()

getAmountOfRentalEachMonth <- function() {
    # monthList : 1, 2,... 12
    monthList <- c(1:12)

    # resultDF : average of number of rental In each month for 3 years
    resultDF <- data.frame(month = c(1:12), count = NA)

    # tashuDataFor3year <- rbind(tashu2013, tashu2014) tashuDataFor3year <- rbind(tashuDataFor3year, tashu2015)

    # Get average of number of rental In each month for 3 years.
    for (i_month in monthList) {
        locs <- month(tashuDataFor3year$RENT_DATE) == i_month
        monthlySubsetData <- tashuDataFor3year[locs, ]
        resultDF[resultDF$month == i_month, ]$count <- NROW(monthlySubsetData)/3
    }

    avgOfyearlyUsage <- sum(resultDF$count)
    resultDF$ratio <- (resultDF$count)/avgOfyearlyUsage * 100

    options(scipen = 100)

    # Visualize
    ggplot(resultDF, aes(x = month, y = ratio)) + geom_bar(data = resultDF, stat = "identity", aes(group = 1), fill = "#08d16c") + scale_x_discrete("Month",
        limits = c(1:12)) + ggtitle("Monthly amount Of Rental In Tashu\n")
}
