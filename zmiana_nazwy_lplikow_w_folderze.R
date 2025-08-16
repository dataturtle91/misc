#-----------------------------------
# Zmiana nazwy plików w folderze
#-----------------------------------

# Skrypt zmienia nazwy wszystkich plików w folderze na zdefiniowaną przez
# użytkownika, nadając kolejne indeksy począwszy od 1
# Skrypt wygenerowany przez ChatGPT5, zmodyfikowany przez autora


# Wskazanie katalogu roboczego i pobranie pełnych nazw plików

directory <- "D:/directory"

files <- list.files(directory, full.names = TRUE)

# Wprowadź własną nazwę

custom_name <- ("custom_name")

# Iteracyjne nadawanie nowych nazw

for (i in seq_along(files)) {
    # Wyciągnięcie rozszerzenia pliku
    ext <- tools::file_ext(files[i])
    
    # Zbudowanie nowej nazwy pliku z indeksem
    new_name <- paste0(custom_name,i,ifelse(ext !="",paste0(".",ext),""))
    
    # Zmiana nazwy pliku
    file.rename(files[i], file.path(dirname(files[i]),new_name))
}





