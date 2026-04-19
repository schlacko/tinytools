#!/bin/bash

# --- KONFIGURÁCIÓ ---

# Hány epizódot tölthet le maximum feedenként egy futás alatt?
MAX_EPISODES=5

# A podcastok listája ["Mappa_Neve"]="RSS_URL"
declare -A PODCASTS
#PODCASTS["Contemplata"]="https://rss.buzzsprout.com/2277726.rss"
#PODCASTS["Heti Válasz"]="https://rss.libsyn.com/shows/234224/destinations/1734209.xml"
# Adj hozzá többet igény szerint...

# Könyvtárak
BASE_DIR="$HOME/Letöltések/Podcasts"
TEMP_RSS="/tmp/curr_rss_feed.xml"

# --- ÉRTESÍTÉS BEÁLLÍTÁSA (CRON FIX) ---
# Ez a rész elengedhetetlen, hogy cronból is menjen a notify-send i3 alatt
export DISPLAY=:0
# Megkeressük a DBUS socketet a futó felhasználóhoz (ha nem találja, a notify-send néma marad)
user_id=$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$user_id/bus"

# --- FÜGGVÉNY: ÉRTESÍTÉS KÜLDÉSE ---
send_notification() {
  local title="$1"
  local message="$2"

  # Ellenőrizzük, hogy létezik-e a parancs
  if command -v notify-send >/dev/null; then
    # -u normal: prioritás
    # -t 5000: 5 másodpercig látszódjon
    notify-send -u normal -t 10000 "$title" "$message"
  fi
}

# --- FÜGGVÉNY: EGY FEED FELDOLGOZÁSA ---
process_feed() {
  local folder_name="$1"
  local rss_url="$2"
  local target_dir="$BASE_DIR/$folder_name"
  local log_file="$target_dir/download_history.txt"

  # Számláló az aktuális futáshoz
  local download_count=0

  mkdir -p "$target_dir"
  if [ ! -f "$log_file" ]; then touch "$log_file"; fi

  # RSS letöltése
  curl -s "$rss_url" >"$TEMP_RSS"
  if [ $? -ne 0 ]; then return; fi

  # URL-ek kinyerése
  urls=$(grep -o 'url="[^"]*"' "$TEMP_RSS" | sed 's/url="//;s/"//')

  # Ciklus az epizódokon
  while IFS= read -r url; do
    # 1. Ellenőrzés: Elértük-e a limitet?
    if [ "$download_count" -ge "$MAX_EPISODES" ]; then
      echo "  -> Limit elérve ($MAX_EPISODES db) ennél a feednél: $folder_name"
      break
    fi

    if [ -n "$url" ]; then
      # 2. Ellenőrzés: Volt-e már letöltve?
      if ! grep -Fxq "$url" "$log_file"; then
        echo "Letöltés ($folder_name): $url"

        wget -q --content-disposition -P "$target_dir" "$url"

        if [ $? -eq 0 ]; then
          echo "$url" >>"$log_file"
          ((download_count++))
        fi
      fi
    fi
  done <<<"$urls"

  # Ha történt letöltés, küldünk értesítést
  if [ "$download_count" -gt 0 ]; then
    send_notification "Podcast Frissítés" "$download_count új epizód letöltve: $folder_name"
  fi
}

# --- FŐ PROGRAM ---

if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
  echo "Hiba: Bash 4.0+ szükséges."
  exit 1
fi

for folder in "${!PODCASTS[@]}"; do
  process_feed "$folder" "${PODCASTS[$folder]}"
done

rm -f "$TEMP_RSS"
