## Function
# function that receives timestamp and time zone of server
# as well as longitude of current location
# and returns approximate time at current location
# (assuming 24 equally spaced time zones across the longitudes)

get_local_time <- function(ts,tz,longitude){
  
  library(lubridate)
  
  # Convert variables to correct variable classes
  ts <- ymd_hms(as.character(ts))
  tz <- hours(as.character(tz))
  longitude <- as.numeric(as.character(longitude))
  
  # Get UTC time based on time zone of timestamp
  ts_utc <- ts - tz
  
  # Get local time based on current longitude
  offset <- longitude * 24/360
  ts_local <- ts_utc + hours(round(offset))
  
  return(ts_local)
}



## Demonstration

# Load subset of data
library(data.table)
loc <- fread("loc.tsv",nrows = 20000, colClasses=list(character=1:20))

# Apply function to start timestamps
loc$StartMeasurement_ts_local <-
  get_local_time(ts = loc$StartMeasurement_ts,
                 tz = loc$StartMeasurement_tz,
                 longitude = loc$LongitudeOnStart)

# Apply function to end timestamps
loc$EndMeasurement_ts_local <-
  get_local_time(ts = loc$EndMeasurement_ts,
                 tz = loc$EndMeasurement_tz,
                 longitude = loc$LongitudeOnEnd)