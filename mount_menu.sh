#!/bin/bash

USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Eszközök listázása (csak partíciók)
DEVICES=$(lsblk -lpno NAME,SIZE,TYPE | awk '$3=="part"{print $1" ("$2")"}')

DEVICE=$(echo "$DEVICES" | rofi -dmenu -p "Válaszd ki az eszközt")
[ -z "$DEVICE" ] && exit

DEVICE=$(echo "$DEVICE" | awk '{print $1}')

# Mount pont
MOUNT_POINT=$(echo "/mnt/kulso" | rofi -dmenu -p "Mount pont")
[ -z "$MOUNT_POINT" ] && exit

sudo mkdir -p "$MOUNT_POINT"

# Fájlrendszer felismerés
FS=$(lsblk -no FSTYPE "$DEVICE")

# Opciók kiválasztása
case "$FS" in
ntfs | vfat | exfat)
  OPTIONS="uid=$USER_ID,gid=$GROUP_ID,umask=022"
  ;;
ext4 | ext3 | ext2)
  OPTIONS="defaults"
  ;;
*)
  OPTIONS=$(echo "defaults" | rofi -dmenu -p "Ismeretlen FS ($FS), opciók")
  ;;
esac

# Megerősítés
CONFIRM=$(echo -e "Igen\nNem" | rofi -dmenu -p "Mountolod?\n$DEVICE → $MOUNT_POINT\n($FS)")

[ "$CONFIRM" != "Igen" ] && exit

# Mount
if sudo mount -o "$OPTIONS" "$DEVICE" "$MOUNT_POINT"; then
  # ext esetén tulajdonos állítás
  if [[ "$FS" == ext* ]]; then
    sudo chown "$USER_ID:$GROUP_ID" "$MOUNT_POINT"
  fi

  notify-send "Sikeres mount" "$DEVICE → $MOUNT_POINT"
else
  notify-send "Hiba" "Mount sikertelen"
fi
