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
#' testData <- createTestData(1)

utils::globalVariables('tashu2015')
createTestData <- function(stationNum) {
    rentSubsetInTest <- tashu2015[tashu2015$RENT_STATION == stationNum, ]

    # rent_TestDF(datetime, season, rentMonth, rentHour, rentWeekday, temperature, humidity, rainfall, isFestival, RrentCount, PrentCount) datetime :
    # hourly date + timestamp(2013.01.01 00:00 ~ 2014.12.31 23:00) season : season Of datetime(1 = spring, 2 = summer, 3 = fall, 4 = winter) rentMonth
    # : month of datetime(1 ~ 12) rentHour: hour of datetime(0 ~ 23) rentWeekday : day Of Week of datetime(Mon, Tues, Wed, Thur, Fri, Sat, Sun)
    # temperature humidity rainfall isFestival : if there was Festival near stationNum th station in datetime, it would be 1. otherwise, 0 RrentCount :
    # number of rentals in stationNum th station.  PrentCount : predictive number of rentals in stationNum th station.
    rent_TestDF <- data.frame(datetime = as.Date(character()), season = character(), rentMonth = character(), rentHour = character(), rentWeekday = character(),
        temperature = integer(), humidity = integer(), rainfall = integer(), isFestival = character(), RrentCount = integer(), PrentCount = integer())


    startDateTime <- ymd_hms(20150101000000)
    endDateTime <- ymd_hms(20151231230000)
    currentDateTime <- startDateTime

    # Create Test data frame in 2015
    while (currentDateTime <= endDateTime) {
        nextDateTime <- currentDateTime + hours(1)

        rentTimeSubset <- rentSubsetInTest[rentSubsetInTest$RENT_DATE >= currentDateTime & rentSubsetInTest$RENT_DATE < nextDateTime, ]

        weatherSubset <- weather2015[weather2015$Datetime == currentDateTime, ]

        if (is.na(weatherSubset$Rainfall)) {
            weatherSubset$Rainfall <- 0
        }

        season <- "0"

        currentMonth <- month(currentDateTime)

        if (currentMonth >= 3 && currentMonth < 6) {
            season <- "1"  #spring
        }
        if (currentMonth >= 6 && currentMonth < 9) {
            season <- "2"  #summer
        }
        if (currentMonth >= 9 && currentMonth < 12) {
            season <- "3"  #fall
        }
        if (currentMonth >= 11 || currentMonth < 3) {
            season <- "4"  #winter
        }

        isFestival <- "0"
        tmpFestData <- festivalData[festivalData$startDate <= currentDateTime & festivalData$endDate > currentDateTime, ]
        nearStatList <- strsplit(tmpFestData$nearStation, ",")

        for (i in nearStatList) {
            if (toString(stationNum) %in% i) {
                isFestival <- "1"
            }
        }

        rent_TestDF <- rbind(rent_TestDF, data.frame(datetime = currentDateTime, season = season, rentMonth = toString(month(currentDateTime)), rentHour = toString(hour(currentDateTime)),
            rentWeekday = wday(currentDateTime, label = TRUE), temperature = weatherSubset$Temperature, humidity = weatherSubset$Humidity, rainfall = weatherSubset$Rainfall,
            isFestival = isFestival, RrentCount = NROW(rentTimeSubset), PrentCount = NA))


        currentDateTime <- nextDateTime
    }

    return(rent_TestDF)
}


