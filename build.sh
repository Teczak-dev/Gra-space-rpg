#!/bin/sh

# Nazwa pliku wynikowego
OUTPUT="Rpg2D.love"

# Ścieżka do katalogu projektu (domyślnie bieżący katalog)
PROJECT_DIR="."

# Sprawdzenie, czy istnieje plik wynikowy i usunięcie go, jeśli istnieje
if [ -f "$OUTPUT" ]; then
    echo "Usuwam istniejący plik $OUTPUT..."
    rm "$OUTPUT"
fi

# Tworzenie pliku .love z najwyższym stopniem kompresji (-9)
echo "Pakowanie projektu do $OUTPUT..."
zip -9 -r "$OUTPUT" "$PROJECT_DIR" -x "*.git*" "*build*" "*node_modules*" "*__pycache__*" "*.*~"

echo "Zakończono tworzenie $OUTPUT."