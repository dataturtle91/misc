# ===============================
# APLIKACJA SHINY – DZIELENIE CSV NA MNIEJSZE PLIKI - ChatGPT
# ===============================

# ======== 1. Ładowanie bibliotek ========
library(shiny)    # Główna biblioteka Shiny do tworzenia aplikacji
library(readr)    # Wczytywanie plików CSV
library(dplyr)    # Operacje na danych (np. filtrowanie, grupowanie)
library(zip)      # Tworzenie archiwów ZIP

# ======== 2. Interfejs użytkownika (UI) ========
ui <- fluidPage(

  # Nagłówek aplikacji
  titlePanel("Dziel plik CSV na mniejsze części"),

  # Układ strony: lewy panel boczny i prawy panel główny
  sidebarLayout(
    
    # Lewy panel – elementy wejściowe
    sidebarPanel(
      # Pole do wczytania pliku CSV
      fileInput("csv_file", 
                "Wybierz plik CSV", 
                accept = ".csv"),
      
      # Pole do ustawienia liczby wierszy na 1 plik
      numericInput("rows_per_file", 
                   "Liczba wierszy na plik:", 
                   value = 100, min = 1),
      
      # Przycisk do pobrania pliku ZIP
      downloadButton("download_zip", "Pobierz pliki ZIP")
    ),
    
    # Prawy panel – podgląd danych
    mainPanel(
      tableOutput("preview")  # Wyświetlenie kilku pierwszych wierszy z pliku
    )
  )
)

# ======== 3. Logika serwera ========
server <- function(input, output) {

  # Reaktywne wczytanie pliku CSV (zmienia się po przesłaniu pliku)
  data <- reactive({
    req(input$csv_file)                   # Czekaj na plik, jeśli nie ma – nic nie rób
    read_csv(input$csv_file$datapath)     # Wczytaj plik CSV do ramki danych
  })
  
  # Podgląd kilku pierwszych wierszy
  output$preview <- renderTable({
    head(data())  # Pokazuje 6 pierwszych wierszy
  })
  
  # Obsługa pobierania plików ZIP
  output$download_zip <- downloadHandler(
    
    # Nazwa pliku do pobrania
    filename = function() {
      "split_files.zip"
    },
    
    # Co ma zostać zapisane w pliku ZIP
    content = function(file) {
      df <- data()                        # Pobierz dane z CSV
      rows_per_file <- input$rows_per_file  # Ile wierszy ma mieć każdy plik
      
      total_rows <- nrow(df)              # Ile wierszy w pliku całkowicie
      split_indices <- split(1:total_rows, 
                             ceiling(seq_along(1:total_rows) / rows_per_file))
      
      temp_dir <- tempdir()               # Folder tymczasowy
      file_list <- character()            # Lista plików do spakowania
      
      # Pętla: dzielenie danych na mniejsze części i zapisywanie jako CSV
      for (i in seq_along(split_indices)) {
        chunk <- df[split_indices[[i]], ]
        part_file <- file.path(temp_dir, paste0("part_", i, ".csv"))
        write_csv(chunk, part_file)
        file_list <- c(file_list, part_file)
      }
      
      # Spakowanie wszystkich plików CSV w 1 plik ZIP
      zip::zipr(zipfile = file, 
                files = file_list, 
                recurse = FALSE)
    }
  )
}

# ======== 4. Uruchomienie aplikacji ========
shinyApp(ui = ui, server = server)
