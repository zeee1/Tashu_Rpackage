#' Bike rental history on public bicycle system("Tashu") from 2013 to 2015.
#'
#' A dataset which is bike rental history(rent station, rent date, return station, return date).
#'
#' @format A data frame with 3394159 rows and 4 variables:
#' \describe{
#'   \item{RENT_STATION}{station Number where bike was rented.}
#'   \item{RENT_DATE}{date time when bike was rented. yyyy-mm-dd hh:mm:ss}
#'   \item{RETURN_STATION}{station Number where bike was returned.}
#'   \item{RETURN_DATE}{date time when bike was returned. yyyy-mm-dd hh:mm:ss}
#' }
"tashu"

#' Bike station data on Tashu.
#'
#' A dataset about 144 bike stations.
#'
#' @format A data frame with 144 rows and 4 variables:
#' \describe{
#'   \item{NUM}{station Number}
#'   \item{NumOFBIKE_RACK}{the number of bike rack}
#'   \item{GEODATA_lat}{latitude of bike station}
#'   \item{GEODATA_lon}{longitude of bike station}
#' }
"tashuStation"

#' weather data in Daejeon, South Korea, from 2013 to 2015
#'
#' A dataset containing hourly weather data in Daejeon, 2013 ~ 2015
#'
#' @format A data frame with 26280 rows and 18 variables:
#' \describe{
#'   \item{Datetime}{date time}
#'   \item{Temperature}{Temperature}
#'   \item{Rainfall}{Rainfall}
#'   \item{WindSpeed}{Wind Speed(m/s)}
#'   \item{WindDirection}{Wind Direction}
#'   \item{Humidity}{Humidity}
#'   \item{VaporPressure}{Vapor Pressure(hpa)}
#'   \item{DewpointTemperature}{Dew point temperature(°C)}
#'   \item{LocalPressure}{Local Pressure(hpa)}
#'   \item{SeaSurfacePressure}{Sea Surface Pressure(hpa)}
#'   \item{Sunshine}{sun shine(hr)}
#'   \item{SolarRadiation}{solar radiation(MJ/m2)}
#'   \item{Snowfall}{snow fall(cm)}
#'   \item{GroundTemperature}{ground temperature(°C)}
#'   \item{X5cmGroundTemperature}{ground temperature(°C)}
#'   \item{X10cmGroundTemperature}{ground temperature(°C)}
#'   \item{X20cmGroundTemperature}{ground temperature(°C)}
#'   \item{X30cmGroundTemperature}{ground temperature(°C)}
#' }
"weather"
