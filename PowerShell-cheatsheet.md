# 📘 PowerShell – rozszerzona ściąga dla początkujących (PL)

> Celem tej ściągi jest dać Ci **praktyczny, skondensowany** przegląd wszystkiego, co trzeba znać, aby wygodnie pracować w PowerShell na poziomie podstawowym (i trochę ponad). Każdy blok możesz wkleić do konsoli lub skryptu.

---

## 1) Start: uruchamianie i pomoc

**Uruchamianie konsoli**
- Windows: *PowerShell 7 (pwsh)* lub *Windows PowerShell 5.1 (powershell)*
- Sprawdź wersję:  
  ```powershell
  $PSVersionTable
  ```

**Wykonywanie skryptów (Execution Policy)**
- Domyślnie może blokować uruchamianie skryptów `.ps1`
- Ustaw dla bieżącego użytkownika (zalecane):
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
  ```

**Pomoc**
```powershell
Get-Help Get-Process         # skrócony opis
Get-Help Get-Process -Detailed
Get-Help Get-Process -Examples
Update-Help -UICulture pl-PL # pobierz/odśwież pomoc (wymaga Internetu)
```

**Znajdowanie komend**
```powershell
Get-Command *service*        # wyszukaj polecenia
Get-Command -Module Microsoft.PowerShell.Management
```

---

## 2) Skrypty i profil

**Plik skryptu**: `myscript.ps1`  
**Uruchomienie**:  
```powershell
.\myscript.ps1    # w bieżącym katalogu
```

**Parametry skryptu**
```powershell
param(
  [string]$Path = ".",
  [switch]$Recurse
)

