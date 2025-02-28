# Step 1: Load the datasets
crime_data <- read.csv("crime_data.csv", stringsAsFactors = FALSE)
population_data <- read.csv("population2022_data.csv", stringsAsFactors = FALSE)

#Rename columns if necessary
colnames(crime_data)[1] <- "district"  # Rename first column to 'district'
colnames(population_data)[1] <- "district"  # Rename first column to 'district'
colnames(population_data)[2] <- "population"

# Step 2: Select relevant columns
crime_data_2022 <- crime_data[, c("district", "X2022")]  # Select district and 2022 crime data
population_data <- population_data[, c("district", "population")]  # Select district and population data

# Rename columns for clarity
colnames(crime_data_2022) <- c("district", "crime_number")
colnames(population_data) <- c("district", "population")

# Step 3: Merge the datasets by 'district'
merged_data <- merge(
  x = crime_data_2022,       # Crime data for 2022
  y = population_data,       # Population data
  by = "district"            # Match using the 'district' column
)

# Step 4: Calculate crime rate
merged_data <- merged_data %>%
  mutate(crime_rate = (crime_number / population) * 100000)

# Step 5: View the resulting data
print(merged_data)

# Step 6: Save the results (optional)
write.csv(merged_data, "crime_rate_data.csv", row.names = FALSE)

