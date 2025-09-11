
# 📊 R vs Pandas – ściąga z operacji na ramkach danych

Porównanie podstawowych operacji na ramkach danych w **R** i **pandas (Python)**.

---

## 1. Tworzenie ramki danych
```r
# R
df <- data.frame(
  category = c("Games", "Tech", "Music"),
  goal = c(15000, 5000, 12000)
)
```

```python
# pandas
import pandas as pd

df = pd.DataFrame({
    "category": ["Games", "Tech", "Music"],
    "goal": [15000, 5000, 12000]
})
```

---

## 2. Podstawowe informacje o danych
```r
str(df)      # struktura
summary(df)  # statystyki opisowe
nrow(df)     # liczba wierszy
ncol(df)     # liczba kolumn
```

```python
df.info()      # struktura
df.describe()  # statystyki opisowe
len(df)        # liczba wierszy
len(df.columns) # liczba kolumn
```

---

## 3. Filtrowanie wierszy
```r
# w R – wektorowo
df[df$category == "Games" & df$goal > 10000, ]
```

```python
# w pandas – z nawiasami
df[(df["category"] == "Games") & (df["goal"] > 10000)]
```

---

## 4. Wybór kolumn
```r
df$category        # kolumna jako wektor
df[["category"]]   # kolumna jako wektor
df[c("category", "goal")]  # kilka kolumn
```

```python
df["category"]         # kolumna jako Series
df[["category"]]       # kolumna jako DataFrame
df[["category", "goal"]]  # kilka kolumn
```

---

## 5. Sortowanie
```r
# po jednej kolumnie
df[order(df$goal), ]

# malejąco
df[order(-df$goal), ]

# po kilku kolumnach
df[order(df$category, -df$goal), ]
```

```python
# po jednej kolumnie
df.sort_values("goal")

# malejąco
df.sort_values("goal", ascending=False)

# po kilku kolumnach
df.sort_values(["category", "goal"], ascending=[True, False])
```

---

## 6. Grupowanie i podsumowanie
```r
# base R (aggregate)
aggregate(goal ~ category, data=df, FUN=mean)

# dplyr
library(dplyr)
df %>%
  group_by(category) %>%
  summarise(mean_goal = mean(goal))
```

```python
# pandas
df.groupby("category")["goal"].mean().reset_index()

# kilka agregacji
df.groupby("category").agg(
    mean_goal=("goal", "mean"),
    max_goal=("goal", "max")
).reset_index()
```

---

## 7. Dodawanie nowej kolumny
```r
df$double_goal <- df$goal * 2
```

```python
df["double_goal"] = df["goal"] * 2
```

---

## 8. Usuwanie kolumny
```r
df$goal <- NULL
```

```python
df = df.drop(columns=["goal"])
```

---

## 9. Łączenie ramek danych
```r
# scalanie po kolumnie
merge(df1, df2, by="id")

# łączenie w pionie
rbind(df1, df2)

# łączenie w poziomie
cbind(df1, df2)
```

```python
# scalanie po kolumnie
pd.merge(df1, df2, on="id")

# łączenie w pionie
pd.concat([df1, df2], axis=0)

# łączenie w poziomie
pd.concat([df1, df2], axis=1)
```

---

## 10. Braki danych
```r
is.na(df)          # sprawdzenie
na.omit(df)        # usunięcie wierszy z NA
df$goal[is.na(df$goal)] <- 0  # zamiana NA na 0
```

```python
df.isna()           # sprawdzenie
df.dropna()         # usunięcie wierszy z NaN
df["goal"].fillna(0, inplace=True)  # zamiana NaN na 0
```

---

## 📌 Tipy
- W R filtrujesz **wektorowo** (`df[warunek, ]`), w Pandas tworzysz **maski logiczne** (`df[mask]`).
- Grupowanie i podsumowywanie w R z **dplyr** jest bardzo podobne do Pandas `.groupby()`.
- Pandas wymaga **nawiasów wokół warunków**, R nie.
- W R istnieją `&&` i `||`, ale działają tylko na **pierwszym elemencie** – w analizie danych rzadko używane.
