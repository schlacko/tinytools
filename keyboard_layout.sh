#!/bin/bash

#Menu
CHOICE=$(echo -e "hu\nus" | dmenu -i -p "Keyboard layout")

#Futas

case "$CHOICE" in
"hu")
  setxkbmap -layout hu
  ;;
"us")
  setxkbmap -layout us -variant intl
  ;;
*)
  exit 0
  ;;
esac
