#!/bin/bash

entries="Mocha\nNord\nSolarized\nGruvbox\nTokyo-Night\nDracula\nEverforest\nSummer-Day\nSummer-Night"
source='source = ~/.config/hypr/themes/'
hyprland-conf=~/.config/hypr/hyprland.conf
# delete-line="$(sed -i '1d' ~/.config/hypr/hyprland.conf)"

selected=$(echo -e $entries|wofi --dmenu $2 --style ~/.config/wofi/themes/$1.css --hide-scroll --cache-file /dev/null)

case $selected in
  Mocha)
    notify-send "Mocha"
    sed -i '1d' ~/.config/hypr/hyprland.conf
    sed -i '1i\source = ~/.config/hypr/themes/mocha/mocha.conf' ~/.config/hypr/hyprland.conf
    ;;
  Nord)
    notify-send "Nord"
    sed -i '1d' ~/.config/hypr/hyprland.conf
    sed -i '1i\source = ~/.config/hypr/themes/nord/nord.conf' ~/.config/hypr/hyprland.conf
    ;;
  Solarized)
    notify-send "Solarized"
    sed -i '1d' ~/.config/hypr/hyprland.conf
    sed -i '1i\source = ~/.config/hypr/themes/solarized/solarized.conf' ~/.config/hypr/hyprland.conf
    ;;
  Gruvbox)
    notify-send "Gruvbox"
    sed -i '1d' ~/.config/hypr/hyprland.conf
    sed -i '1i\source = ~/.config/hypr/themes/gruvbox/gruvbox.conf' ~/.config/hypr/hyprland.conf
    ;;
  Everforest)
    notify-send "Everforest"
    sed -i '1d' ~/.config/hypr/hyprland.conf
    sed -i '1i\source = ~/.config/hypr/themes/everforest/everforest.conf' ~/.config/hypr/hyprland.conf
    ;;
  Summer-Day)
    notify-send "Summer-Day"
    sed -i '1d' ~/.config/hypr/hyprland.conf
    sed -i '1i\source = ~/.config/hypr/themes/summer-day/summer-day.conf' ~/.config/hypr/hyprland.conf
    ;;
  Summer-Night)
    notify-send "Summer-Night"
    sed -i '1d' ~/.config/hypr/hyprland.conf
    sed -i '1i\source = ~/.config/hypr/themes/summer-night/summer-night.conf' ~/.config/hypr/hyprland.conf
    ;;
esac