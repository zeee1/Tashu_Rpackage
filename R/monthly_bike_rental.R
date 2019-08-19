#' Visualize the change of bicycle rental amount by temperature and each month.
#'
#' A function drawing a plot that shows change of temperature and bike rental ratio in each month.
#'
#' @export
<<<<<<< HEAD
#' @import dplyr lubridate graphics utils
#' @importFrom lubridate month
=======
#' @import dplyr lubridate graphics
#' @importFrom lubridate hour month wday year floor_date
>>>>>>> e89b06fa0ff79789322551af792eb2964f53ca5d
#' @importFrom dplyr summarise group_by left_join
#' @importFrom graphics par plot axis mtext legend
#' @examples
#' \dontrun{monthly_bike_rental()}

monthly_bike_rental <- function() {

    # Compute monthly rental ratio
    tashu$month <- month(tashu$RENT_DATE)
    rental_by_month <- tashu %>% group_by(month) %>% summarise(rentcount = n())
    rental_by_month$ratio <- rental_by_month$rentcount/sum(rental_by_month$rentcount) * 100

    # Compute monthly average temperature
    weather$month <- month(weather$Datetime)
    temperature_by_month <- weather %>%
      group_by(month) %>%
      summarise(temperature = mean(Temperature))

    par(mar = c(5, 5, 5, 5))

    plot(temperature_by_month$month,
         temperature_by_month$temperature,
         axes = FALSE,
         ylim = c(0, 30),
         pch = 16,
         type = "b",
         xlab = "",
         ylab = "",
         col = "blue",
        main = "The monthly average temperature and ratio of rental")
    # Draw month axis
    axis(1, temperature_by_month$month)
    mtext("Month", side = 1, col = "black", line = 2.5)

    # Draw temperature axis
    axis(2, ylim = c(0, 30), las = 1)
    mtext("Average temperature(Celsius)", side = 2, line = 2.5)

    # Allow a second plot on the same graph
    par(new = TRUE)

    plot(rental_by_month$month,
         rental_by_month$ratio,
         xlab = "", ylab = "",
         ylim = c(0, 15),
         pch = 15,
         axes = FALSE,
         type = "b",
         col = "red")

    # Draw rental ratio axis
    axis(4, ylim = c(0, 15), col = "black", las = 1)
    mtext("Ratio of Bike Rental(%)", side = 4, line = 2.5)

    # Draw legend information
    legend("topright", cex = 0.8,
           legend = c("Average Temperature", "Ratio of Bike Rental"),
           text.col = c("blue", "red"),
           pch = c(16, 15),
           col = c("blue","red"))
}

