#!/bin/bash

# ---- Rofi Powermenu (i3 + Openbox kompatibilis, hibakezeléssel) ----

# Menüelemek
options=(
  "Lock Screen"
  "Logout"
  "Reboot"
  "Shutdown"
  "Suspend"
  "Cancel"
)

# Rofi megjelenítés
chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Power Menu" -theme-str 'window {width: 20em;}')

# Kijelentkezés függvény
logout() {
  # i3 kilépés (ha fut)
  if command -v i3-msg &>/dev/null && pgrep -x i3 >/dev/null; then
    i3-msg exit 2>/dev/null || true
  fi

  # Openbox kilépés (ha fut)
  if command -v openbox &>/dev/null && pgrep -x openbox >/dev/null; then
    openbox --exit 2>/dev/null || true
  fi
}

# Biztosítási függvény (y/n)
confirm() {
  rofi -dmenu -p "$1 (y/n)" | grep -iq "^y"
}

# Menü választás
case "$chosen" in
"Lock Screen")
  if confirm "Biztos zárolni akarod a képernyőt?"; then
    if command -v slock &>/dev/null; then
      slock
    elif command -v i3lock &>/dev/null; then
      i3lock
    else
      notify-send "Lock képernyő nem található"
    fi
  fi
  ;;
"Logout")
  if confirm "Biztos kijelentkezel?"; then
    logout
  fi
  ;;
"Reboot")
  if confirm "Biztos újra akarod indítani a rendszert?"; then
    systemctl reboot
  fi
  ;;
"Shutdown")
  if confirm "Biztos le akarod állítani a gépet?"; then
    systemctl poweroff
  fi
  ;;
"Suspend")
  if confirm "Biztos felfüggeszted a rendszert?"; then
    systemctl suspend
  fi
  ;;
"Cancel" | *)
  exit 0
  ;;
esac
