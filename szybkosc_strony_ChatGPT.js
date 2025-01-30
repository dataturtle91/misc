(() => {
    // Pobranie danych nawigacyjnych
    const navTiming = performance.getEntriesByType("navigation")[0];
    const pageLoadTime = (navTiming.loadEventEnd - navTiming.startTime) / 1000; // Konwersja na sekundy

    console.log(`Czas ładowania całej strony: ${pageLoadTime.toFixed(2)} s`);

    // Pobranie zasobów
    const resources = performance.getEntriesByType("resource");

    if (resources.length === 0) {
        console.log("Brak danych o zasobach.");
        return;
    }

    // Przetworzenie danych o zasobach
    const resourceData = resources.map(res => ({
        "Nazwa": res.name,
        "Typ": res.initiatorType,
        "Czas ładowania (ms)": (res.responseEnd - res.startTime).toFixed(2),
        "Rozmiar (KB)": res.transferSize ? (res.transferSize / 1024).toFixed(2) : "Nieznany"
    }));

    // Sortowanie malejące według czasu ładowania
    resourceData.sort((a, b) => b["Czas ładowania (ms)"] - a["Czas ładowania (ms)"]);

    console.log("Szczegóły załadowanych zasobów (posortowane malejąco według czasu ładowania):");
    console.table(resourceData);

    // Tworzenie nagłówka CSV
    let csvContent = "Nazwa,Typ,Czas ładowania (ms),Rozmiar (KB)\n";
    csvContent += resourceData.map(row => 
        `"${row["Nazwa"]}","${row["Typ"]}",${row["Czas ładowania (ms)"]},${row["Rozmiar (KB)"]}`
    ).join("\n");

    // Tworzenie i pobranie pliku CSV
    const blob = new Blob([csvContent], { type: "text/csv" });
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "resource_load_times.csv";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    console.log("Dane zapisano do resource_load_times.csv");
})();
