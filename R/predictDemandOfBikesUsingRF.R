#' Predict hourly Demand of Bike in 2015.
#'
#' predict hourly amount of bike rental in 2015 using random forest algorithm. Create prediction model using 'trainData' and forecast demand of bike rental according to the condition of 'testData'
#'
#' @param trainData training data for creating prediction model
#' @param testData testing data.
#' @param numOftree number of tree in random Forest
#' @return testData with predictive result.
#' @export
#' @importFrom randomForest importance randomForest
#' @importFrom stats predict reorder
#' @examples
#' \dontrun{
#' trainData <- createTrainData(3)
#' testData <- createTestData(3)
#' predictDemandOfBikesUsingRF(trainData, testData, numOftree = 50)
#' }
#'

predictDemandOfBikesUsingRF <- function(trainData, testData, numOftree = 50) {
    monthList <- unique(trainData$rentMonth)
    monthList <- monthList[!is.na(monthList)]

    if (length(levels(testData$isFestival)) == 1) {
        levels(testData$isFestival) <- levels(trainData$isFestival)
    }

    # randomForest regression
    rfModel <- randomForest(extractFeatures(trainData), trainData$rentCount, ntree = numOftree)
    for (i_month in monthList) {
      locs <- testData$rentMonth == i_month
      monthlySubsetData <- testData[locs, ]

      testData[locs, "PrentCount"] <- predict(rfModel, extractFeatures(monthlySubsetData))
    }

    return(testData)
}

#' extract features in test data frame.
#'
#' extract feature data from test Data.
#' feature : season, month, hour, day of week, temperature, humidity, rainfall, affect of festival.
#'
#' @param data testing data frame for prediction. Testing data frame is created by conducting createTestData()

extractFeatures <- function(data) {
    features <- c("season", "rentMonth", "rentHour", "rentWeekday", "temperature", "humidity", "rainfall", "isFestival")

    return(data[, features])
}

