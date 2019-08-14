#' Create training dataset on specific station for prediction
#'
#' A function to create training dataset on 'station_number' bike station by preprocessing bike rental history and weather data from 2013 to 2014.
#'
#' @param station_number number that means the number of each station.(1 ~ 144)
#' @return a dataset containing feature and rental count data on 'station_number' station, 2013 ~ 2014
#' @export
#' @import lubridate
#' @importFrom lubridate hour month wday year floor_date
#' @importFrom dplyr summarise group_by left_join
#' @example
#' train_dataset <- create_train_dataset(1)
#'

create_train_dataset <- function(station_number) {
  if(station_number < 1 || station_number > 144){
    stop("Station number should be from 1 to 144. Please re-Input station number.", call. = FALSE)
  }

    train_dataset <- data.frame(
      datetime = seq(as_datetime("2013/01/01 00:00:00", tz = "EST"),
                     as_datetime("2014/12/31 23:00:00", tz = "EST"),
                     "hours"))

    # Add feature columns('hour', 'month', 'weekday', 'season') to train_dataset
    train_dataset["hour"] <- as.character(hour(train_dataset$datetime))
    train_dataset["month"] <- as.character(month(train_dataset$datetime))
    train_dataset["weekday"] <- as.character(wday(train_dataset$datetime))
    train_dataset["season"] <- as.character()
    train_dataset[train_dataset$month >= 3 & train_dataset$month <= 5, "season"] <- "1"
    train_dataset[train_dataset$month >= 6 & train_dataset$month <= 8, "season"] <- "2"
    train_dataset[train_dataset$month >= 9 & train_dataset$month <= 11, "season"] <- "3"
    train_dataset[train_dataset$month == 12 | train_dataset$month <= 2, "season"] <- "4"

    # Collect feature data('Temperature', 'Windspeed', 'humidity', 'Rainfall') from weather dataset(2013.01.01 ~ 2014.12.31)
    weather20132014 <- weather[year(weather$Datetime) < 2015, ]
    feature_weather <- weather20132014[, c("Datetime", "Temperature", "WindSpeed", "Humidity", "Rainfall")]
    colnames(feature_weather) <- c("datetime", "Temperature", "Windspeed", "Humidity", "Rainfall")
    feature_weather["datetime"] <- as_datetime(feature_weather$datetime, tz = "EST")

    # Collect rental history on 'station_number' station.
    tashu20132014 <- tashu[year(tashu$RENT_DATE) < 2015, ]
    rental_history <- tashu20132014[tashu20132014$RENT_STATION == station_number, ]

    # Compute hourly rental count
    rental_history <- data.frame(table(rental_history$RENT_DATE))
    colnames(rental_history) <- c("datetime", "rentcount")
    rental_history["datetime"] <- as.POSIXct(rental_history$datetime, tz = "EST")
    rental_history["datetime"] <- floor_date(rental_history$datetime, "hour")
    rental_history <- rental_history %>% group_by(datetime) %>% summarise(rentcount = n())

    # Add train_dataset to weather data and rental count
    train_dataset <- left_join(train_dataset, feature_weather)
    train_dataset <- left_join(train_dataset, rental_history)

    # replace NA on Rainfall, Snowfall to 0
    train_dataset[is.na(train_dataset)] <- 0

    return(train_dataset)
}
