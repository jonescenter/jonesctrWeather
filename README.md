# jonesctrWeather

An R package for accessing weather station data from the Jones Center at Ichauway. Provides simple functions to authenticate and retrieve data from the Jones Center Weather API without requiring any knowledge of the underlying REST API or authentication setup.

## Installation

```r
install.packages("remotes")
remotes::install_github("jonescenter/jonesctrWeather")
```

## Authentication

The package uses your existing `@jonesctr.org` account for authentication. On the first call to `get_weather()` a browser window will open for sign-in. Your token is cached for the remainder of the session — subsequent calls are silent.

You must be a member of the `RES-WeatherAPI-Read` Active Directory group to access the API. Contact IT to request access.

## Usage

```r
library(jonesctrWeather)

# List available weather stations
list_stations()

# Get 15-minute interval data
wx <- get_weather(start = "2025-01-01", end = "2025-01-31")

# Get daily aggregate data
wx_daily <- get_weather_daily(start = "2025-01-01", end = "2025-01-31")

# Plot air temperature
library(ggplot2)

ggplot(wx, aes(x = as.POSIXct(TmStamp), y = AirTC_Avg)) +
  geom_line(color = "#447099") +
  labs(
    title    = "Crafton Palmer Weather Station",
    subtitle = "Air Temperature",
    x        = "Date",
    y        = "Temperature (°C)"
  ) +
  theme_minimal()
```

## Functions

| Function | Description |
|---|---|
| `get_weather(start, end)` | Returns 15-minute interval weather records for the given date range. |
| `get_weather_daily(start, end)` | Returns daily aggregate weather records for the given date range. |
| `list_stations()` | Returns a dataframe of available weather stations and their supported data intervals. |


## Data

All data comes from the **Crafton Palmer Weather Station** at Ichauway, Baker County, Georgia. The station collects readings every 15 minutes including air temperature, relative humidity, wind speed, rainfall, barometric pressure, solar radiation, soil moisture, and fuel moisture.

## Requirements

- R 4.1 or higher
- A Jones Center `@jonesctr.org` account
- Contact IT at support@jonesctr.org to request access.

## Support

Contact Jones Center IT at support@jonesctr.org for access requests or technical issues.