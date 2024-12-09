### BMI calculator

library(dplyr)

cat("Witaj w kalkulatorze BMI\n")

cat("BMI jest standardowym narzędziem służącym do oceny masy ciała")
masa <- as.integer(readline("Podaj masę ciała w kilogramach :"))

wzrost <- as.double(readline("Podaj wzrost w metrach :"))

bmi = masa /(wzrost ^ 2)

cat("Twoje BMI wynosi", bmi)

case_when(
  
  bmi <= 18.49 ~ "Masz niedowagę",
  bmi <= 24.49 ~ "Twoja waga jest optymalna",
  bmi <= 29.99 ~ "Masz nadwagę",
  bmi >= 30.00 ~ "Cierpisz na otyłość",
)


