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
total.emissions.baltimore.type <- ddply(NEI.24510, .(type, year), summarize, Emissions = sum(Emissions))
total.emissions.baltimore.type$Pollutant_Type <- total.emissions.baltimore.type$type

# Build png and save
png(filename='plot3.png', width=480, height=480, units='px')
qplot(year, Emissions, data = total.emissions.baltimore.type, group = Pollutant_Type, 
      color = Pollutant_Type, geom = c("point", "line"), ylab = expression("Total Emissions, PM"[2.5]), 
      xlab = "Year", main = "Total Emissions in U.S. by Type of Pollutant")

# Close png
dev.off()

