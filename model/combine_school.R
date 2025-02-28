# Load the datasets
school_east <- read.csv("school_east.csv")
school_west <- read.csv("school_west.csv")

# Combine the datasets
combined_data <- rbind(school_east, school_west)

# Save the combined data
write.csv(combined_data, "combined_schools.csv", row.names = FALSE)

# View the combined data
head(combined_data)