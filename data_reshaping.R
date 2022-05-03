# ================ CBIND/RBIND =================================================
# when we have two datasets with either identical columns (both the number of 
# and names of the columns) or the same number of rows

# create two data.frames by combining vectors with cbind then stack them using
# rbind
# make 3 vectors, combine as columns in a data.frame
sport <- c("Hockey", "Baseball", "Football")
league <- c("NHL", "MLB", "NFL")
trophy <- c("Stanley Cup", "Commissioner's Trophy", "Vince Lombardi Trophy")
trophies1 <- cbind(sport, league, trophy)
# make another data.frame using data.frame()
trophies2 <- data.frame(sport=c("Basketball", "Golf"),
                        league=c("NBA", "PGA"),
                        trophy=c("Larry O'Brien Championship Trophy",
                                 "Wanamaker Trophy"),
                        stringsAsFactors = FALSE)
# combine them into one data.frame with rbind
trophies <- rbind(trophies1, trophies2)
trophies
# can assign new column names to vectors in cbind
cbind(Sport=sport, Association=league, Prize=trophy)

# ================= JOINS ======================================================
# merge, join in plyr, merging functionality in data.table
# also shows how to download unzip a file into R
download.file(url="http://jaredlander.com/data/US_Foreign_Aid.zip",
              destfile="C:/Users/skxps/Documents/R/Learning R/data/ForeignAid.zip")
unzip("C:/Users/skxps/Documents/R/Learning R/data/ForeignAid.zip", exdir="data")

library(stringr)
theFiles <- dir("C:/Users/skxps/Documents/R/Learning R/data/", pattern="\\.csv")
# get a list of the files
for(a in theFiles)
{
  # build name to assign to the data
  nameToUse <- str_sub(string=a, start=12, end=18)
  # read in the csv using read.table
  # file.path is a convenient way to specify a folder and file name
  temp <- read.table(file=file.path("data", a),
                     header=TRUE, sep=",", stringsAsFactors = FALSE)
  # assign them into workspace
  assign(x=nameToUse, value=temp)
}

# ===== MERGE 2 data.frames =====
# merge 2 data.frames
Aid90s00s <- merge(x=Aid_90s, y=Aid_00s,
                   by.x=c("Country.Name", "Program.Name"),
                   by.y=c("Country.Name", "Program.Name"))
# by.x and by.y specify key column in left data.frame and right data.frame,
# respectively
head(Aid90s00s)

# ===== PLYR join =====
# join function in plyr class works similar to merge function, but is faster
# con: key columns in each table must have the same name
library(plyr)
Aid90s00sJoin <- join(x=Aid_90s, y=Aid_00s,
                      by=c("Country.Name", "Program.Name"))
head(Aid90s00sJoin)

# join has an argument for specifying a left, right, inner, or full (outer) join
# we have 8 data.frames containing foreign assistance data that we would like
# to combine into one df w/o handcoding each
# best way: put all dfs in a list, then successively join them together using
# Reduce

# figure out names of dfs, reconstruct them using sub_sub from stringr package
frameNames <- str_sub(string=theFiles, start=12, end=18)
# build an empty list
frameList <- vector("list", length(frameNames))
names(frameList) <- frameNames
# add each data.frame into the list
for(a in frameNames)
{
  frameList[[a]] <- eval(parse(text=a))
}
head(frameList[[1]])
head(frameList[["Aid_00s"]])
head(frameList[[5]])
head(frameList[["Aid_60s"]])

# having all dfs in a list allows iteration thru the list, joining all elements
# or applying functions to elements iteratively
# use Reduce function to speed up the operation
allAid <- Reduce(function(...){
  join(..., by=c("Country.Name", "Program.Name"))},
  frameList)
dim(allAid)

library(useful)
corner(allAid, c=15)
bottomleft(allAid, c=15)

# example: we have a vector of first ten ints 1:10 and want to sum them
# forget that sum(1:10) would work perfectly
# we can call Reduce(sum, 1:10)
# ...means that anything could be passed
# so when we passed it earlier, Reduce passed the first two DFs in the list,
# which when then joined; that result was then joined to the next df and so on
# until all are joined together

# ====== DATA.TABLE MERGE ======
# to start, we convert two of our f-aid datasets' data.frames -> data.tables
library(data.table)
dt90 <- data.table(Aid_90s, key=c("Country.Name", "Program.Name"))
dt00 <- data.table(Aid_00s, key=c("Country.Name", "Program.Name"))
# now join; note that join requires specifying the keys for the data.table
# which we did during their creation
# dt0090 is left side, dt00 is the right side; left join performed
dt0090 <- dt90[dt00]
dt0090

# ============== reshape2 ======================================================
# most common munging needed is either melting data (going from col orientation
# to row orientation) or casting data (going from row orientation to col)

# ====== melt ======
# cross table - nice for human consumption but not for graphing with ggplot2
# looking at Aids_00s df, $ amt for country and program is found in differnt
# column for each year -- this is a cross table
head(Aid_00s)
# we want to set it up so that each row represents a single country-program-
# year entry with the dollar amount in one column -- USE melt from reshape2
library(reshape2)
melt00 <- melt(Aid_00s, id.vars=c("Country.Name", "Program.Name"),
               variable.name="Year", value.name="Dollars")
tail(melt00, 10)

# make data pretty
library(scales)
melt00$Year <- as.numeric(str_sub(melt00$Year, start=3, 6))
meltAgg <- aggregate(Dollars ~ Program.Name + Year, data=melt00,
                     sum, na.rm=TRUE)
meltAgg$Program.Name <- str_sub(meltAgg$Program.Name, start=1, end=10)

ggplot(meltAgg, aes(x=Year, y=Dollars)) +
  geom_line(aes(group=Program.Name)) +
  facet_wrap(~ Program.Name) +
  scale_x_continuous(breaks=seq(from=2000, to=2009, by=2)) +
  theme(axis.text.x=element_text(angle=90, vjust=1, hjust=0)) +
  scale_y_continuous(labels=multiple_format(extra=dollar,
                                            multiple="B"))

# ==== DCAST =====
# now that data is melted, cast it back into the wide format asethetics
# dcast is the function for this
cast00 <- dcast(melt00, Country.Name + Program.Name ~ Year,
                value.var="Dollars")
head(cast00)