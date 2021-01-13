#' Visualize amount of bicycle rental at each day of week.
#'
#' A function analyzing bicycle rental pattern on each day of week and visualizing analyzed result.
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
#' \dontrun{daily_bicycle_rental()}


daily_bicycle_rental <- function() {
  check_data()
  tashu_record <- tashudata::tashu
  tashu_record$weekday <- lubridate::wday(tashudata::tashu$RENT_DATE)
  tashu_record$hour <- lubridate::hour(tashudata::tashu$RENT_DATE)



  daily_bicycle_usage <- tashu_record %>% dplyr::count(weekday, hour) %>% dplyr::rename(rental_count = n)


    daily_bicycle_usage <- daily_bicycle_usage[daily_bicycle_usage$hour > 4, ]
    number_of_row <- 7
    number_of_column <- 19

    hourly_usage_record <- matrix(stats::rnorm(number_of_row * number_of_column), ncol = number_of_column)
    rownames(hourly_usage_record) <- c("Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun")
    colnames(hourly_usage_record) <- c(5:23)

    hour_list <- c(5:23)
    for (i in c(1:7)) {
        x <- switch(i, "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat")
        daily_record <- daily_bicycle_usage[daily_bicycle_usage$weekday == i, ]

        for (j in hour_list) {
            hourly_usage_record[x, j - 4] <- daily_record[daily_record$hour == j, ]$rental_count
        }
    }

    hourly_usage_record <- reshape2::melt(hourly_usage_record)
    palette <- colorRampPalette(rev(brewer.pal(11, "Spectral")), space = "Lab")

    ggplot(hourly_usage_record, aes_string(x = "Var2", y = "Var1", fill = "value"))+
      geom_tile() +
      scale_fill_gradientn(colours = palette(100)) +
      coord_equal() +
      theme_bw() +
      xlab("Hour") +
      ylab("day Of Week") +
      ggtitle("The rental amount of bicycle rental each day of week(2013 ~ 2015)")

}
