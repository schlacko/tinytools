#!/bin/bash

# A mappa, ahol az AppImage fájlok vannak
APPDIR="$HOME/Applications/Appimages"

# Ellenőrizzük, hogy létezik-e a mappa
if [[ ! -d "$APPDIR" ]]; then
  echo "A megadott mappa nem létezik: $APPDIR"
  exit 1
fi

# Listázzuk az AppImage fájlokat és rofi-val kiválasztjuk
APP=$(find "$APPDIR" -maxdepth 1 -type f -name "*.AppImage" -exec basename {} \; | sort | rofi -dmenu -p "AppImage run")

# Ha nem választott a felhasználó, lépjünk ki
[[ -z "$APP" ]] && exit 0

# Indítsuk el a kiválasztott AppImage fájlt
"$APPDIR/$APP" &
