# 📘 DAX – Ściągawka funkcji z przykładami

Poniżej znajduje się zestawienie najważniejszych funkcji DAX wraz z opisem, zastosowaniem i przykładem użycia.

## 🔹 CALCULATE()
**Opis:** Zmienia kontekst filtra i wykonuje obliczenie.
**Zastosowanie:** Tworzenie zaawansowanych miar z warunkami.
**Przykład:**
```dax
Sales_USA := CALCULATE(SUM(Sales[Amount]), Customers[Country] = "USA")
```

## 🔹 SUM(), AVERAGE(), COUNT()
**Opis:** Funkcje agregujace.
**Zastosowanie:** Podstawowe obliczenia sum, srednich i licznosci.
**Przykład:**
```dax
Total_Sales := SUM(Sales[Amount])
Average_Sales := AVERAGE(Sales[Amount])
```

## 🔹 FILTER()
**Opis:** Zwraca przefiltrowana tabele wedug warunku.
**Zastosowanie:** Stosowana w CALCULATE() do filtrowania.
**Przykład:**
```dax
High_Value_Sales := CALCULATE(SUM(Sales[Amount]), FILTER(Sales, Sales[Amount] > 1000))
```

## 🔹 DATESYTD(), DATESMTD(), DATESQTD()
**Opis:** Zwracaja daty od poczatku roku/miesiaca/kwartau do daty w kontekscie.
**Zastosowanie:** Agregacja wartosci od poczatku okresu.
**Przykład:**
```dax
Sales_YTD := CALCULATE(SUM(Sales[Amount]), DATESYTD(Dates[Date]))
```

## 🔹 SAMEPERIODLASTYEAR()
**Opis:** Zwraca daty odpowiadajace temu samemu okresowi w poprzednim roku.
**Zastosowanie:** Porownanie rok do roku.
**Przykład:**
```dax
Sales_Last_Year := CALCULATE(SUM(Sales[Amount]), SAMEPERIODLASTYEAR(Dates[Date]))
```

## 🔹 ALL(), REMOVEFILTERS()
**Opis:** Usuwa filtry z kolumny lub tabeli.
**Zastosowanie:** Przy obliczaniu udziaow, srednich globalnych.
**Przykład:**
```dax
Total_Sales_All := CALCULATE(SUM(Sales[Amount]), ALL(Products))
```

## 🔹 DIVIDE()
**Opis:** Bezpieczne dzielenie, obsuguje przypadki dzielenia przez 0.
**Zastosowanie:** Obliczanie wskaznikow (np. srednich).
**Przykład:**
```dax
Average_Price := DIVIDE(SUM(Sales[Amount]), SUM(Sales[Quantity]))
```

## 🔹 RELATED(), RELATEDTABLE()
**Opis:** Pobieranie wartosci z powiazanej tabeli.
**Zastosowanie:** W modelach z relacjami.
**Przykład:**
```dax
Customer_Country := RELATED(Customers[Country])
```

## 🔹 RANKX()
**Opis:** Nadaje range kazdemu wierszowi na podstawie wartosci.
**Zastosowanie:** Tworzenie rankingow.
**Przykład:**
```dax
Product_Rank := RANKX(ALL(Products), SUM(Sales[Amount]))
```

## 🔹 SWITCH()
**Opis:** Wielowarunkowa instrukcja przypisania wartosci.
**Zastosowanie:** Grupowanie kategorii, tworzenie etykiet.
**Przykład:**
```dax
Sales_Category := SWITCH(TRUE(), Sales[Amount] < 100, "Low", Sales[Amount] < 500, "Medium", "High")
```

## 🔹 IF(), IFERROR()
**Opis:** Instrukcja warunkowa.
**Zastosowanie:** Proste decyzje logiczne.
**Przykład:**
```dax
Discount_Flag := IF(Sales[Discount] > 0, "Yes", "No")
```

## 🔹 VALUES(), DISTINCT()
**Opis:** Zwraca unikalne wartosci z kolumny.
**Zastosowanie:** Liczenie unikalnych elementow.
**Przykład:**
```dax
Unique_Products := COUNTROWS(VALUES(Sales[ProductID]))
```

## 🔹 NOW(), TODAY(), YEAR(), MONTH(), DAY()
**Opis:** Funkcje daty i czasu.
**Zastosowanie:** Wyciaganie skadnikow daty, biezaca data.
**Przykład:**
```dax
Current_Year := YEAR(TODAY())
```

## 🔹 DATEDIFF()
**Opis:** Oblicza roznice miedzy dwiema datami.
**Zastosowanie:** Porownanie czasu trwania.
**Przykład:**
```dax
Days_To_Ship := DATEDIFF(Sales[OrderDate], Sales[ShipDate], DAY)
```

## 🔹 YEARFRAC()
**Opis:** Zwraca ułamek roku między dwiema datami.
**Zastosowanie:** Obliczanie czasu trwania w ujęciu rocznym (np. staż pracy, wiek klienta).
**Przykład:**
```dax
Wiek := YEARFRAC(Clients[BirthDate], TODAY())
```
****