Get-ChildItem -Path $Path -File -Recurse:$Recurse
```

**Profil (auto‑ładowany przy starcie)**
```powershell
$PROFILE          # ścieżka do profilu
Test-Path $PROFILE
New-Item -ItemType File -Path $PROFILE -Force
# Dodaj aliasy, funkcje, import modułów, ustawienia PSReadLine itd.
```

---

## 3) Zmienne, typy, stringi

**Podstawy**
```powershell
$x = 10
$y = "tekst"
$pi = [math]::PI
$type = $x.GetType().FullName
```

**Interpolacja i łączenie napisów**
```powershell
$name = "Bartosz"
"Hello $name"                # interpolacja w ""
'Hello $name'                # bez interpolacji w ''
"Plik: $($env:TEMP)\log.txt" # wstawka wyrażenia
```

**Here‑string (wielolinijkowe)**
```powershell
@"
Linia 1
Linia 2 z $name
"@
```

**Konwersje typów**
```powershell
[int]"42"
[datetime]"2025-09-20"
[bool]"true"
```

**Zmienne środowiskowe**
```powershell
$env:PATH
$env:MY_VAR = "abc"
```

---

## 4) Operatory

**Porównania (niezależne od wielkości liter domyślnie)**
```powershell
$A -eq $B      # równe
$A -ne $B      # różne
$A -gt 5       # >
$A -ge 5       # >=
$A -lt 5       # <
$A -le 5       # <=
"abc" -like "a*"
"abc" -match "^a\w+"   # regex
```

**Logiczne**
```powershell
($x -gt 5) -and ($y -lt 10)
($a -eq 1) -or ($b -eq 2)
-not ($cond)
```

**Inne przydatne**
```powershell
1..5            # zakres
"abc" * 3       # powtórz
12345 -as [string]   # konwersja "bezpieczna"
```

---

## 5) Kolekcje: tablice, hashtabele, obiekty

**Tablice**
```powershell
$arr = 1,2,3
$arr[0]               # pierwszy element
$arr += 4             # dodaj
$arr.Count
```

**Hashtabele (słowniki)**
```powershell
$h = @{
  Name = "Ala"
  Age  = 30
}
$h.Name
$h["Age"] = 31
```

**Obiekty niestandardowe (rekordy)**
```powershell
[PSCustomObject]@{ Name="Ala"; Age=31; City="Kraków" }
```

**Kolekcje generyczne (wydajniejsze mutacje)**
```powershell
$list = [System.Collections.Generic.List[int]]::new()
$list.Add(1); $list.Add(2)
```

---

## 6) Pipeline – serce PowerShella

**Składnia i myślenie „obiektami”**
```powershell
Get-Process | Where-Object { $_.CPU -gt 100 } | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU
```

**Najczęstsze ogniwa pipeline’u**
```powershell
Where-Object { $_.Prop -gt 0 }
Select-Object Name, Id
Select-Object @{Name="MB";Expression={ $_.WorkingSet/1MB -as [int] }}
Sort-Object Prop -Descending
Group-Object Prop
Measure-Object -Property Size -Sum -Average -Maximum -Minimum
```

**Uwaga**: `Format-Table`/`Format-List` na końcu – do wyświetlenia. Nie przekazuj dalej sformatowanych obiektów, jeśli chcesz je jeszcze obrabiać.

---

## 7) Warunki i pętle

**If / ElseIf / Else**
```powershell
if ($x -gt 10) { "duże" }
elseif ($x -eq 10) { "równe" }
else { "małe" }
```

**Switch (także regex)**
```powershell
switch -Regex ("file1.txt","img_001.png") {
  '^img_' { "obrazek: $_" }
  '\.txt$' { "tekst: $_" }
  default { "inne: $_" }
}
```

**Pętle**
```powershell
foreach ($i in 1..5) { $i }
for ($i=0; $i -lt 5; $i++) { $i }
while ($true) { break }
do { $i++ } while ($i -lt 10)
```

**Kontrola**: `break`, `continue`

---

## 8) Funkcje i parametry (także „advanced functions”)

**Prosta funkcja**
```powershell
function Square($x) { $x * $x }
```

**Parametry z typami i wartościami domyślnymi**
```powershell
function Get-TopCpu {
  param(
    [int]$Top = 5
  )
  Get-Process | Sort-Object CPU -Descending | Select-Object -First $Top Name, CPU
}
```

**Advanced function (CmdletBinding) + walidacja + pipeline**  
```powershell
function Get-BigFiles {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("FullName")]
    [string]$Path,

    [ValidateRange(1MB, 1000GB)]
    [long]$MinSize = 100MB
  )
  process {
    Get-ChildItem -Path $Path -File -Recurse -ErrorAction SilentlyContinue |
      Where-Object { $_.Length -ge $MinSize }
  }
}
```

**Splatting (przekazywanie parametrów hashtable’em)**
```powershell
$params = @{
  Path = "."
  Filter = "*.log"
  Recurse = $true
}
Get-ChildItem @params
```

---

## 9) Błędy i logowanie

**Try / Catch / Finally**
```powershell
try {
  Get-Content "nie-istnieje.txt" -ErrorAction Stop
}
catch {
  Write-Warning "Błąd: $($_.Exception.Message)"
}
finally {
  "Sprzątanie..."
}
```

**Poziomy komunikatów**
```powershell
Write-Host "Info"
Write-Verbose "Szczegóły"       # pokaże się z przełącznikiem -Verbose
Write-Debug "Debug"             # pokaże się z -Debug
Write-Warning "Uwaga"
Write-Error "Błąd"
```

**Sterowanie błędami**
```powershell
$ErrorActionPreference = "Stop"   # domyślnie: Continue
Get-Item foo: -ErrorAction SilentlyContinue
```

---

## 10) Pliki i foldery (I/O)

**Przeglądanie**
```powershell
Get-ChildItem -Path C:\ -Directory
Get-ChildItem -Path . -Recurse -File -Filter *.log
```

**Tworzenie / kopiowanie / przenoszenie / usuwanie**
```powershell
New-Item -ItemType Directory -Path .\out
Copy-Item .\a.txt .\out\a.txt -Force
Move-Item .\out\a.txt .\a2.txt -Force
Remove-Item .\a2.txt -Force
```

**Czytanie / zapis**
```powershell
Get-Content .\in.txt -TotalCount 5
Set-Content .\out.txt "Linia 1" -Encoding utf8
Add-Content .\out.txt "Dopisane"
Out-File .\report.txt -Width 200 -Encoding utf8BOM
```

**Znajdź i usuń pliki starsze niż X dni**
```powershell
$days = 365
Get-ChildItem -Path "C:\Logs" -File -Recurse |
  Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$days) } |
  Remove-Item -Force -ErrorAction SilentlyContinue
```

**Archiwizacja**
```powershell
Compress-Archive -Path .\logs\* -DestinationPath .\logs.zip -Force
Expand-Archive .\logs.zip -DestinationPath .\unzipped -Force
```

---

## 11) CSV, JSON, XML

**CSV**
```powershell
$df = Import-Csv .\dane.csv
$df | Where-Object { $_.age -gt 30 } | Sort-Object age -Descending |
  Export-Csv .\out.csv -NoTypeInformation -Encoding UTF8
