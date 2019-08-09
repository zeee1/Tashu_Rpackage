#' Visualize the change of amount of bicycle rental by Temperature.
#'
#' This function draw a plot that show change of average temperature and average bike rental ratio in each month.
#'
#' @export
#' @import dplyr, lubridate
#' @examples
#' monthlyBikeRental()

monthlyBikeRental <- function() {

    tashu$month <- month(tashu$RENT_DATE)
    rentalAmountBymonth <- summarise(group_by(tashu, month), RENT_COUNT=n())
    rentalAmountBymonth$ratio <- rentalAmountBymonth$RENT_COUNT/sum(rentalAmountBymonth$RENT_COUNT)*100
    weather$month <- month(weather$Datetime)
    temperatureBymonth <- summarise(group_by(weather, month), temperature = mean(Temperature))

    par(mar=c(5,5,5,5))

    plot(temperatureBymonth$month, temperatureBymonth$temperature, axes = FALSE,
         ylim = c(0, 30), pch = 16, type = "b", xlab = "", ylab = "", col = "blue", main = "The monthly average temperature and rental")
    # Draw month axis
    axis(1, temperatureBymonth$month)
    mtext("Month", side = 1, col = "black", line = 2.5)

    # Draw temperature axis
    axis(2, ylim = c(0, 30), las = 1)
    mtext("Average temperature(Celsius)", side = 2, line = 2.5)

    # Allow a second plot on the same graph
    par(new = TRUE)

    plot(rentalAmountBymonth$month, rentalAmountBymonth$ratio, xlab = "", ylab = "", ylim = c(0, 15), pch = 15, axes = FALSE, type = "b", col = "red")

    # Draw rental ratio axis
    axis(4, ylim = c(0, 15), col = "black", las = 1)
    mtext("Ratio of Bike Rental(%)", side = 4, line = 2.5)


    #op <- par(cex = 1)
    legend("topright",cex=0.8, legend = c("Average Temperature", "Ratio of Bike Rental"), text.col = c("blue", "red"), pch = c(16, 15), col = c("blue", "red"))
}
