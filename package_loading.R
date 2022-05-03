# PACKAGES CAN BE FOUND HERE: https://cran.r-project.org/web/views/


# loading a package must be done after installation
# can be done in terminal (show below)
# or by selecting/unselecting boxes in "Packages" (right hand pane)

# loading a package
# can use: library(pkgname) or require(pkgname); library is standard
library(coefplot)

# quietly arguement hides loading of dependencies if == TRUE
library(coefplot, quietly=FALSE)

# output: Loading required package: ggplot2

# unloading a package
detach("package:coefplot")

# if ambiguity exists between package names precede the function with the name
# of the package, separated by two colonss (::)
# arm::coefplot(object)
# coefplot::coefplot(object)