```

**JSON**
```powershell
$json = Get-Content .\config.json -Raw | ConvertFrom-Json
$json.ApiKey
# Zapis
$config = [PSCustomObject]@{ ApiKey="KEY"; Enabled=$true }
$config | ConvertTo-Json -Depth 5 | Set-Content .\config.json -Encoding utf8
```

**XML (prosto)**
```powershell
[xml]$xml = Get-Content .\data.xml
$xml.root.item[0].name
```

---

## 12) Sieć i HTTP

**Proste pobieranie stron/pliku**
```powershell
Invoke-WebRequest "https://example.com" -OutFile .\index.html
```

**REST API**
```powershell
Invoke-RestMethod -Uri "https://api.example.com/items" -Headers @{Authorization="Bearer $token"}
# POST z JSON
$body = @{ name="test"; enabled=$true } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "https://api.example.com/items" -Body $body -ContentType "application/json"
```

**DNS, ping, traceroute**
```powershell
Resolve-DnsName microsoft.com
Test-Connection 8.8.8.8 -Count 2
Test-NetConnection github.com -TraceRoute
```

---

## 13) Procesy, usługi, rejestr

**Procesy**
```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, Id
Stop-Process -Id 1234 -Force
```

**Usługi**
```powershell
Get-Service | Where-Object { $_.Status -eq "Running" }
Restart-Service -Name Spooler
```

**Rejestr (provider)**
```powershell
Get-ChildItem HKLM:\Software
Get-ItemProperty "HKCU:\Software\MojaApp"
```

---

## 14) Moduły i pakiety

**Praca z modułami**
```powershell
Get-Module               # załadowane
Get-Module -ListAvailable
Install-Module Posh-SSH  # z PSGallery (wymaga zaufania repo)
Import-Module Posh-SSH
Remove-Module Posh-SSH
```

**Sprawdzenie repozytoriów galerii**
```powershell
Get-PSRepository
Register-PSRepository -Name MyRepo -SourceLocation "https://..."
```

---

## 15) Zdalne wykonywanie (remoting)

> W PowerShell 7 remoting po WinRM lub SSH.

**WinRM (na Windows)**
```powershell
Enable-PSRemoting -Force                 # na hoście docelowym (admin)
Enter-PSSession -ComputerName SERVER01   # interakcja
Invoke-Command -ComputerName SERVER01 -ScriptBlock { Get-Process }
```

**SSH remoting (PS7)**
```powershell
Enter-PSSession -HostName srv -User bob
Invoke-Command -HostName srv -User bob -ScriptBlock { hostname }
```

---

## 16) Zadania w tle i planowanie

**Joby**
```powershell
$job = Start-Job { Start-Sleep -Seconds 5; Get-Date }
Get-Job
Receive-Job -Job $job -Wait -AutoRemoveJob
```

**Harmonogram (Scheduled Tasks)**
```powershell
$action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-File `"$HOME\Scripts\backup.ps1`""
$trigger = New-ScheduledTaskTrigger -Daily -At 3am
Register-ScheduledTask -TaskName "DailyBackup" -Action $action -Trigger $trigger -Description "Backup"
```

---

## 17) PSReadLine i produktywność

**Historia, podpowiedzi, skróty**
```powershell
Get-Module PSReadLine
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Skróty: Ctrl+R (search reverse), Alt+Shift+.(argumenty poprzednich poleceń), F8 (historia z dopasowaniem)
```

**Formatowanie wyjścia**
```powershell
Format-Table Name,Id,CPU -AutoSize
Format-List *               # wszystkie właściwości
```

**Kolumny obliczane (calculated properties)**
```powershell
Get-Process | Select-Object Name, @{N="MB";E={[int]($_.WorkingSet/1MB)}}
```

---

## 18) Częste pułapki i dobre praktyki

- **Nie** używaj `Format-*` w środku pipeline’u, jeśli planujesz dalszą obróbkę danych.
- Preferuj `Write-Output` (domyślne) zamiast `Write-Host` (tylko do UI).
- Używaj `-ErrorAction Stop` + `try/catch` dla krytycznych operacji I/O.
- Zawsze podawaj **-Encoding** przy zapisie (`utf8`/`utf8BOM`) – unikniesz problemów z polskimi znakami.
- W skryptach preferuj **jawne typy i walidacje** parametrów.
- Przy dużych kolekcjach – unikaj częstych konkatenacji tablic, używaj list generycznych.
- Do testowania praw dostępu używaj `-ErrorAction` + `SilentlyContinue`, ale loguj błędy dla audytu.
- Dokumentuj parametry w komentarzach, dodawaj **przykłady użycia** (`Get-Help` je pokaże).

---

## 19) Mini‑przepisy (cookbook)

**1. Znajdź pliki `.Rmd` na C: i D: z obsługą błędów**
```powershell
"C:\","D:\" | ForEach-Object {
  try {
    Get-ChildItem -Path $_ -Recurse -File -Filter *.Rmd -ErrorAction Stop
  }
  catch {
    Write-Warning "Brak dostępu do: $_"
  }
}
```

**2. Usuń logi starsze niż 30 dni (dry‑run + potwierdzenie)**
```powershell
$toDelete = Get-ChildItem .\logs -File -Recurse |
  Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }

