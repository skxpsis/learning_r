# ========================== apply =============================================
# will iterate over each row/col of matrix, treating them as indvidual inputs
# to the first argument of the specified function
# must be used on a matrix -- all elements must be of the same type
# 3 args: object we are working with, margin to apply over (1 for rows, 
# 2 for columns), function we want to apply

# build the matrix
theMatrix <- matrix(1:9, nrow=3)
# sum the rows
apply(theMatrix, 1, sum)
# sum the columns
apply(theMatrix, 2, sum)
# easier way: built in rowSums, colSums
rowSums(theMatrix)
colSums(theMatrix)

# handling NAs
theMatrix[2,1] <- NA
apply(theMatrix, 1, sum)
# output: 12 NA 18
apply(theMatrix, 1, sum, na.rm=TRUE)
rowSums(theMatrix)
colSums(theMatrix, na.rm=TRUE)

# ======================= lapply, sapply =======================================
# works by applying a function to each element of a list and returning the
# results as a list
theList <- list(A=matrix(1:9, 3), B=1:5, C=matrix(1:4, 2), D=2)
lapply(theList, sum)
# to return result as vector instead of list, use sapply (preferred)
t = sapply(theList, sum)
t

# lapply and sapply can also take a vector as their input since a vector is
# technically a form of a list
theNames <- c("Jared", "Deb", "Paul")
lapply(theNames, nchar)

# ====================== mapply ================================================
# applies a function to each element of a multiple lists
# eliminates need for looping
firstList <- list(A=matrix(1:16, 4), B=matrix(1:16, 2), C=1:5)
secondList <- list(A=matrix(1:16, 4), B=matrix(1:16, 8), C=15:1)
mapply(identical, firstList, secondList)

simpleFunc <- function(x, y)
{
  NROW(x) + NROW(y)
}
mapply(simpleFunc, firstList, secondList)

# ======================= other apply functions ================================
# tapply, rapply, eapply, vapply, by
# those superceded by plyr, dplyr, and purrr


# ======================= aggregate ============================================
# like SQL aggregate/group by
library(ggplot2)
data(diamonds, package='ggplot2')
head(diamonds)
# calculate avg price by cut
aggregate(price ~ cut, diamonds, mean, na.rm=TRUE)
# group data (after the ~) by 1+ variable
aggregate(price ~ cut + color, diamonds, mean, na.rm=TRUE)
# to aggregate 2 variables (before the ~)
aggregate(cbind(price, carat) ~ cut, diamonds, mean, na.rm=TRUE)
aggregate(cbind(price, carat) ~ cut + color, diamonds, mean, na.rm=TRUE)

# ====================== plyr ==================================================
# has various packages available

# ======== ddply =======
# takes a data.frame, splits it according to some variable(s), performs a
# desired action on it and returns a data.frame
# see page 136 for examples
library(plyr)
head(baseball)
baseball$sf[baseball$year < 1954] <- 0
any(is.na(baseball$sf))
baseball$hbp[is.na(baseball$hbp)] <- 0
any(is.na(baseball$hbp))
baseball <- baseball[baseball$ab >= 50, ]
baseball$OBP <- with[baseball, (h + bb + hbp) / (ab + bb + hbp + sf)]
tail(baseball)

# ======== llply =======
# sum each element of a list
theList <- list(A=matrix(1:9, 3), B=1:5, C=matrix(1:4, 2), D=2)
llply(theList, sum) # results as a list
laply(theList, sum) # results as a vector

# ======== helper functions ========
# with the each function, the only drawback is additional args can no longer be
# supplied to the functions
aggregate(price ~ cut, diamonds, each(mean, median))
# idata.frame creates reference to a data.frame so that subnetting is faster
system.time(dlply(baseball, "id", nrow))
# compare time
iBaseball <- idata.frame(baseball)
system.time(dlply(iBaseball, "id", nrow))

# ======== data.table ========
library(data.table)
# regular data.frame
theDF <- data.frame(A=1:10,
                    B=letters[1:10],
                    C=LETTERS[11:20],
                    D=rep(c("One", "Two", "Three"), length.out=10))
# data.table
theDT <- data.table(A=1:10,
                    B=letters[1:10],
                    C=LETTERS[11:20],
                    D=rep(c("One", "Two", "Three"), length.out=10))
theDF
theDT
class(theDF$B)
class(theDT$B)
# ?? something changed as 118 is not factor

# data.frame --> data.table; data.table only prints first 5 and last 5 rows
diamondsDT <- data.table(diamonds)
diamondsDT

# accessing rows in data.table
theDT[1:2, ]
theDT[theDT$A >= 7, ]
theDT[A >= 7, ]

#accessing individual columns 
theDT[, list(A, C)]

# accessing one column
theDT[, B]

# one column while maintaining data.table structure
theDT[, list(B)]

# specify column name as characters by with=FALSE
theDT[, "B", with=FALSE]
theDT[, c("A", "C"), with=FALSE]
theCols <- c("A", "C")
theDT[, theCols, with=FALSE]


# =========================== keys =============================================
# show tables -- shows all data.tables in memory
# name, nrows, size in megabytes, col names, and the key
# key is used to index data.table and will provide extra speed
# any blank fields in data.tables are left blank in tables() output

tables()
# set key args to set the key of a table: name of data.table, name of column
setkey(theDT,D)
theDT
# Data reordered according to column D, which is sorted alphabetically
# confirm key was set with key(data.table.name.here)
key(theDT)
tables()

# selecting rows by key value
theDT["One", ]
theDT[c("One", "Two"), ]

# more than one column can be set as the key
setkey(diamondsDT, cut, color)
diamondsDT[J("Ideal", "E"), ]
diamondsDT[J("Ideal", c("E", "D")), ]

# ====== data.table aggregation ======

# to get mean price of diamonds for each type of cut using data.table
diamondsDT[, mean(price), by=cut]

# specify the name of the resulting column, pass aggregation function as a list
diamondsDT[, list(price=mean(price)), by=cut]

# aggregate on multiple columns using list()
diamondsDT[, mean(price), by=list(cut, color)]

# to aggregate multiple arguments, pass them as a list
diamondsDT[, list(price=mean(price), carat=mean(carat)), by=cut]
diamondsDT[, list(price=mean(price), carat=mean(carat), caratSum=sum(carat)), by=cut]

# multiple metrics calculated and multiple grouping variables at the same time
diamondsDT[, list(price=mean(price), carat=mean(carat)), by=list(cut, color)]
