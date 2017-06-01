#' Predict hourly Demand of Bike in 2015.
#'
#' @param stationNum A number from 1 to 144
#' @param isImportance if TRUE, visualize the ranking of Feature importance.
#' @param numOfNtree random Forest Ntree number
#' @param type if 0, classification. if 1, regression
#' @examples
#' predictDemandOfBikesUsingRF(3, TRUE, 50, 1)

predictDemandOfBikesUsingRF <- function(stationNum, isImportance, numOfNtree, type) {
    # trainData :
    trainData <- get(paste("station_", toString(stationNum), "_rentTrainDF", sep = "", collapse = NULL))

    # testData :
    testData <- get(paste("station_", toString(stationNum), "_rentTestDF", sep = "", collapse = NULL))

    monthList <- unique(trainData$rentMonth)
    monthList <- monthList[!is.na(monthList)]

    if (length(levels(testData$isFestival)) == 1) {
        levels(testData$isFestival) <- levels(trainData$isFestival)
    }

    if (type == 0) {
        # randomForest classification
        rfModel <- randomForest(as.factor(rentCount) ~ season + rentMonth + rentHour + rentWeekday + temperature + humidity + rainfall + isFestival, data = trainData, ntree = numOfNtree,
            importance = isImportance)

        for (i_month in monthList) {
            locs <- testData$rentMonth == i_month
            monthlySubsetData <- testData[locs, ]
            monthlySubsetData$rentCount <- monthlySubsetData$RrentCount

            testData[locs, "PrentCount"] <- predict(rfModel, extractFeatures(monthlySubsetData))
        }

        assign(paste("station_", toString(stationNum), "_TestDF", sep = "", collapse = NULL), testData)
        # write.csv(testData, file = paste('station',toString(stationNum),'_rf_classification_result.csv',sep = '', collapse = NULL), row.names = F)

    } else {
        # randomForest regression
        rfModel <- randomForest(extractFeatures(trainData), trainData$rentCount, ntree = numOfNtree, importance = isImportance)
        for (i_month in monthList) {
            locs <- testData$rentMonth == i_month
            monthlySubsetData <- testData[locs, ]

            testData[locs, "PrentCount"] <- predict(rfModel, extractFeatures(monthlySubsetData))
        }

        assign(paste("station_", toString(stationNum), "_TestDF", sep = "", collapse = NULL), testData)
        # write.csv(testData, file = paste('station',toString(stationNum),'_rf_regression_result.csv',sep = '', collapse = NULL), row.names = F)
    }

    if (isImportance == TRUE) {
        imp <- importance(rfModel, type = 1)
        featureImportance <- data.frame(Feature = row.names(imp), Importance = imp[, 1])

        ggplot(featureImportance, aes(x = reorder(Feature, Importance), y = Importance)) + geom_bar(stat = "identity", fill = "#53cfff") + coord_flip() + theme_light(base_size = 20) +
            xlab("Importance") + ylab("") + ggtitle("Random Forest Feature Importance\n") + theme(plot.title = element_text(size = 18))
    }
}
