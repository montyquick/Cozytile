#!/bin/bash

# Apply wallpaper using wal
wal -b 282738 -i ~/.config/cozy/wallpaper/Aesthetic2.png &&

# Start picom
picom --config ~/.config/picom/picom.conf --experimental-backend &
