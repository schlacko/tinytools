#!/bin/bash

# Frissítések ellenőrzése (biztonságos módon)
updates=$(checkupdates | wc -l)

# Csak akkor küldünk értesítést, ha van mit frissíteni
if [ "$updates" -gt 0 ]; then
  notify-send -u normal -i software-update-available \
    "Rendszerfrissítés" \
    "Összesen $updates frissíthető csomag vár rád."
else
  # Opcionális: ha látni akarod, hogy lefutott, de nincs frissítés
  echo "Minden naprakész."
fi