$toDelete | Select-Object FullName, LastWriteTime

Read-Host "Wpisz YES aby usunąć" | Where-Object { $_ -eq "YES" } | ForEach-Object {
  $toDelete | Remove-Item -Force -ErrorAction SilentlyContinue
}
```

**3. Zbierz statystyki rozmiarów plików w katalogu**
```powershell
Get-ChildItem . -File -Recurse |
  Group-Object Extension | ForEach-Object {
    [PSCustomObject]@{
      Extension = $_.Name
      Count     = $_.Count
      TotalMB   = [math]::Round( ($_.Group | Measure-Object Length -Sum).Sum / 1MB, 2 )
    }
  } | Sort-Object TotalMB -Descending
```

**4. Wczytaj CSV, przefiltruj, wyeksportuj**
```powershell
Import-Csv .\sales.csv |
  Where-Object { [int]$_.Quantity -ge 10 } |
  Sort-Object Amount -Descending |
  Export-Csv .\sales_top.csv -NoTypeInformation -Encoding utf8
```

**5. Pokaż top 5 procesów po CPU z kolumną w MB**
```powershell
Get-Process | Sort-Object CPU -Descending |
  Select-Object -First 5 Name, CPU, @{N="WorkingSetMB";E={[int]($_.WorkingSet/1MB)}} |
  Format-Table -AutoSize
```

---

## 20) Szybka ściąga operatorów i aliasów

**Operatory porównania**: `-eq, -ne, -gt, -ge, -lt, -le, -like, -match, -contains, -in, -is`  
**Logiczne**: `-and, -or, -xor, -not`  
**Ścieżki**: `Join-Path, Split-Path, Resolve-Path, Test-Path`  
**Tekst**: `-replace`, `Substring()`, `ToUpper()`, `-split`, `-join`  
**Alias** (wybrane):  
- `ls` → `Get-ChildItem`  
- `cat` → `Get-Content`  
- `cp` → `Copy-Item`  
- `mv` → `Move-Item`  
- `rm` → `Remove-Item`  
- `gi` → `Get-Item`, `ni` → `New-Item`, `ri` → `Remove-Item`

---

## 21) Minimalny szablon skryptu produkcyjnego

```powershell
<# 
.SYNOPSIS
  Krótki opis skryptu
.DESCRIPTION
  Dłuższy opis + założenia
.PARAMETER Path
  Katalog wejściowy
.EXAMPLE
  .\script.ps1 -Path C:\Data -Verbose
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [ValidateScript({ Test-Path $_ })]
  [string]$Path,

  [ValidateRange(1,3650)]
  [int]$Days = 365,

  [switch]$WhatIf
)

try {
  $cutoff = (Get-Date).AddDays(-$Days)
  Get-ChildItem -Path $Path -File -Recurse -ErrorAction Stop |
    Where-Object { $_.LastWriteTime -lt $cutoff } |
    ForEach-Object {
      if ($WhatIf) {
        Write-Verbose "Usunąłbym: $($_.FullName)"
      } else {
        Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
        Write-Verbose "Usunięto: $($_.FullName)"
      }
    }
}
catch {
  Write-Error "Błąd krytyczny: $($_.Exception.Message)"
  exit 1
}
```

---

**Masz to!** Z tą ściągą wygodnie ogarniesz codzienną pracę w PowerShell: pliki, dane (CSV/JSON), pipeline, funkcje, błędy, remoting i automatyzację.
