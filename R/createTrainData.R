

#' Create training Data for prediction In Station stationNum.
#'
#' Create training data frame in 'stationNum' bike station by preprocessing bike rental history, weather and festival data from 2013 to 2014.
#'
#' @param stationNum number that means the number of each station.(1 ~ 144)
#' @return a data frame that present hourly amount of bike rental in 'stationNum' station from 2013 to 2014.
#' columns: datetime, season, month, hourm, day of week, temperature, humidity, rainfall, festival, rental count
#' @export
#' @importFrom lubridate ymd_hms wday hours month hour ymd_hm year
#' @examples
#' \dontrun{
#' trainData <- createTrainData(1)
#' }
#'

createTrainData <- function(stationNum) {
    rentSubsetInTrain <- tashuDataFor3year[tashuDataFor3year$RENT_STATION == stationNum, ]

    # rent_TrainDF(datetime, season, rentMonth, rentHour, rentWeekday, temperature, humidity, rainfall, isFestival, rentCount) datetime : hourly date +
    # timestamp(2013.01.01 00:00 ~ 2014.12.31 23:00) season : season Of datetime(1 = spring, 2 = summer, 3 = fall, 4 = winter) rentMonth : month of
    # datetime(1 ~ 12) rentHour: hour of datetime(0 ~ 23) rentWeekday : day Of Week of datetime(Mon, Tues, Wed, Thur, Fri, Sat, Sun) temperature
    # humidity rainfall isFestival : if there was a Festival near stationNum th station in datetime, it would be 1. otherwise, 0 rentCount : number of
    # rentals in stationNum th station.
    rent_TrainDF <- data.frame(datetime = as.Date(character()), season = character(), rentMonth = character(), rentHour = character(), rentWeekday = character(),
        temperature = integer(), humidity = integer(), rainfall = integer(), isFestival = character(), rentCount = integer())

    # Datetime range from 2013.01.01 00:00 to 2014.12.31 23:00
    startDateTime <- ymd_hm(201301010000)
    endDateTime <- ymd_hm(201412312300)
    currentDateTime <- startDateTime

    # Create Train data frame from 2013.01.01 00:00 to 2014.12.31 23:00
    while (currentDateTime <= endDateTime) {
        nextDateTime <- currentDateTime + hours(1)

        # Collect rental Data that occurred between currentDateTime and nextDateTime.
        rentTimeSubset <- rentSubsetInTrain[rentSubsetInTrain$RENT_DATE >= currentDateTime & rentSubsetInTrain$RENT_DATE < nextDateTime, ]

        weatherSubset <- data.frame()

        if (year(currentDateTime) == 2013) {
            weatherSubset <- weather2013[weather2013$Datetime == currentDateTime, ]
        }
        if (year(currentDateTime) == 2014) {
            weatherSubset <- weather2014[weather2014$Datetime == currentDateTime, ]
        }

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

        rent_TrainDF <- rbind(rent_TrainDF, data.frame(datetime = currentDateTime, season = season, rentMonth = toString(month(currentDateTime)), rentHour = toString(hour(currentDateTime)),
            rentWeekday = wday(currentDateTime, label = TRUE), temperature = weatherSubset$Temperature, humidity = weatherSubset$Humidity, rainfall = weatherSubset$Rainfall,
            isFestival = isFestival, rentCount = NROW(rentTimeSubset)))

        currentDateTime <- nextDateTime
    }

    return(rent_TrainDF)
}


