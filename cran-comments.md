---
title: "cran-comments"
author: "Jiwon Min"
date: '2019 8 30 '
output: md_document
---

## Test environment
* local Mac OS install, R 3.5.3
* ubuntu 16.04 (on travis-ci), R 3.5.3
* win-builder (devel and release)


## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* checking package dependencies ... NOTE
  Package suggested but not available for checking: 'tashudata'
  
This package suggests a package which is not non-mainstream repository (a drat repository). On the Windows build, this results in two NOTES, the NOTE "Package suggested but not available for checking" as well as a note for "Suggests or Enhances not in mainstream repositories".
