#' Show the change of amount of bike rental by Temperature.
#'
#' This function draw a plot that show change of average temperature and average bike rental ratio in each month.
#'
#' @export
#' @import lubridate
#' @examples
#' getUsageByTemperature()

getUsageByTemperature <- function() {
    # Todo : Visualize the correlation between Amount of rental and Temperature.  xlab : month ylab : temperature, bike rental ratio.

    # monthList : 1, 2,... 12
    monthList <- c(1:12)

    # resultDF :
    resultDF <- data.frame(month = c(1:12), count = NA, rent_ratio = NA, avgOfTemperature = NA)

    # weatherFrom2013to2015 : weather Data for 3 years.
    weatherFrom2013to2015 <- rbind(weather2013, weather2014)
    weatherFrom2013to2015 <- rbind(weatherFrom2013to2015, weather2015)

    # Get average of number of rental In each month for 3 years.
    for (i_month in monthList) {
        locs <- month(tashuDataFor3year$RENT_DATE) == i_month
        monthlySubsetData <- tashuDataFor3year[locs, ]
        resultDF[resultDF$month == i_month, ]$count <- NROW(monthlySubsetData)/3

        locs <- month(weatherFrom2013to2015$Datetime) == i_month
        monthlyWeatherSubsetData <- weatherFrom2013to2015[locs, ]
        avgOfTempEachMonth <- mean(monthlyWeatherSubsetData$Temperature)
        resultDF[resultDF$month == i_month, ]$avgOfTemperature <- avgOfTempEachMonth
    }

    avgOfyearlyUsage <- sum(resultDF$count)
    resultDF$rent_ratio <- (resultDF$count)/avgOfyearlyUsage * 100

    plot(resultDF$month, resultDF$avgOfTemperature, axes = FALSE, ylim = c(0, 30), pch = 16, type = "b", xlab = "", ylab = "", col = "blue", main = "The monthly average temperature and rental")
    # Draw month axis
    axis(1, resultDF$month)
    mtext("Month", side = 1, col = "black", line = 2.5)

    # Draw temperature axis
    axis(2, ylim = c(0, 30), las = 1)
    mtext("Average temperature(Celsius)", side = 2, line = 2.5)

    # Allow a second plot on the same graph
    par(new = TRUE)

    plot(resultDF$month, resultDF$rent_ratio, xlab = "", ylab = "", ylim = c(0, 15), pch = 15, axes = FALSE, type = "b", col = "red")

    # Draw rental ratio axis
    axis(4, ylim = c(0, 15), col = "black", las = 1)
    mtext("Amount of Rental ratio(%)", side = 4, line = 2.5)


    # op <- par(cex = 0.8)
    legend("topright", legend = c("Average Temperature", "Amount of Rental Ratio"), text.col = c("blue", "red"), pch = c(16, 15), col = c("blue", "red"))
}
