# UTM Generator - program created with ChatGPT

utm_generator <- function() {
  
  #Phrases
  phr_domain <- "Podaj link do domeny: "
  phr_source <- "Podaj źródło ruchu, (np. Google, Facebook, newsletter): "
  phr_medium <- "Podaj kanał (np. cpc, email, social, organic): "
  phr_campaign <- "Podaj nazwę kampanii (np. kampania_wiosenna): "
  phr_continue <- "Czy chcesz wygenerować kolejny link (tak / nie): "
  

  
  
   #Display title
   cat("\nGenerator UTM - tryb interaktywny \n")
   
 repeat {
   
    
     domain <- readline(phr_domain)
     
     if (!grepl("^https?://", domain)) {
       domain <- paste0("https://",domain)
     }
     
     sep <- ifelse(grepl("\\?",domain),"&","?")
    


     utm_source <- paste0(sep,"utm_source=", readline(phr_source))
     utm_medium <- paste0("&utm_medium=", readline(phr_medium))
     utm_campaign <- paste0("&utm_campaign=", readline(phr_campaign))
     
     utm_link <- tolower(paste0(domain,utm_source,utm_medium,utm_campaign))
     
     cat("\nWygenerowany link UTM to: \n\n", utm_link, "\n\n")
     
     cont <- readline(phr_continue)
     if (!(tolower(cont) %in% c("tak","t","yes","y",as.character(1)))) {
       cat("Kończenie programu...\n")
       break
     }
     
     }
}

utm_generator()
