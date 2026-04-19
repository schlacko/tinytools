#!/bin/bash

# Argumentumok kezelése
WORK_MINS=${1:-25}
BREAK_MINS=${2:-5}
STATUS_FILE="/tmp/pomodoro_status"
COMPLETED_COUNT=0
ICON="" # Győződj meg róla, hogy a Nerd Fontod látja

# Kilépésnél takarítás
trap "echo '' > $STATUS_FILE; exit" INT TERM

while true; do
  # --- MUNKA SZAKASZ ---
  SECONDS_LEFT=$((WORK_MINS * 60))

  while [ $SECONDS_LEFT -gt 0 ]; do
    # Ikonok generálása a befejezett körök alapján
    ICONS_STR=$(printf "%${COMPLETED_COUNT}s" | sed "s/ /$ICON /g")

    # Idő formázása
    TIME_STR=$(printf "%02d:%02d" $((SECONDS_LEFT / 60)) $((SECONDS_LEFT % 60)))

    # Polybar-nak küldjük: [ikonok] [idő]
    echo "$ICONS_STR$TIME_STR" >$STATUS_FILE

    sleep 1
    ((SECONDS_LEFT--))
  done

  # --- SZÜNET SZAKASZ ---
  echo "󱐋 SZÜNET 󱐋" >$STATUS_FILE

  # Kitty indítása teljes képernyőn az i3wm alatt
  # A --start-as=fullscreen kapcsoló natívan működik kitty-ben
  kitty --start-as=fullscreen --title "POMODORO_BREAK" /home/sefy/Applications/shell/i3-pomodoro/break.sh $BREAK_MINS
  # --- AKTIVITÁS VÁRÁSA SZÜNET UTÁN ---

  # 1) várjuk meg, hogy a rendszer idle legyen (pl. break közben ne legyen input)
  while [ "$(xprintidle)" -lt 2000 ]; do
    sleep 1
  done

  # 2) várjuk meg az első user activity-t
  IDLE_BEFORE=$(xprintidle)

  while true; do
    CURRENT_IDLE=$(xprintidle)

    # ha csökkent az idle time → volt input
    if [ "$CURRENT_IDLE" -lt "$IDLE_BEFORE" ]; then
      break
    fi

    IDLE_BEFORE=$CURRENT_IDLE
    sleep 1
  done
  # Pomodoro számláló növelése a szünet UTÁN
  ((COMPLETED_COUNT++))
done
