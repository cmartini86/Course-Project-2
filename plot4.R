library(plyr)
library(ggplot2)
library(data.table)

# Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Convert data into data tables
NEI.dt = data.table(NEI)
SCC.dt = data.table(SCC)

# Get coal data
coal.scc = SCC.dt[grep("Coal", SCC.Level.Three), SCC]

# Get emissions data b y year
coal.emissions = NEI.dt[SCC %in% coal.scc, sum(Emissions), by = "year"]
colnames(coal.emissions) <- c("year", "Emissions")

# Build png and save
png(filename = "plot4.png", width = 480, height = 480, units = "px")
g = ggplot(coal.emissions, aes(year, Emissions))
g + geom_point(color = "blue") + geom_line(color = "red") + labs(x = "Year") + 
  labs(y = expression("Total Emissions, PM"[2.5])) + labs(title = "Emissions from Coal Combustion for the US")

# Close png
dev.off()
