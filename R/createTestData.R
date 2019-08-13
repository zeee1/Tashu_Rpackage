

#' Create testing data frame for prediction.
#'
#' Create testing data frame in 'stationNum' bike station by preprocessing bike rental history, weather and festival data in 2015.
#'
#' @param stationNum number that means the number of each station.(1 ~ 144)
#' @return a data frame that contains test Data in 'stationNum' station, 2015
#' columns : datetime, season, rentMonth, rentHour, rentWeekday, temperature, humidity, rainfall, isFestival, RrentCount(Real number of rental), PrentCount(NA, Predictive number of rental would be filled)
#' @export
#' @importFrom lubridate ymd_hms wday hours month hour
#' @importFrom utils globalVariables
#' @examples
#' \dontrun{
#' testData <- createTestData(1)
#' }
#'

createTestData <- function(stationNum) {
  testDataset <- data.frame(datetime = seq(as_datetime("2015/01/01 00:00:00", tz='EST'), as_datetime("2015/12/31 23:00:00",tz='EST'), "hours"))

  # Add feature columns('hour', 'month', 'weekday', 'season') to trainDataset
  testDataset['hour'] <- as.character(hour(testDataset$datetime))
  testDataset['month'] <- as.character(month(testDataset$datetime))
  testDataset['weekday'] <- as.character(wday(testDataset$datetime))
  testDataset['season'] <- as.character()
  testDataset[testDataset$month >= 3 & testDataset$month <=5, 'season'] <- "1"
  testDataset[testDataset$month >= 6 & testDataset$month <=8, 'season'] <- "2"
  testDataset[testDataset$month >= 9 & testDataset$month <=11, 'season'] <- "3"
  testDataset[testDataset$month == 12 | testDataset$month <=2, 'season'] <- "4"

  # Collect feature data('Temperature', 'Windspeed', 'humidity', 'Rainfall') from weather dataset(2013.01.01 ~ 2014.12.31)
  weather2015Data <- weather[year(weather$Datetime) == 2015,]
  feature_weatherData <- weather2015Data[, c("Datetime", "Temperature", "WindSpeed", "Humidity", "Rainfall")]
  colnames(feature_weatherData) <- c("datetime", "Temperature", "Windspeed", "Humidity", "Rainfall")
  feature_weatherData['datetime'] <- as_datetime(feature_weatherData$datetime, tz = 'EST')

  # Collect rental history on 'stationNumber' station.
  tashu2015 <- tashu[year(tashu$RENT_DATE) == 2015,]
  rentalHistory <- tashu2015[tashu2015$RENT_STATION == stationNumber,]

  # Compute hourly rental count
  rentalHistory <- data.frame(table(rentalHistory$RENT_DATE))
  colnames(rentalHistory) <- c("datetime", "rentcount")
  rentalHistory['datetime'] <- as.POSIXct(rentalHistory$datetime, tz='EST')
  rentalHistory['datetime'] <- floor_date(rentalHistory$datetime, "hour")
  rentalHistory <- rentalHistory %>% group_by(datetime) %>% summarise(rentcount=n())

  # Add trainDataset to weather data and rental count
  testDataset <- left_join(testDataset, feature_weatherData)
  testDataset <- left_join(testDataset, rentalHistory)

  # replace NA on Rainfall, Snowfall to 0
  testDataset[is.na(testDataset)] <- 0

  return(testDataset)
}


