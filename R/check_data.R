.pkgenv <- new.env(parent=emptyenv())

.onLoad  <- function(libname, pkgname) {
  tashudata_installed <- requireNamespace("tashudata", quietly = TRUE)
  .pkgenv[["tashudata_installed"]] <- tashudata_installed
}

.onAttach <- function(libname, pkgname) {
  if (!.pkgenv$tashudata_installed) {
    msg <- paste("Before using this package, you must install the tashudata package('https://github.com/zeee1/tashudata').",
                 "You can install this package with,",
                 "`install.packages('tashudata',",
                 "repos='https://zeee1.github.io/drat/', type='source')`.")
    msg <- paste(strwrap(msg), collapse="\n")
    packageStartupMessage(msg)
  }
}

check_data <- function(tashudata_installed = .pkgenv$tashudata_installed) {
  if (!tashudata_installed) {
    msg <- paste("Before using this package, you must install the tashudata package('https://github.com/zeee1/tashudata').",
                 "You can install this package with,",
                 "`install.packages('tashudata',",
                 "repos='https://zeee1.github.io/drat/', type='source')`.",
                 "Detail installing way is on vignettes.")
    msg <- paste(strwrap(msg), collapse="\n")
    stop(msg)
  }
}
