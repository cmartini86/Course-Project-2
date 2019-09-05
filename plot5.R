library(plyr)
library(ggplot2)
library(data.table)

# Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Convert data into data tables
NEI.dt = data.table(NEI)
SCC.dt = data.table(SCC)

# Get vehicle data
motor.vehicle.scc = SCC.DT[grep("[Mm]obile|[Vv]ehicles", EI.Sector), SCC]

# Aggregate vehicle data for Balitmore City
motor.vehicle.emissions.baltimore = NEI.dt[SCC %in% motor.vehicle.scc, sum(Emissions), by = c("year", "fips")][fips == "24510"]
colnames(motor.vehicle.emissions.baltimore) <- c("year", "fips", "Emissions")

# Build png and save
png(filename = "plot5.png", width = 480, height = 480, units = "px")
g = ggplot(motor.vehicle.emissions.baltimore, aes(year, Emissions))
g + geom_point(color = "blue") + geom_line(color = "red") + labs(x = "Year") + 
  labs(y = expression("Total Emissions, PM"[2.5])) + labs(title = "Total Emissions from Motor Vehicle Sources in Baltimore City")

# Close png
dev.off()

