from pathlib import Path
from datetime import datetime
from PIL import Image, ExifTags
import shutil

# ==========================================
# KONFIGURACJA
# ==========================================

SOURCE_DIR = Path(r"D:\Import\Zdjecia")
DESTINATION_DIR = Path(r"D:\Archiwum_Zdjec")

# ==========================================
# MAPA TAGÓW EXIF
# ==========================================

EXIF_TAGS = {
    value: key
    for key, value in ExifTags.TAGS.items()
}

DATETIME_ORIGINAL = EXIF_TAGS.get("DateTimeOriginal")

# ==========================================
# POBIERANIE DATY ZDJĘCIA
# ==========================================

def get_photo_date(file_path: Path):

    try:
        image = Image.open(file_path)
        exif = image.getexif()

        if exif and DATETIME_ORIGINAL in exif:

            date_str = exif[DATETIME_ORIGINAL]
            return datetime.strptime(date_str, "%Y:%m:%d %H:%M:%S")

    except Exception:
        pass

    # fallback
    timestamp = file_path.stat().st_mtime
    return datetime.fromtimestamp(timestamp)

# ==========================================
# KOPIOWANIE
# ==========================================

extensions = {
    ".jpg",
    ".jpeg",
    ".png",
    ".heic",
    ".webp"
}

for file in SOURCE_DIR.iterdir():

    if not file.is_file():
        continue

    if file.suffix.lower() not in extensions:
        continue

    photo_date = get_photo_date(file)

    year = f"{photo_date:%Y}"
    month = f"{photo_date:%Y-%m}"

    target_dir = DESTINATION_DIR / year / month
    target_dir.mkdir(parents=True, exist_ok=True)

    destination = target_dir / file.name

    if destination.exists():
        print(f"Pominięto: {file.name}")
        continue

    shutil.copy2(file, destination)
    print(f"Skopiowano: {file.name}")
