#!/bin/bash

# Mappa és fájlnév beállítása
DIR="$HOME/Képek/Screenshots"
NAME="screenshot_%Y-%m-%d_%H-%M-%S.png"

# Menu
CHOICE=$(echo -e "Képernyő\nTerület\nAblak" | dmenu -i -p "Screenshot")

# Futas
case "$CHOICE" in
"Képernyő")
  scrot "$NAME" -e "xclip -selection clipboard -t image/png -i \$f; mv \$f $DIR"
  ;;
"Terület")
  scrot -s -f "$NAME" -e "xclip -selection clipboard -t image/png -i \$f; mv \$f $DIR"
  ;;
"Ablak")
  scrot -u "$NAME" -e "xclip -selection clipboard -t image/png -i \$f; mv \$f $DIR"
  ;;
*)
  exit 0
  ;;
esac
