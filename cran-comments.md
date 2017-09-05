## Test environments
* local OS X install, R 3.4.1
* ubuntu 12.04 (on travis-ci), R 3.4.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 2 note

There were 2 NOTEs on win-builder:

* checking installed package size ... NOTE
  installed size is 66.0Mb
  sub-directories of 1Mb or more:
    data  65.8Mb
    
  This package provides long-term bicycle rental history data, weather and festival data. - Weather, festival information is expected to affect bicycle usage. You can use these data to analyze citizens' bicycle usage patterns in more detail.
    
* checking CRAN incoming feasibility ... NOTE

Possibly mis-spelled words in DESCRIPTION:
  Daejeon (4:17, 8:60)
  
  Daejeon is name of city that operates Tashu system. 

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

* I have run R CMD check on the NUMBER downstream dependencies.
  (Summary at ...). 
  
* FAILURE SUMMARY

* All revdep maintainers were notified of the release on RELEASE DATE.
