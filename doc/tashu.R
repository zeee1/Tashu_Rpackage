## ----echo = FALSE--------------------------------------------------------
tashudata_installed <- requireNamespace("tashudata", quietly=TRUE)
if (!tashudata_installed) {
    knitr::opts_chunk$set(eval = FALSE)
    msg <- paste("Examples in this vignette can be executed when", 
                 "'tashudata' package be installed. ",
                 "This working environment don't have 'tashudata' package",
                 "All R code below would not be executed normally.",
                 "Please Use this package after installing 'tashudata' package.")
    msg <- paste(strwrap(msg), collapse="\n")
    message(msg)
}

## ----echo = FALSE, message = FALSE, warning = FALSE----------------------
library(tashudata)
library(tashu)

## ----eval=FALSE----------------------------------------------------------
#  library(devtools)
#  devtools::install_github("zeee1/Tashu_Rpackage")

## ----eval=FALSE----------------------------------------------------------
#  library(drat)
#  addRepo("zeee1")
#  install.packages("tashudata")

## ------------------------------------------------------------------------
head(tashudata::tashu, n = 5)

## ------------------------------------------------------------------------
head(tashudata::tashuStation, n = 5)

## ------------------------------------------------------------------------
head(tashudata::weather, n = 5)

## ---- fig.width=7,fig.height=5-------------------------------------------
top10_stations()

## ---- fig.width=7,fig.height=5-------------------------------------------
top10_paths()

## ---- fig.width=7,fig.height=5-------------------------------------------
daily_bicycle_rental()

## ---- fig.width=7,fig.height=5-------------------------------------------
monthly_bicycle_rental()

## ------------------------------------------------------------------------
train_dataset <- create_train_dataset(1)
head(train_dataset, n = 5)

## ------------------------------------------------------------------------
test_dataset <- create_test_dataset(1)
head(test_dataset, n = 5)

## ------------------------------------------------------------------------
rf_model <- create_train_model(train_dataset)

## ------------------------------------------------------------------------
predict_result <- predict_bicycle_rental(rf_model, test_dataset)
head(predict_result, n = 5)

