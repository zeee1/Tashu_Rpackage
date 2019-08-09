#' Visualize amount of bicycle rental at each day of week.
#'
#' @export
#' @import RColorBrewer ggplot2 dplyr reshape2 lubridate grDevices stats
#'
#' @examples
#' dailyBikeRental()


dailyBikeRental <- function(){
  tashu$weekday <- wday(tashu$RENT_DATE)
  tashu$hour <- hour(tashu$RENT_DATE)

  dailyBikeUsage <- tashu %>% group_by(weekday, hour) %>% summarise(rental_count=n())
  dailyBikeUsage <- dailyBikeUsage[dailyBikeUsage$hour > 4, ]
  nRow <- 7
  nCol <- 19

  resultData <- matrix(rnorm(nRow * nCol), ncol = nCol)
  rownames(resultData) <- c("Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun")
  colnames(resultData) <- c(5:23)

  hourList <- c(5:23)
  for (i in c(1:7)) {
    x <- switch(i, "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat")
    oneDayData <- dailyBikeUsage[dailyBikeUsage$weekday == i, ]

    for (j in hourList) {
      resultData[x, j-4] <- oneDayData[oneDayData$hour == j, ]$rental_count
    }
  }

  resultData <- melt(resultData)
  myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")), space = "Lab")

  zp1 <- ggplot(resultData, aes_string(x = 'Var2', y = 'Var1', fill = 'value'))
  zp1 <- zp1 + geom_tile()
  zp1 <- zp1 + scale_fill_gradientn(colours = myPalette(100))
  # zp1 <- zp1 + scale_x_discrete(expand = c(0, 0)) zp1 <- zp1 + scale_y_discrete(expand = c(0, 0))
  zp1 <- zp1 + coord_equal()
  zp1 <- zp1 + theme_bw()
  zp1 <- zp1 + xlab("Hour")
  zp1 <- zp1 + ylab("day Of Week")
  zp1 <- zp1 + ggtitle("The rental amount of bike rental each day of week(2013 ~ 2015)")
  print(zp1)
}

