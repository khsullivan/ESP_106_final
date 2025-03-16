## Create vector of city names
cities = c("Boston", "Austin", "Chicago", "Columbus", "Los Angeles", 
           "New York", "Pittsburgh", "Philadelphia", "San Francisco", "Washington DC")
## Create empty Data frames
merged_data_df = data.frame()
## Read in bike share data
bikeshare_data = read.csv("Bikeshare_data.csv")  # Read bikeshare data
## Merge weather and bike share data
for (city in cities) {
  city_bikeshare = bikeshare_data[bikeshare_data$City == city, ]  # Subset by city
  city_bikeshare$yr_mo_d = substr(city_bikeshare$yr_mo_d, 1, 7)  # Remove times from data
  colnames(city_bikeshare)[colnames(city_bikeshare) == "yr_mo_d"] = "Date"  # Rename column
  weather_data = read.csv(paste0("~/Desktop/School/ESP_106/Final Project/Weather Data/",city, " weather data.csv"), skip=1)  # Read in weather data
  city_merged_data = merge(city_bikeshare, weather_data, by = "Date")  # Merge datasets
  merged_data = rbind(merged_data, city_merged_data)  # Add to data frame
}

# Convert to date format
merged_data$Date=as.Date(merged_data$Date, format= "%m/%d/%y")
# Add Day of Week Variable
merged_data$Day_Of_Week = weekdays(merged_data$Date)
## Add rain or not variable
df$rain_or_not <- ifelse(merged_data$PRCP..Inches. > 0, 1, 0)
## Correcting date 
merged_data$Date = base::as.Date(merged_data$Date, format = "%m/%d/%y")
## Ordering by city and date
merged_data_sorted = merged_data[order(merged_data$City, merged_data$Date),]
merged_data_sorted$sum_min <- as.numeric(gsub(",", "", merged_data_sorted$sum_min))
merged_data_sorted$num_trip <- as.numeric(gsub(",", "", merged_data_sorted$num_trip))
merged_data_sorted

four_week_window <- function(dataframe, column, suffix) {
  # Dynamically reference the column using rlang::sym() and !!
  column_sym <- sym(column)
  
  dataframe <- dataframe %>%
    # Group by City
    group_by(City) %>%
    # Use rollapply to calculate the rolling mean and SD with a window of 28 days
    mutate(
      rolling_mean = rollapply(!!column_sym, width = 28, FUN = mean, align = "center", fill = NA),
      rolling_sd = rollapply(!!column_sym, width = 28, FUN = sd, align = "center", fill = NA),
      # Calculate the z-score for each day
      z_score = (!!column_sym - rolling_mean) / rolling_sd
    ) %>%
    # Remove intermediate columns
    select(-rolling_mean, -rolling_sd) %>%
    # Rename z_score column
    rename(!!paste0("z_score_", suffix) := z_score)
  
  return(dataframe)
}

column_names_to_z_score = c("sum_min", "num_trip", "TAVG..Degrees.Fahrenheit.", "TMAX..Degrees.Fahrenheit.", "TMIN..Degrees.Fahrenheit.", "PRCP..Inches.", "SNOW..Inches.", "SNWD..Inches.")

for (name in column_names_to_z_score){
  merged_data_sorted = four_week_window(merged_data_sorted, name, name)
}

## Convert city names to factor
merged_data_sorted$City = as.factor(merged_data_sorted$City)

#Linear Model for Number of Minutes
train_data$Day_Of_Week=as.factor(train_data$Day_Of_Week)
colnames(train_data)
linear_model_mins = lm(train_data$z_score_sum_min ~  
                         train_data$z_score_TMAX..Degrees.Fahrenheit. + 
                         train_data$z_score_TMIN..Degrees.Fahrenheit. + 
                         train_data$Day_Of_Week +
                         train_data$rain_or_not)
summary(linear_model_mins)

# Linear Model for number of trips
linear_model_trips = lm(train_data$z_score_num_trip ~  
                          train_data$z_score_TMAX..Degrees.Fahrenheit. + 
                          train_data$z_score_TMIN..Degrees.Fahrenheit. + 
                          train_data$Day_Of_Week+
                          train_data$rain_or_not)
summary(linear_model_trips)
