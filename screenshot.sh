#!/bin/bash

DIR="$HOME/Képek/Screenshots"
NAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
FILE="$DIR/$NAME"

mkdir -p "$DIR"

CHOICE=$(echo -e "Képernyő\nTerület\nAblak" | dmenu -i -p "Screenshot")

# Környezet detektálás
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  MODE="wayland"
else
  MODE="x11"
fi

case "$CHOICE" in

"Képernyő")
  if [ "$MODE" = "wayland" ]; then
    grim "$FILE"
  else
    scrot "$FILE"
  fi
  ;;

"Terület")
  if [ "$MODE" = "wayland" ]; then
    GEOM=$(slurp)
    [ -z "$GEOM" ] && exit 1
    grim -g "$GEOM" "$FILE"
  else
    scrot -s "$FILE"
  fi
  ;;

"Ablak")
  if [ "$MODE" = "wayland" ]; then
    GEOM=$(swaymsg -t get_tree | jq -r '
        .. | select(.focused? == true)
        | .rect
        | "\(.x),\(.y) \(.width)x\(.height)"
      ')
    grim -g "$GEOM" "$FILE"
  else
    scrot -u "$FILE"
  fi
  ;;

*)
  exit 0
  ;;
esac

# Clipboard kezelés
if [ "$MODE" = "wayland" ]; then
  wl-copy <"$FILE"
else
  xclip -selection clipboard -t image/png -i "$FILE"
fi
