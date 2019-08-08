#' Create training dataset for prediction on specific Station
#'
#' Create training data frame in 'stationNum' bike station by preprocessing bike rental history and weather data from 2013 to 2014.
#'
#' @param stationNumber number that means the number of each station.(1 ~ 144)
#' @return a dataset that present hourly amount of bike rental in 'stationNumber' station from 2013 to 2014.
#' columns: datetime, season, month, hourm, day of week, temperature, humidity, rainfall, rental count
#' @export
#' @importFrom lubridate ymd_hms wday hours month hour ymd_hm year

create_train_data <- function(stationNumber){
  trainDataset <- data.frame(datetime = seq(as_datetime("2013/01/01 00:00:00", tz='EST'), as_datetime("2014/12/31 23:00:00",tz='EST'), "hours"))

  # Add feature columns('hour', 'month', 'weekday', 'season') to trainDataset
  trainDataset['hour'] <- as.character(hour(trainDataset$datetime))
  trainDataset['month'] <- as.character(month(trainDataset$datetime))
  trainDataset['weekday'] <- as.character(wday(trainDataset$datetime))
  trainDataset['season'] <- as.character()
  trainDataset[trainDataset$month >= 3 & trainDataset$month <=5, 'season'] <- "1"
  trainDataset[trainDataset$month >= 6 & trainDataset$month <=8, 'season'] <- "2"
  trainDataset[trainDataset$month >= 9 & trainDataset$month <=11, 'season'] <- "3"
  trainDataset[trainDataset$month == 12 | trainDataset$month <=2, 'season'] <- "4"

  # Collect feature data('Temperature', 'Windspeed', 'humidity', 'Rainfall') from weather dataset(2013.01.01 ~ 2014.12.31)
  feature_weatherData <- weather20132014Data[, c("Datetime", "Temperature", "Windspeed", "Humidity", "Rainfall")]
  colnames(feature_weatherData) <- c("datetime", "Temperature", "Windspeed", "Humidity", "Rainfall")
  feature_weatherData['datetime'] <- as_datetime(feature_weatherData$datetime, tz = 'EST')

  # Collect rental history on 'stationNumber' station.
  rentalHistory <- tashu20132014Data[tashu20132014Data$RENT_STATION == i_station,]

  # Compute hourly rental count
  rentalHistory <- data.frame(table(rentalHistory$rentDateTime))
  colnames(rentalHistory) <- c("datetime", "rentcount")
  rentalHistory['datetime'] <- as.POSIXct(rentalHistory$datetime, tz='EST')

  # 학습 데이터에 기상 데이터, 대여 수 추가
  trainDataset <- left_join(trainDataset, feature_weatherData)
  trainDataset <- left_join(trainDataset, rentalHistory)

  # NA 값으로 표기된 강수량, 대여 수 0으로 치환
  trainDataset[is.na(trainDataset)] <- 0

  trainDataset$rentcount <- trainDataset$rentcount+1

  return(trainDataset)
}
