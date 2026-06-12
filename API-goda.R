#------------------------------------------------------------------------------
# Skrypt generuje tabelę z prognozą pogody dla wybranych współrzędnych 
# korzystając z Open Weather API
# Kod utworzony przy użyciu ChatGPT
#------------------------------------------------------------------------------

# Ładuj biblioteki--------------------------------------------------------------
library(httr2)
library(jsonlite)
library(dplyr)
library(lubridate)
library(purrr)


# Utwórz funkcję pobierającą pogodę---------------------------------------------
get_forecast <- function(city, lat, lon) {
  
  # Budowa zapytania
  url <- httr2::request("https://api.open-meteo.com/v1/forecast") |>
    httr2::req_url_query(
      latitude = lat,
      longitude = lon,
      daily = paste(
        c("sunrise",
          "sunset",
          "temperature_2m_max",
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
  response <- httr2::req_perform(url)
  
  # Parsowanie JSON
  weather <- httr2::resp_body_json(response)
  
  # Data frame
  forecast <- data.frame(
    date = as.Date(unlist(weather$daily$time)),
    city = city,
    sunrise = unlist(weather$daily$sunrise),
    sunset = unlist(weather$daily$sunset),
    temp_max = unlist(weather$daily$temperature_2m_max),
    temp_min = unlist(weather$daily$temperature_2m_min),
    precipitation_mm = unlist(weather$daily$precipitation_sum),
    wind_max_kmh = unlist(weather$daily$wind_speed_10m_max)
  )
  
  # Transformacje
  forecast$weekday <- weekdays(forecast$date)
  forecast$sunrise <- format(lubridate::ymd_hm(forecast$sunrise), "%H:%M")
  forecast$sunset  <- format(lubridate::ymd_hm(forecast$sunset), "%H:%M")
  
  forecast <- dplyr::relocate(forecast, weekday, .after = date)
  
  # Dynamiczna nazwa obiektu
  df_name <- paste0(tolower(city), "_forecast")
  assign(df_name, forecast, envir = .GlobalEnv)
  
  return(forecast)
}


# Tabela z miastami------------------------------------------------------------
cities <- data.frame(
  city = c("Krakow", "Tychy", "Kolobrzeg", "Zielona Gora", "Wroclaw", "Gdynia"),
  lat = c(50.0647, 50.1372, 54.1750, 51.9356, 51.1079, 54.5189),
  lon = c(19.9450, 18.9664, 15.5833, 15.5062, 17.0385, 18.5305)
)


# Wywołaj funkcję--------------------------------------------------------------
pmap(cities, get_forecast)


# Połącz tabele-----------------------------------------------------------------
forecast <- rbind(gdynia_forecast,tychy_forecast,kolobrzeg_forecast,
                  krakow_forecast, `zielona gora_forecast`)


# Zapisz tabelę-----------------------------------------------------------------
write.csv(forecast, "forecast.csv")
