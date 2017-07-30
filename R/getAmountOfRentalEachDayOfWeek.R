#' Get monthly amount of rental Each day of week
#' @export
#' @import ggplot2 RColorBrewer reshape2 lubridate
#'
#' @examples
#' getAmountOfRentalEachDayOfWeek()

getAmountOfRentalEachDayOfWeek <- function() {
    # weekdayList : 1 = Monday, 2 = Tuesday, 3 = Wednesday, 4 = Thursday, 5 = Friday, 6 = Saturday, 7 = Sunday
    dayOfWeekList <- c(1:7)
    hourList <- c(5:23)

    # resultDF : Get hourly number of rental In 1 ~ 144 stations at each day of week for 3 years.
    resultDF <- data.frame(weekday = as.integer(), hour = as.integer(), count = as.integer())

    for (i_weekday in dayOfWeekList) {
        locs <- wday(tashuDataFor3year$RENT_DATE) == i_weekday
        weekdaySubset <- tashuDataFor3year[locs, ]

        for (i_hour in hourList) {
            hourSubset <- weekdaySubset[hour(weekdaySubset$RENT_DATE) == i_hour, ]
            resultDF <- rbind(resultDF, data.frame(weekday = i_weekday, hour = i_hour, count = NROW(hourSubset)))
        }
    }

    ## Get number of rental in Weekday locs <- resultDF$weekday <= 5 weekdayData <- resultDF[locs, ] hourlyMeanOfDemandInWeekday <- ddply(weekdayData,
    ## .(hour), summarise, count = mean(count), check = 'weekday')

    ## Get number of rental in Weekend locs <- resultDF$weekday >= 6 weekendData <- resultDF[locs, ] hourlyMeanOfDemandInWeekendDay <-
    ## ddply(weekendData, .(hour), summarise, count = mean(count), check = 'weekend')

    ## resultDF <- hourly Mean of Demand In each day of week resultDF <- rbind(hourlyMeanOfDemandInWeekday, hourlyMeanOfDemandInWeekendDay)

    ## Visualize ggplot(resultDF, aes(x = hour, y = count, color = check)) + geom_point(data = hourlyMeanOfDemandInWeekday, aes(group = check)) +
    ## geom_line(data = hourlyMeanOfDemandInWeekday, aes(group = check)) + geom_point(data = hourlyMeanOfDemandInWeekendDay, aes(group = check)) +
    ## geom_line(data = hourlyMeanOfDemandInWeekendDay, aes(group = check))

    nRow <- 7
    nCol <- 19

    resultData <- matrix(rnorm(nRow * nCol), ncol = nCol)
    rownames(resultData) <- c("Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun")
    colnames(resultData) <- c(5:23)

    for (i in dayOfWeekList) {
        x <- switch(i, "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat")
        oneDayData <- resultDF[resultDF$weekday == i, ]

        for (j in hourList) {
            resultData[x, j - 4] <- oneDayData[oneDayData$hour == j, ]$count
        }
    }

    resultData <- melt(resultData)
    myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")), space = "Lab")

    zp1 <- ggplot(resultData, aes(x = Var2, y = Var1, fill = value))
    zp1 <- zp1 + geom_tile()
    zp1 <- zp1 + scale_fill_gradientn(colours = myPalette(100))
    # zp1 <- zp1 + scale_x_discrete(expand = c(0, 0)) zp1 <- zp1 + scale_y_discrete(expand = c(0, 0))
    zp1 <- zp1 + coord_equal()
    zp1 <- zp1 + theme_bw()
    zp1 <- zp1 + xlab("Hour")
    zp1 <- zp1 + ylab("day Of Week")
    zp1 <- zp1 + ggtitle("The average amount of bike rental each day of week(2013 ~ 2015)")
    print(zp1)
}
