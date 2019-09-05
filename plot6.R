library(dplyr)
library(ggplot2)
# Read in PM2.5 Emissions Data for '99, '02, '05, '08
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset NEI dataframe by year utilizing the following columns: Emissions, year, and fips, type
SCC <- readRDS("Source_Classification_Code.rds")

# Subset the NEI data frame by year and reduce to three columns: Emissions, year, and fips
pm0 <- subset(NEI, year==1999)
pm1 <- subset(NEI, year==2002)
pm2 <- subset(NEI, year==2005)
pm3 <- subset(NEI, year==2008)

# Extract site names (fips).
site0 <- unique(pm0$fips)
site1 <- unique(pm1$fips)
site2 <- unique(pm2$fips)
site3 <- unique(pm3$fips)

# Get names of sites where data is recorded each year.both01 <- intersect(site0, site1)
both012 <- intersect(both01, site2)
samesites <- intersect(both012, site3)

# Subset data, excluding sites that do not have records for years needed
pm0sub <- subset(pm0, fips %in% samesites)
pm1sub <- subset(pm1, fips %in% samesites)
pm2sub <- subset(pm2, fips %in% samesites)
pm3sub <- subset(pm3, fips %in% samesites)

# Create a new dataframe with summarized data
newdf <- rbind(pm0sub, pm1sub, pm2sub, pm3sub)

# Vehicle data
sn <- SCC$Short.Name
vehic <- subset(SCC, grepl("Vehicles", sn))
mrg <- merge(newdf, vehic, by = "SCC")
vehicdf <- mrg %>% select(Emissions, year, type, fips, Short.Name)

# Create new dataframe with only Baltimore City, MD data.
balt <- subset(vehicdf, vehicdf$fips == '24510')
baltdata <- balt %>% group_by(year) %>% summarize(sum(Emissions)) %>% 
  mutate(city ="Baltimore")

# Create new dataframe with only Los Angeles, CA data.
la <- subset(vehicdf, vehicdf$fips == '06037')
ladata <- la %>% group_by(year) %>% summarize(sum(Emissions)) %>% 
  mutate(city="LA")

## Combine both cities' data
plotdata <- rbind(baltdata, ladata)

## Build and save the plot
png(filename="plot6.png", width = 480, height = 480, units = "px")
qplot(year, `sum(Emissions)`, data = plotdata, facets = city~.) + 
  geom_smooth(method = 'lm', lty=2, lwd=0.5) + theme_bw() +
  labs(y = "Total (in tons)") +
  labs(title = "PM2.5 Emissions from Motor Vehicles 1999-2008") +
  theme(strip.background = element_blank())
dev.off()

