my_packages <- c("highcharter")
not_installed <-  my_packages[!(my_packages %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed)
