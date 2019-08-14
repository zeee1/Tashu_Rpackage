#' Create test dataset on specific station for prediction
#'
#' A function to create test dataset on 'station_number' bike station by preprocessing bike rental history and weather data in 2015.
#'
#' @param station_number number that means the number of each station.(1 ~ 144)
#' @return a dataset containing feature and rental count data on 'station_number' station, 2015
#' @export
#' @importFrom lubridate hour month wday year floor_date
#' @importFrom dplyr summarise group_by left_join
#' @examples test_dataset <- create_test_dataset(1)
#'

create_test_dataset <- function(station_number) {

  if(station_number < 1 || station_number > 144){
    stop("Station number should be from 1 to 144. Please re-Input station number.", call. = FALSE)
  }
    test_dataset <- data.frame(
        datetime = seq(as_datetime("2015/01/01 00:00:00", tz = "EST"),
                       as_datetime("2015/12/31 23:00:00", tz = "EST"),
                       "hours"))

    # Add feature columns('hour', 'month', 'weekday', 'season') to trainDataset
    test_dataset["hour"] <- as.character(hour(test_dataset$datetime))
    test_dataset["month"] <- as.character(month(test_dataset$datetime))
    test_dataset["weekday"] <- as.character(wday(test_dataset$datetime))
    test_dataset["season"] <- as.character()
    test_dataset[test_dataset$month >= 3 & test_dataset$month <= 5, "season"] <- "1"
    test_dataset[test_dataset$month >= 6 & test_dataset$month <= 8, "season"] <- "2"
    test_dataset[test_dataset$month >= 9 & test_dataset$month <= 11, "season"] <- "3"
    test_dataset[test_dataset$month == 12 | test_dataset$month <= 2, "season"] <- "4"

    # Collect feature data('Temperature', 'Windspeed', 'humidity', 'Rainfall') from weather dataset(2013.01.01 ~ 2014.12.31)
    weather2015 <- weather[year(weather$Datetime) == 2015, ]
    feature_weather <- weather2015[, c("Datetime", "Temperature", "WindSpeed", "Humidity", "Rainfall")]
    colnames(feature_weather) <- c("datetime", "Temperature", "Windspeed", "Humidity", "Rainfall")
    feature_weather["datetime"] <- as_datetime(feature_weather$datetime, tz = "EST")

    # Collect rental history on 'station_number' station.
    tashu2015 <- tashu[year(tashu$RENT_DATE) == 2015, ]
    rental_history <- tashu2015[tashu2015$RENT_STATION == station_number, ]

    # Compute hourly rental count
    rental_history <- data.frame(table(rental_history$RENT_DATE))
    colnames(rental_history) <- c("datetime", "rentcount")
    rental_history["datetime"] <- as.POSIXct(rental_history$datetime, tz = "EST")
    rental_history["datetime"] <- floor_date(rental_history$datetime, "hour")
    rental_history <- rental_history %>% group_by(datetime) %>% summarise(rentcount = n())

    # Add trainDataset to weather data and rental count
    test_dataset <- left_join(test_dataset, feature_weather)
    test_dataset <- left_join(test_dataset, rental_history)

    # replace NA on Rainfall, Snowfall to 0
    test_dataset[is.na(test_dataset)] <- 0

    return(test_dataset)
}
