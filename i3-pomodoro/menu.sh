#!/bin/bash

# Elérési utak
POMO_SCRIPT="$HOME/Applications/shell/i3-pomodoro/main.sh"
STATUS_FILE="/tmp/pomodoro_status"

# Alap Rofi parancs stílusok nélkül
ROFI_CMD="rofi -dmenu -i -p "

# Opciók
OPTIONS="󰐊 Indítás (25+5)\n󰒓 Egyéni mód\n󰏤 Szünet / Folytatás\n󰦛 Reset / Stop"

# Választás bekérése
CHOICE=$(echo -e "$OPTIONS" | $ROFI_CMD)

case "$CHOICE" in
*"Indítás (25+5)")
  pkill -f "bash $POMO_SCRIPT"
  bash "$POMO_SCRIPT" 25 5 &
  ;;
*"Egyéni mód")
  # Munkaidő, szünet, hosszú szünet bekérése egy sorban
  INPUT=$(rofi -dmenu -p "Munka, szünet, hosszú szünet (pl. 25 5 15)")
  # Ellenőrzés és feldolgozás
  if [[ ! "$INPUT" =~ ^[0-9]+\ [0-9]+\ [0-9]+$ ]]; then
    exit
  fi
  WORK=$(echo "$INPUT" | awk '{print $1}')
  BREAK=$(echo "$INPUT" | awk '{print $2}')
  LONG_BREAK=$(echo "$INPUT" | awk '{print $3}')

  pkill -f "bash $POMO_SCRIPT"
  bash "$POMO_SCRIPT" "$WORK" "$BREAK" "$LONG_BREAK" &
  ;;
*"Szünet / Folytatás")
  PID=$(pgrep -f "bash $POMO_SCRIPT")
  if [ -n "$PID" ]; then
    STATE=$(ps -o state= -p "$PID")
    if [[ "$STATE" == *"T"* ]]; then
      kill -CONT "$PID"
    else
      kill -STOP "$PID"
      echo "󰏤 PAUSED" >"$STATUS_FILE"
    fi
  fi
  ;;
*"Reset / Stop")
  pkill -f "bash $POMO_SCRIPT"
  pkill -f "break.sh"
  echo "" >"$STATUS_FILE"
  ;;
esac
