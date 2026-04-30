#!/bin/bash

DIR="$HOME/Képek/Screenshots"
NAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

mkdir -p "$DIR"

FILE="$DIR/$NAME"

CHOICE=$(echo -e "Képernyő\nTerület\nAblak" | dmenu -i -p "Screenshot")

case "$CHOICE" in
"Képernyő")
  grim "$FILE"
  ;;

"Terület")
  GEOM=$(slurp)
  [ -z "$GEOM" ] && exit 1
  grim -g "$GEOM" "$FILE"
  ;;

"Ablak")
  grim -g "$(swaymsg -t get_tree | jq -r '
      .. | select(.focused? == true)
      | .rect
      | "\(.x),\(.y) \(.width)x\(.height)"
    ')" "$FILE"
  ;;

*)
  exit 0
  ;;
esac

wl-copy <"$FILE"
