#' Get monthly amount of rental Each day of week
#'
#' @examples
#' getAmountOfRentalEachDayOfWeek()

getAmountOfRentalEachDayOfWeek <- function() {
  # weekdayList : 1 = Monday, 2 = Tuesday, 3 = Wednesday, 4 = Thursday, 5 = Friday, 6 = Saturday, 7 = Sunday
  dayOfWeekList <- c(1:7)

  # resultDF : Get hourly number of rental In 1 ~ 144 stations at each day of week for 3 years.
  resultDF <- data.frame(weekday = as.integer(), hour = as.integer(), count = as.integer())

  for (i_weekday in dayOfWeekList) {
    locs <- wday(tashuDataFor3year$rentDateTime) == i_weekday
    weekdaySubset <- tashuDataFor3year[locs, ]

    hourList <- c(5:23)

    for (i_hour in hourList) {
      hourSubset <- weekdaySubset[hour(weekdaySubset$rentDateTime) == i_hour, ]
      resultDF <- rbind(resultDF, data.frame(weekday = i_weekday, hour = i_hour, count = NROW(hourSubset)))
    }
  }

  # Get number of rental in Weekday
  locs <- resultDF$weekday <= 5
  weekdayData <- resultDF[locs, ]
  hourlyMeanOfDemandInWeekday <- ddply(weekdayData, .(hour), summarise, count = mean(count), check = "weekday")

  # Get number of rental in Weekend
  locs <- resultDF$weekday >= 6
  weekendData <- resultDF[locs, ]
  hourlyMeanOfDemandInWeekendDay <- ddply(weekendData, .(hour), summarise, count = mean(count), check = "weekend")

  # resultDF <- hourly Mean of Demand In each day of week
  resultDF <- rbind(hourlyMeanOfDemandInWeekday, hourlyMeanOfDemandInWeekendDay)

  # Visualize
  ggplot(resultDF, aes(x = hour, y = count, color = check)) + geom_point(data = hourlyMeanOfDemandInWeekday, aes(group = check)) + geom_line(data = hourlyMeanOfDemandInWeekday, aes(group = check)) +
    geom_point(data = hourlyMeanOfDemandInWeekendDay, aes(group = check)) + geom_line(data = hourlyMeanOfDemandInWeekendDay, aes(group = check))
}
