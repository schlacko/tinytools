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
  # Munkaidő bekérése
  WORK=$(rofi -dmenu -p "Munkaidő (perc)")
  [[ -z "$WORK" || ! "$WORK" =~ ^[0-9]+$ ]] && exit

  # Szünidő bekérése
  BREAK=$(rofi -dmenu -p "Szünidő (perc)")
  [[ -z "$BREAK" || ! "$BREAK" =~ ^[0-9]+$ ]] && exit

  pkill -f "bash $POMO_SCRIPT"
  bash "$POMO_SCRIPT" "$WORK" "$BREAK" &
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
