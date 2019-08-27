#' Visualize amount of bicycle rental at each day of week.
#'
#' A function analyzing bike rental pattern on each day of week and visualizing analyzed result.
#'
#' @export
#' @importFrom RColorBrewer brewer.pal
#' @importFrom grDevices colorRampPalette
#' @importFrom reshape2 melt
#' @importFrom lubridate wday hour
#' @importFrom ggplot2 ggplot geom_tile xlab ylab scale_fill_gradientn coord_equal theme_bw ggtitle
#' @importFrom dplyr summarise group_by %>%
#' @importFrom stats rnorm
#' @examples
#' \dontrun{daily_bike_rental()}


daily_bike_rental <- function() {
  tashu_record <- tashudata::tashu
  tashu_record$weekday <- lubridate::wday(tashudata::tashu$RENT_DATE)
  tashu_record$hour <- lubridate::hour(tashudata::tashu$RENT_DATE)

    daily_bike_usage <- tashu_record %>%
      dplyr::group_by(weekday, hour) %>%
      dplyr::summarise(rental_count = n())

    daily_bike_usage <- daily_bike_usage[daily_bike_usage$hour > 4, ]
    number_of_row <- 7
    number_of_column <- 19

    hourly_usage_record <- matrix(stats::rnorm(number_of_row * number_of_column), ncol = number_of_column)
    rownames(hourly_usage_record) <- c("Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun")
    colnames(hourly_usage_record) <- c(5:23)

    hour_list <- c(5:23)
    for (i in c(1:7)) {
        x <- switch(i, "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat")
        daily_record <- daily_bike_usage[daily_bike_usage$weekday == i, ]

        for (j in hour_list) {
            hourly_usage_record[x, j - 4] <- daily_record[daily_record$hour == j, ]$rental_count
        }
    }

    hourly_usage_record <- reshape2::melt(hourly_usage_record)
    palette <- colorRampPalette(rev(brewer.pal(11, "Spectral")), space = "Lab")

    zp1 <- ggplot(hourly_usage_record, aes_string(x = "Var2", y = "Var1", fill = "value"))
    zp1 <- zp1 + geom_tile()
    zp1 <- zp1 + scale_fill_gradientn(colours = palette(100))
    zp1 <- zp1 + coord_equal()
    zp1 <- zp1 + theme_bw()
    zp1 <- zp1 + xlab("Hour")
    zp1 <- zp1 + ylab("day Of Week")
    zp1 <- zp1 + ggtitle("The rental amount of bike rental each day of week(2013 ~ 2015)")
    print(zp1)
}
