#!/bin/bash

# Az első argumentum ($1) most PERC.
# Ha üres, alapértelmezetten 5 perc lesz.
MINUTES=${1:-5}

# Átszámoljuk másodpercekre a belső számlálóhoz
SECONDS_LEFT=$((MINUTES * 60))

trap "tput cnorm; tput sgr0; clear; exit" INT TERM
tput civis

while [ $SECONDS_LEFT -ge 0 ]; do
  TIME_STR=$(printf "%02d:%02d" $((SECONDS_LEFT / 60)) $((SECONDS_LEFT % 60)))
  LINES=$(tput lines)
  COLS=$(tput cols)

  clear
  Y_OFFSET=$(((LINES - 6) / 2))
  tput cup $Y_OFFSET 0
  tput setaf 2
  tput bold

  figlet -c -f standard -w "$COLS" "$TIME_STR"
  tput sgr0

  sleep 1
  ((SECONDS_LEFT--))
done

tput cnorm
clear
exit
