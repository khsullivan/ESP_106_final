cities = c("Boston", "Austin", "Chicago", "Columbus", "Los Angeles", 
           "New York", "Pittsburgh", "Philadelphia", "San Francisco", "Washington DC")
merged_data_df = data.frame()
for (city in cities) {
  bikeshare_data = read.csv("Bikeshare_data.csv")  # Read bikeshare data
  city_bikeshare = bikeshare_data[bikeshare_data$City == city, ]  # Subset by city
  city_bikeshare$yr_mo_d = substr(city_bikeshare$yr_mo_d, 1, 7)  # Remove times from data
  colnames(city_bikeshare)[colnames(city_bikeshare) == "yr_mo_d"] = "Date"  # Rename column
  weather_data = read.csv(paste0("~/Desktop/School/ESP_106/Final Project/Weather Data/",city, " weather data.csv"), skip=1)  # Read in weather data
  city_merged_data = merge(city_bikeshare, weather_data, by = "Date")  # Merge datasets
  merged_data_df = rbind(merged_data_df, city_merged_data)  # Add to data frame
}
write.csv(merged_data_df,"AllCitiesMerge.csv")

merged_data= read.csv("AllCitiesMerge.csv")
merged_data$Date=as.Date(merged_data$Date, format= "%m/%d/%y")
merged_data$Day_Of_Week = weekdays(merged_data$Date)

