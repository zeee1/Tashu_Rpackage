## Test environments
* local OS X install, R 3.4.0
* ubuntu 12.04 (on travis-ci), R 3.4.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
There was 1 NOTE:

* checking R code for possible problems ... NOTE
  getAmountOfRentalEachDayOfWeek: no visible binding for global variable
  'Var2'
  getAmountOfRentalEachDayOfWeek: no visible binding for global variable
  'Var1'
  getAmountOfRentalEachDayOfWeek: no visible binding for global variable
  'value'
  getAmountOfRentalEachMonth: no visible binding for global variable
  'ratio'
  getTop10Pathes: no visible binding for global variable 'RENT_STATION'
  getTop10Pathes: no visible binding for global variable 'RETURN_STATION'
  getTop10Pathes: no visible binding for global variable 'COUNT'
  getTop10Stations: no visible binding for global variable 'station_no'
  getTop10Stations: no visible binding for global variable 'total_cnt'
  predictDemandOfBikesUsingRF: no visible binding for global variable
  'Feature'
  predictDemandOfBikesUsingRF: no visible binding for global variable
  'Importance'
  Undefined global functions or variables:
  COUNT Feature Importance RENT_STATION RETURN_STATION Var1 Var2 ratio
  station_no total_cnt value
  
  The variables mentioned above were name of data frame column.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

* I have run R CMD check on the NUMBER downstream dependencies.
  (Summary at ...). 
  
* FAILURE SUMMARY

* All revdep maintainers were notified of the release on RELEASE DATE.
