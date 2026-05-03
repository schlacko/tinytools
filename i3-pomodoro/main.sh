#!/bin/bash

# Argumentumok kezelése
WORK_MINS=${1:-25}
BREAK_MINS=${2:-5}
LONG_BREAK_MINS=${3:-15}
STATUS_FILE="/tmp/pomodoro_status"
COMPLETED_COUNT=0
ICON="" # Győződj meg róla, hogy a Nerd Fontod látja

# Window manager detektálása
if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
  WM_TYPE="sway"
else
  WM_TYPE="x11"
fi

# Idle idő lekérésének függvénye
get_idle_time() {
  if [ "$WM_TYPE" = "sway" ]; then
    # Sway/Wayland: swaymsg segítségével
    swaymsg -t get_seats | jq '.[] | .idle_time' | head -1
  else
    # X11: xprintidle segítségével
    xprintidle
  fi
}

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
  if ((COMPLETED_COUNT > 0 && COMPLETED_COUNT % 4 == 0)); then
    echo "󱐋 HOSSZÚ SZÜNET 󱐋" >$STATUS_FILE
    kitty --title "POMODORO_BREAK" /home/sefy/Applications/shell/i3-pomodoro/break.sh $LONG_BREAK_MINS
    # Sway-ben fullscreen engedélyezése
    if [ "$WM_TYPE" = "sway" ]; then
      sleep 0.5
      swaymsg '[title="POMODORO_BREAK"] fullscreen enable' 2>/dev/null || true
    fi
  else
    echo "󱐋 SZÜNET 󱐋" >$STATUS_FILE
    kitty --title "POMODORO_BREAK" /home/sefy/Applications/shell/i3-pomodoro/break.sh $BREAK_MINS
    # Sway-ben fullscreen engedélyezése
    if [ "$WM_TYPE" = "sway" ]; then
      sleep 0.5
      swaymsg '[title="POMODORO_BREAK"] fullscreen enable' 2>/dev/null || true
    fi
  fi
  # --- AKTIVITÁS VÁRÁSA SZÜNET UTÁN ---

  # 1) várjuk meg, hogy a rendszer idle legyen (pl. break közben ne legyen input)
  while [ "$(get_idle_time)" -lt 2000 ]; do
    sleep 1
  done

  # 2) várjuk meg az első user activity-t
  IDLE_BEFORE=$(get_idle_time)

  while true; do
    CURRENT_IDLE=$(get_idle_time)

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
