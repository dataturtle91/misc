### Funkcja sprawdzająca czy liczba jest liczbą pierwszą

is_prime_number <- function(number) {
  dividers <- c()
  
  for (i in 2:sqrt(number)) {
    if (number %% i == 0) {
      dividers <- c(dividers,i)
    }
  }
  
  if (length(dividers) == 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
  
}
