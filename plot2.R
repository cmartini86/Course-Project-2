library(plyr)
library(ggplot2)
library(data.table)

# Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Convert data into data tables
NEI.dt = data.table(NEI)
SCC.dt = data.table(SCC)

# Get Baltimore City, MD data
NEI.24510 <- NEI[which(NEI$fips == "24510"), ]

# Aggregate total emissions from Baltimore
total.emissions.baltimore <- with(NEI.24510, aggregate(Emissions, by = list(year), sum))
colnames(total.emissions.baltimore) <- c("year", "Emissions")

# Build png and save
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(total.emissions.baltimore$year, total.emissions.baltimore$Emissions, type = "b", 
     pch = 18, col = "green", ylab = "Emissions", xlab = "Year", main = "Baltimore Emissions")

# Close png
dev.off()

