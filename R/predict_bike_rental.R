#' Predict hourly Demand of Bike in 2015.
#'
#' predict hourly amount of bike rental in 2015 using random forest algorithm. Create prediction model using 'train_dataset' and forecast demand of bike rental according to the condition of 'test_dataset'
#'
#' @param rf_model random forest prediction model create by create_train_model()
#' @param test_dataset testing dataset
#' @return test_dataset with predictive result.
#' @export
#' @importFrom stats predict filter lag
#' @examples
#' \dontrun{train_dataset <- create_train_dataset(3)
#' test_dataset <- create_test_dataset(3)
#' rf_model <- create_train_model(train_dataset)
#' test_dataset <- predict_bike_rental(rf_model, test_dataset)}
#'


predict_bike_rental <- function(rf_model, test_dataset) {
  check_data()
    month_list <- c(1:12)
    month_list <- month_list[!is.na(month_list)]

    for (i_month in month_list) {
        locs <- test_dataset$month == i_month
        monthly_subset <- test_dataset[locs, ]

        test_dataset[locs, "predicted_rent_count"] <- predict(rf_model, extract_features(monthly_subset))
    }

    return(test_dataset)
}




