#------------------------------------------------------------------------------
# Skrypt prezentuje pogodę dla wybranych współrzędnych korzystając z 
# Open Weather API
# Kod utworzony przy użyciu ChatGPT
#-----------------------------------------------------------------------------

# Ładuj biblioteki
library(httr2)
library(jsonlite)
library(dplyr)

# Współrzędne Gdyni
lat <- 54.5189
lon <- 18.5305


# Budowa zapytania
url <- request("https://api.open-meteo.com/v1/forecast") |>
  req_url_query(
    latitude = lat,
    longitude = lon,
    daily = paste(
      c("temperature_2m_max",
        "temperature_2m_min",
        "precipitation_sum",
        "wind_speed_10m_max"
        ),
      collapse = ","
    ),
    forecast_days = 14,
    timezone = "Europe/Warsaw"
  )


# Pobranie danych
response <- req_perform(url)


# Parsowanie JSON
weather <- response |>
  resp_body_json()


# Konwersja do Data Frame + spłaszczenie list
forecast <- data.frame(
  date = as.Date(unlist(weather$daily$time)),
  temp_max = unlist(weather$daily$temperature_2m_max),
  temp_min = unlist(weather$daily$temperature_2m_min),
  precipitation_mm = unlist(weather$daily$precipitation_sum),
  wind_max_kmh = unlist(weather$daily$wind_speed_10m_max),
  city = "Gdynia"
)

print(forecast)
