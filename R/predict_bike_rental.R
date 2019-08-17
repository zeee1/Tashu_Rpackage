#' Predict hourly Demand of Bike in 2015.
#'
#' predict hourly amount of bike rental in 2015 using random forest algorithm. Create prediction model using 'train_dataset' and forecast demand of bike rental according to the condition of 'test_dataset'
#'
#' @param train_dataset training data for creating prediction model
#' @param test_dataset testing data.
#' @param numOftree number of tree in random Forest
#' @return test_dataset with predictive result.
#' @export
#' @importFrom stats predict
#' @examples
#' train_dataset <- createtrain_dataset(3)
#' test_dataset <- createtest_dataset(3)
#' predictDemandOfBikesUsingRF(train_dataset, test_dataset, numOftree = 50)
#'

extract_features <- function(data){
  features <- c ("hour", "month", "weekday", "season",
                 "Temperature", "Windspeed", "Humidity", "Rainfall")

  return(data[, features])
}

predict_bike_rental <- function(rf_model, test_dataset) {
    test_dataset$predicted_rent_count <- NA
    month_list <- c(1:12)
    month_list <- month_list[!is.na(month_list)]

    for (i_month in month_list) {
        locs <- test_dataset$month == i_month
        monthly_subset <- test_dataset[locs, ]

        test_dataset[locs, "PrentCount"] <- predict(rf_model, extract_features(monthly_subset))
    }

    return(test_dataset)
}


