#!/bin/bash

# --- Konfiguráció ---
LOG_USER="reboot"
export LC_ALL=C
TODAY=$(date +"%a %b %_d")

# 1. Befejezett munkamenetek
LOGGED_TIME=$(last "$LOG_USER" | grep "$TODAY" | awk '
BEGIN { total_min = 0 }
{
    for (i=1; i<=NF; i++) {
        if ($i ~ /^\(.*\)$/) {
            time_str = substr($i, 2, length($i)-2)
            days = 0
            if (index(time_str, "+") > 0) {
                split(time_str, parts, "+")
                days = parts[1]
                time_str = parts[2]
            }
            split(time_str, t, ":")
            if (length(t) == 2) {
                total_min += (days * 24 * 60) + (t[1] * 60) + t[2]
            }
        }
    }
}
END { print total_min }
')

if [ -z "$LOGGED_TIME" ]; then LOGGED_TIME=0; fi

# 2. Jelenlegi munkamenet
LAST_BOOT_TIME=$(last "$LOG_USER" | grep "$TODAY" | grep "still running" | head -n 1 | sed -E 's/.*([0-9]{2}:[0-9]{2}).*still running.*/\1/')
CURRENT_SESSION_MIN=0

if [ ! -z "$LAST_BOOT_TIME" ]; then
  NOW_EPOCH=$(date +%s)
  BOOT_EPOCH=$(date -d "$LAST_BOOT_TIME" +%s 2>/dev/null)
  if [ ! -z "$BOOT_EPOCH" ]; then
    DIFF_SEC=$((NOW_EPOCH - BOOT_EPOCH))
    if [ $DIFF_SEC -ge 0 ]; then
      CURRENT_SESSION_MIN=$((DIFF_SEC / 60))
    fi
  fi
fi

# 3. Összegzés
TOTAL_MINUTES=$((LOGGED_TIME + CURRENT_SESSION_MIN))
HOURS=$((TOTAL_MINUTES / 60))
MINS=$((TOTAL_MINUTES % 60))

# --- KIMENET KEZELÉSE ---

if [ "$1" == "--polybar" ]; then
  # Ha Polybar módban fut, csak egy ikont és az időt írjuk ki (pl: "⏱ 4ó 12p")
  # A printf %02d gondoskodik a vezető nulláról a percnél (pl. 5 perc -> 05)
  printf "⏱ %dó %02dp" $HOURS $MINS
else
  # Normál terminálos mód
  echo "=========================================="
  echo " Napi GÉPIDŐ (Uptime): $TODAY"
  echo "=========================================="
  echo " Befejezett futások:       $LOGGED_TIME perc"
  echo " Jelenlegi futás:          $CURRENT_SESSION_MIN perc"
  echo " ------------------------------------------"
  echo " Összesen ma:              $HOURS óra $MINS perc"
  echo "=========================================="
fi
