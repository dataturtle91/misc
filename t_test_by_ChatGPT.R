interpret_t_test <- function(x, mu = 0, alpha = 0.05) {
  test_result <- t.test(x, mu = mu)  # Wykonanie testu
  p_value <- test_result$p.value  # Pobranie p-wartości
  
  # Interpretacja wyniku
  if (p_value < alpha) {
    message <- paste("Odrzucamy H0 (p =", round(p_value, 4), ") - średnia różni się istotnie od", mu)
  } else {
    message <- paste("Brak podstaw do odrzucenia H0 (p =", round(p_value, 4), ") - brak istotnej różnicy względem", mu)
  }
  
  return(message)
}

# Testowanie funkcji
set.seed(123)
wyniki <- rnorm(30, mean = 78, sd = 10)
interpret_t_test(wyniki, mu = 75)