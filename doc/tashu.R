## ------------------------------------------------------------------------
head(tashudata::tashu, n = 5)

## ------------------------------------------------------------------------
head(tashudata::tashuStation, n = 5)

## ------------------------------------------------------------------------
head(tashudata::weather, n = 5)

## ---- fig.width=7,fig.height=8-------------------------------------------
library(tashu)
top10_stations()

## ---- fig.width=7,fig.height=8-------------------------------------------
library(tashu)
top10_paths()

## ---- fig.width=7,fig.height=8-------------------------------------------
library(tashu)
daily_bike_rental()

## ---- fig.width=7,fig.height=8-------------------------------------------
library(tashu)
monthly_bike_rental()

## ------------------------------------------------------------------------
library(tashu)
train_dataset <- create_train_dataset(1)
head(train_dataset, n = 5)

## ------------------------------------------------------------------------
library(tashu)
test_dataset <- create_test_dataset(1)
head(test_dataset, n = 5)

## ------------------------------------------------------------------------
library(tashu)
rf_model <- create_train_model(train_dataset)

## ------------------------------------------------------------------------
library(tashu)
predict_result <- predict_bike_rental(rf_model, test_dataset)
head(predict_result, n = 5)

