#!/bin/bash

# Apply wallpaper using wal
wal -b 282738 -i ~/.config/cozy/wallpaper/120_-_KnFPX73.jpg &&

# Start picom
picom --config ~/.config/picom/picom.conf --experimental-backend &
