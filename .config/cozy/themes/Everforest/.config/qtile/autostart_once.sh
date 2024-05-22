#!/bin/bash

# Apply wallpaper using wal
wal -b 232A2E -i ~/.config/cozy/wallpaper/fog_forest_2.png &&

# Start picom
picom --config ~/.config/picom/picom.conf --experimental-backend &


