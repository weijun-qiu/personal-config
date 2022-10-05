#!/bin/sh

xrandr --fb 5712x3328 \
  --output HDMI-1 --mode 3840x2160 --pos 0x580 \
  --output HDMI-0 --scale 1.3x1.3 --mode 2560x1440 --rotate left  --pos 3840x0
