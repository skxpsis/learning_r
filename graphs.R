# example graph built into ggplot2 package
library(ggplot2)
data(diamonds)
head(diamonds)

# ================== BASIC GRAPHS (not ggplot2) ================================
# base histograms
  # used to show distribution of values for a variable
  # main = title, x-lab = x-axis title/argument
hist(diamonds$carat, main="Carat Histogram", xlab="Carat")

# base scatterplot
  # used to see 2 variables in comparison with each other
  # viewing price (y) against carat (x)
plot(price ~ carat, data=diamonds)
  # to include variables not in a data.frame as well:
plot(diamonds$carat, diamonds$price)

# base boxplot - contentious in stats community
boxplot(diamonds$carat)

# ==================== ADVANCED GRAPHS (ggplot2) ===============================

# histograms
  # only need to specify x axis as histograms are 1D
ggplot(data=diamonds) + geom_histogram(aes(x=carat))
  # density plot -- probability of falling within a range
ggplot(data=diamonds) + geom_density(aes(x=carat), fill="grey50")

# scatterplot
a <- ggplot(diamonds, aes(x=carat, y=price)) + geom_point()
b <- g + geom_point(aes(color=color)) + facet_wrap(~color)
c <- g + geom_point(aes(color=color)) + facet_grid(cut~clarity)
d <- ggplot(diamonds, aes(x=carat)) + geom_histogram() + facet_wrap(~color)

# boxplots and violin plots
ggplot(diamonds, aes(y=carat, x=1)) + geom_boxplot()
ggplot(diamonds, aes(y=carat, x=cut)) + geom_boxplot()
ggplot(diamonds, aes(y=carat, x=cut)) + geom_violin()
ggplot(diamonds, aes(y=carat, x=cut)) + geom_point() + geom_violin()
ggplot(diamonds, aes(y=carat, x=cut)) + geom_violin() + geom_point()

# line graphs
library(ggplot2)
library(lubridate)
library(scales)
ggplot(economics, aes(x=date, y=pop)) + geom_line()
economics$year <- year(economics$date)
economics$month <- month(economics$date, label=TRUE)
econ200 <- economics[which(economics$year >= 2000), ]
g2 <- ggplot(econ200, aes(x=month, y=pop))
g2 <- g2 + geom_line(aes(color=factor(year), group=year))
g2 <- g2 + scale_color_discrete(name="Year")
g2 <- g2 + scale_y_continuous(labels=comma)
g2 <- g2 + labs(title="Population Growth", x="Month", y="Population")
g2

# themes -- use themes to easily change the way plots look
library(ggplot2)
library(ggthemes)
g3 <- ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=color))
g3 + theme_economist() + scale_colour_economist()
# g3 + theme_excel() + scale_colour_excel()
# g3 + theme_tufte()
# g3 + theme_wsj()
