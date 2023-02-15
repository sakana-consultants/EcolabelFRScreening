#---- General Housekeeping procedures ----
# 
# Housekeeping script
#
# Code written by: 
#         Sébastien Metz - Sakana Consultants
# Initial Code: June 2020
#

remove(list = ls(all.names = TRUE))

#---- Function detachAllPackages ----
#
# loading minimal list of packages

detachAllPackages <- function() {
  basic.packages.blank <-  c("stats",
                             "graphics",
                             "grDevices",
                             "utils",
                             "datasets",
                             "methods",
                             "base")
  basic.packages <-
    paste("package:", basic.packages.blank, sep = "")
  
  package.list <- 
    search()[
      ifelse(unlist(gregexpr("package:",
                             search())) == 1,
             TRUE,
             FALSE)]
  
  package.list <- setdiff(package.list, basic.packages)
  
  if (length(package.list) > 0)
    for (package in package.list) {
      detach(package, character.only = TRUE)
      print(paste("package ",
                  package,
                  " detached",
                  sep = ""))
    }
}

#---- Function attachPackages ----
#
# Attach a list of packages to the working environment

attachPackages <- function(package.list,
                           repository = "http://cran.us.r-project.org") {
  for (package in package.list) {
    if (!require(package,
                 character.only = TRUE)) {
      install.packages(package,
                       repos = repository)
      require(package,
              character.only = TRUE)
    }
  }
}

