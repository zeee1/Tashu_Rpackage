#' Get monthly amount of rental for 3 years.
#'
#' @examples
#' getAmountOfRentalEachMonth()

getAmountOfRentalEachMonth <- function() {
  # monthList : 1, 2,... 12
    monthList <- c(1:12)

    # resultDF : average of number of rental In each month for 3 years
    resultDF <- data.frame(month = c(1:12), count = NA)

    # Get average of number of rental In each month for 3 years.
    for (i_month in monthList) {
        locs <- month(tashuDataFor3year$rentDateTime) == i_month
        monthlySubsetData <- tashuDataFor3year[locs, ]
        resultDF[resultDF$month == i_month, ]$count <- NROW(monthlySubsetData)/3
    }

    avgOfyearlyUsage <- sum(resultDF$count)
    resultDF$ratio <- (resultDF$count)/avgOfyearlyUsage*100

    options(scipen = 100)

    # Visualize
    ggplot(resultDF, aes(x = month, y = ratio)) + geom_bar(data = resultDF, stat = "identity", aes(group = 1), fill = "#08d16c") + scale_x_discrete("Month", limits = c(1:12))+
      ggtitle("Monthly amount Of Rental In Tashu\n")
}
