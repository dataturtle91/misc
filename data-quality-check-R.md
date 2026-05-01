# Cheatsheet: Data Quality Checks & Cleaning in R

## 1. Quick Data Overview (EDA light)
```r
head(df)
tail(df)
str(df)
summary(df)
dim(df)
names(df)
```

### Alternatives:
```r
library(dplyr)
glimpse(df)

library(skimr)
skim(df)
```

---

## 2. Missing Values (NA)
```r
sum(is.na(df))                 # total NA
colSums(is.na(df))            # NA per column
colMeans(is.na(df)) * 100     # % NA per column
```

### Rows with NA:
```r
df[!complete.cases(df), ]
```

### Remove NA:
```r
df_clean <- na.omit(df)
```

### Replace NA:
```r
df$col[is.na(df$col)] <- 0
```

---

## 3. Duplicates
```r
sum(duplicated(df))        # count duplicates
df[duplicated(df), ]       # preview
df <- df[!duplicated(df), ] # remove
```

### By column:
```r
df[duplicated(df$col), ]
```

---

## 4. Empty Strings ("") vs NA
```r
sum(df$col == "", na.rm = TRUE)
df$col[df$col == ""] <- NA
```

### Global:
```r
df[df == ""] <- NA
```

---

## 5. Data Type Consistency
```r
sapply(df, class)
```

### Conversions:
```r
as.numeric(df$col)
as.character(df$col)
as.factor(df$col)
as.Date(df$date_col)
```

### Common issue:
```r
as.numeric(as.character(df$factor_col))
```

---

## 6. Outliers
```r
Q1 <- quantile(df$col, 0.25)
Q3 <- quantile(df$col, 0.75)
IQR <- Q3 - Q1

df_outliers <- df[df$col < (Q1 - 1.5*IQR) | df$col > (Q3 + 1.5*IQR), ]
```

### Visual:
```r
boxplot(df$col)
```

---

## 7. Distributions / Sanity Check
```r
table(df$col)
prop.table(table(df$col))
```

### Multiple columns:
```r
lapply(df, table)
```

---

## 8. Data Consistency Checks
```r
length(unique(df$id)) == nrow(df)   # unique key check
range(df$col, na.rm = TRUE)        # value range
df[df$age < 0, ]
df[df$price < 0, ]
```

---

## 9. Cleaning with dplyr
```r
library(dplyr)

df_clean <- df %>%
  distinct() %>%
  filter(!is.na(col1)) %>%
  mutate(
    col2 = ifelse(col2 == "", NA, col2),
    col3 = as.numeric(col3)
  )
```

---

## 10. Text Cleaning
```r
library(stringr)

df$col <- str_trim(df$col)
df$col <- str_to_lower(df$col)
df$col <- str_replace_all(df$col, "[^[:alnum:]]", "")
```

---

## 11. Useful Packages
- dplyr
- tidyr
- skimr
- janitor
- stringr
- data.table

---

## 12. Quick Data Quality Pipeline
```r
library(dplyr)

df_clean <- df %>%
  distinct() %>%
  mutate(across(everything(), ~na_if(., ""))) %>%
  filter(complete.cases(.))
```

---

## Practical Tips
- NA ≠ "" → always normalize
- check types after import
- validate keys before joins
- run sanity checks before modeling
