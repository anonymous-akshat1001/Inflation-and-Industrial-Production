# Load the required library
library(readxl)
install.packages("ggplot2")
library(ggplot2)

# Read the two Excel sheets
cpi_data <- read_excel("CPI - Combined.xlsx")
iip_data <- read_excel("Index of Industrial Production.xlsx")

# Select the desired columns from each dataframe
cpi_data <- cpi_data[, c("Month", "Inflation (%)")]
iip_data <- iip_data[, c("Month", "IIP")]

# Convert the "Month" column from "MMM-YYYY" format to Date format
cpi_data$Month <- as.Date(paste0("01-", cpi_data$Month), format = "%d-%b-%Y")
iip_data$Month <- as.Date(paste0("01-", iip_data$Month), format = "%d-%b-%Y")

# Merge the two dataframes by the "Month" column
merged_data <- merge(cpi_data, iip_data, by = "Month")

# Convert the "Inflation (%)" and "IIP" columns to numeric, removing non-numeric characters
cpi_data$`Inflation (%)` <- as.numeric(gsub(",", "", cpi_data$`Inflation (%)`))
iip_data$IIP <- as.numeric(gsub(",", "", iip_data$IIP))

# Omit rows with NA values in either of the variables
merged_data <- merged_data[complete.cases(merged_data), ]

# Sort the data by "Month" in chronological order
merged_data <- merged_data[order(merged_data$Month), ]

# Write the filtered data to a CSV file
write.csv(merged_data, "AE_Assignment3_Data.csv", row.names = FALSE)

# Is structured as time series?
check.ts <- is.ts(merged_data) 
check.ts

merged_data.ts <- ts(merged_data, start=c(2014,1), end=c(2022,12),frequency=12)
merged_data.ts

check.ts <- is.ts(merged_data.ts) 
check.ts



# Line plot for Inflation (%) vs Month
ggplot(merged_data, aes(x = Month, y = `Inflation (%)`)) +
  geom_line(na.rm = TRUE) +   # Ignore NA while plotting
  labs(title = "Inflation (%) vs Month", x = "Month", y = "Inflation (%)") +
  theme_minimal() +
  scale_x_date(date_labels = "%b-%Y", date_breaks = "1 year")

# Line plot for IIP vs Month
ggplot(merged_data, aes(x = Month, y = IIP)) +
  geom_line() +
  labs(title = "IIP vs Month", x = "Month", y = "IIP") +
  theme_minimal() +
  scale_x_date(date_labels = "%b-%Y", date_breaks = "1 year")

