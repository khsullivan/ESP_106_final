cities = c("Boston", "Austin", "Chicago", "Columbus", "Los Angeles", 
           "New York", "Pittsburgh", "Philadelphia", "San Francisco", "Washington DC", "Jersey City")
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

# merge_bikeshare_weather = function(city) {
#   bikeshare_data = read.csv("Bikeshare_data.csv") ## read in bikeshare data
#   city_bikeshare = bikeshare_data[which(bikeshare_data$City == city),] ## subset by city
#   city_bikeshare$yr_mo_d = substr(city_bikeshare$yr_mo_d, 1, 7) ## remove times from data
#   colnames(city_bikeshare)[colnames(city_bikeshare) == "yr_mo_d"] = "Date" ## title column date
#   weather_data = read.csv(paste0(city, " weather data.csv")) ## read in weather data
#   city_merged_data = merge(city_bikeshare, weather_data, by = "Date") ## merge data
#   return(city_merged_data)
# }
# Boston_merged_data=merge_bikeshare_weather("Boston")
# Austin_merged_data=merge_bikeshare_weather("Austin")
# write.csv(Austin_merged_data, "Austin_merged_data.csv")
# Chicago_merged_data=merge_bikeshare_weather("Chicago")
# write.csv(Chicago_merged_data, "Chicago_merged_data.csv")
# Columbus_merged_data=merge_bikeshare_weather("Columbus")
# write.csv(Columbus_merged_data, "Columbus_merged_data.csv")
# Los_Angeles_merged_data=merge_bikeshare_weather("Los Angeles")
# write.csv(Los_Angeles_merged_data, "Los_Angeles_merged_data.csv")
# New_York_merged_data=merge_bikeshare_weather("New York")
# write.csv(New_York_merged_data, "New_York_merged_data.csv")
# Philadelphia_merged_data=merge_bikeshare_weather("Philadelphia")
# write.csv(Philadelphia_merged_data, "Philadelphia_merged_data.csv")
# Pittsburgh_merged_data=merge_bikeshare_weather("Pittsburgh")
# write.csv(Pittsburgh_merged_data, "Pittsburgh_merged_data.csv")
# San_Francisco_merged_data=merge_bikeshare_weather("San Francisco")
# write.csv(San_Francisco_merged_data, "San_Francisco_merged_data.csv")
# Washington_DC_merged_data=merge_bikeshare_weather("Washington DC")
# write.csv(Washington_DC_merged_data, "Washington_DC_merged_data.csv")
# Jersey_City_merged_data=merge_bikeshare_weather("Jersey City")
# write.csv(Jersey_City_merged_data, "Jersey_City_merged_data.csv")
