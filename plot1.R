library(plyr)
library(ggplot2)
library(data.table)

# Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Convert data into data tables
NEI.dt = data.table(NEI)
SCC.dt = data.table(SCC)

# Aggregate data by year
total.emissions <- with(NEI, aggregate(Emissions, by = list(year), sum))

# Build and create png
png(filename = "plot1.png", width = 480, height = 480, units = "px")

# Create plot
plot(total.emissions, type = "b", pch = 18, col = "red", ylab = "Emissions", 
     xlab = "Year", main = "Annual Emissions")

# Close png
dev.off()
