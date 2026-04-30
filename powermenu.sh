#!/bin/bash

options=(
  "Lock Screen"
  "Logout"
  "Reboot"
  "Shutdown"
  "Suspend"
  "Cancel"
)

chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Power Menu" \
  -theme-str 'window {width: 20em;}')

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  MODE="wayland"
else
  MODE="x11"
fi

logout() {
  if [ "$MODE" = "wayland" ]; then
    swaymsg exit
  else
    pkill i3 2>/dev/null || true
    pkill openbox 2>/dev/null || true
  fi
}

lock() {
  if [ "$MODE" = "wayland" ]; then
    # Wayland lock (KÖTELEZŐ)
    if command -v swaylock &>/dev/null; then
      swaylock
    else
      notify-send "swaylock nincs telepítve"
    fi
  else
    # X11 lock
    if command -v slock &>/dev/null; then
      slock
    else
      notify-send "slock nincs telepítve"
    fi
  fi
}

confirm() {
  rofi -dmenu -p "$1 (y/n)" | grep -iq "^y"
}

case "$chosen" in
"Lock Screen")
  confirm "Biztos zárolod?" && lock
  ;;

"Logout")
  confirm "Biztos kilépsz?" && logout
  ;;

"Reboot")
  confirm "Újraindítás?" && systemctl reboot
  ;;

"Shutdown")
  confirm "Leállítás?" && systemctl poweroff
  ;;

"Suspend")
  confirm "Felfüggesztés?" && systemctl suspend
  ;;

*)
  exit 0
  ;;
esac
