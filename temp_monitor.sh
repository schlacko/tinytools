#!/bin/bash

THRESHOLD=80

while true; do
  # Hőmérséklet kiolvasása (thermal_zone0)
  TEMP_MILLI=$(cat /sys/class/thermal/thermal_zone0/temp)
  TEMP_C=$((TEMP_MILLI / 1000))

  if [ "$TEMP_C" -ge "$THRESHOLD" ]; then
    notify-send -u critical "VIGYÁZAT: Túlmelegedés!" "A processzor hőmérséklete: ${TEMP_C}°C!"
    sleep 120
  else
    sleep 10
  fi
done
