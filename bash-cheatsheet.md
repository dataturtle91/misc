# 🐚 Podstawy programowania w Bash

## 📘 Wprowadzenie

**Bash (Bourne Again Shell)** to interpreter polecen i jezyk skryptowy uzywany w systemach Unix/Linux oraz macOS.  
Umozliwia automatyzacje zadan systemowych, przetwarzanie plikow i tworzenie prostych programow.

Skrypty bash maja zwykle rozszerzenie `.sh`, a na poczatku zawieraja tzw. **shebang**:

```bash
#!/bin/bash
```

---

## 📂 Uruchamianie skryptu

```bash
chmod +x skrypt.sh   # nadaj uprawnienia do uruchamiania
./skrypt.sh          # uruchom skrypt
bash skrypt.sh       # alternatywnie, bez chmod
```

---

## 🔤 Zmienne

```bash
imie="Bartosz"
echo "Czesc, $imie!"
```

- **Brak spacji** przy przypisaniu (`=`)  
- Dostep do wartosci: `$nazwa`  
- Zmienne sa **domyslnie typu tekstowego**

### Zmienne srodowiskowe

```bash
echo $HOME
echo $USER
export MOJA_ZMIENNA="test"   # eksport do srodowiska
```

---

## 🔁 Instrukcje warunkowe

```bash
x=5

if [ $x -gt 3 ]; then
  echo "Wieksze niz 3"
elif [ $x -eq 3 ]; then
  echo "Rowne 3"
else
  echo "Mniejsze niz 3"
fi
```

### Operatory porownania
| Typ | Operator | Znaczenie |
|------|-----------|-----------|
| Liczby | `-eq` | rowne |
| | `-ne` | rozne |
| | `-gt` | wieksze |
| | `-lt` | mniejsze |
| Ciagi | `=` | rowne |
| | `!=` | rozne |
| | `-z` | pusty ciag |

---

## 🔁 Petle

### Petla `for`

```bash
for i in 1 2 3 4 5; do
  echo "Liczba: $i"
done
```

lub z sekwencja:

```bash
for i in {1..5}; do
  echo "Liczba: $i"
done
```

### Petla `while`

```bash
licznik=1
while [ $licznik -le 3 ]; do
  echo "Iteracja $licznik"
  ((licznik++))
done
```

### Petla `until`

```bash
x=0
until [ $x -ge 5 ]; do
  echo "x = $x"
  ((x++))
done
```

---

## 🧩 Funkcje

```bash
powitanie() {
  echo "Witaj, $1!"
}

powitanie "Bartosz"
```

- `$1`, `$2`, ... – argumenty funkcji  
- `return` zwraca kod zakonczenia (0 = sukces)

---

## 📜 Argumenty skryptu

```bash
#!/bin/bash
echo "Nazwa skryptu: $0"
echo "Pierwszy argument: $1"
echo "Wszystkie: $@"
echo "Liczba argumentow: $#"
```

---

## 🗂️ Praca z plikami

```bash
ls /etc
cat plik.txt
grep "hasło" plik.txt
cp plik1.txt kopia.txt
mv kopia.txt katalog/
rm plik.txt
```

### Testowanie plikow

```bash
if [ -f "plik.txt" ]; then
  echo "Plik istnieje"
fi
```

| Test | Znaczenie |
|-------|------------|
| `-f` | istnieje plik |
| `-d` | istnieje katalog |
| `-e` | istnieje (dowolny) plik |
| `-r` | ma prawo odczytu |
| `-w` | ma prawo zapisu |
| `-x` | ma prawo wykonania |

---

## ⚙️ Operacje arytmetyczne

```bash
a=5
b=3
echo $((a + b))
echo $((a * b))
```

lub za pomoca `let`:

```bash
let suma=a+b
```

---

## 🧮 Wczytywanie danych

```bash
read -p "Podaj imie: " imie
echo "Czesc, $imie!"
```

---

## 🧱 Instrukcje `case`

```bash
echo "Podaj dzien tygodnia:"
read dzien

case $dzien in
  "poniedziałek") echo "Poczatek tygodnia";;
  "piatek") echo "Prawie weekend!";;
  *) echo "Inny dzien";;
esac
```

---

## 🧰 Przydatne polecenia

| Polecenie | Opis |
|------------|------|
| `echo` | wyswietla tekst |
| `date` | data i godzina |
| `pwd` | biezacy katalog |
| `whoami` | aktualny uzytkownik |
| `df -h` | zajetosc dyskow |
| `top` / `htop` | procesy |
| `ps aux` | lista procesow |
| `kill PID` | zakonczenie procesu |
| `history` | historia polecen |
| `chmod` | zmiana uprawnien |
| `grep`, `awk`, `sed` | filtrowanie tekstu |

---

## 🧹 Dobre praktyki

- Uzywaj `set -e` (zatrzymanie przy błedzie)  
- Komentuj kod (`# komentarz`)  
- Uzywaj cudzysłowow wokoł zmiennych (`"$zmienna"`)  
- Testuj krok po kroku w terminalu przed uruchomieniem całosci

---

## 📚 Przykładowy skrypt

```bash
#!/bin/bash
# Skrypt: kopia katalogu

src="$1"
dst="$2"

if [ ! -d "$src" ]; then
  echo "Bład: katalog zrodłowy nie istnieje"
  exit 1
fi

mkdir -p "$dst"
cp -r "$src"/* "$dst"
echo "Skopiowano dane z $src do $dst"
```

Uruchomienie:

```bash
./backup.sh /home/user/dane /home/user/kopia
```

---

## 🔗 Dalsza nauka

- `man bash`
- [Bash Cheat Sheet](https://devhints.io/bash)
- [Bash Scripting Guide](https://www.tldp.org/LDP/Bash-Beginners-Guide/html/)
