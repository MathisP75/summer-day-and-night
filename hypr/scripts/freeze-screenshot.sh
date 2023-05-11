#!/bin/sh


${hyprpicker}/bin/hyprpicker -r -z & picker_proc=$!

if [ $1 -eq 0 ]
then
    ${grimblast}/bin/grimblast save area "$HOME/Pictures/screenshots/$(date +'%s_grim.png')"
elif [ $1 -eq 1 ]
then
    ${grimblast}/bin/grimblast save area - | wl-copy
fi

hyprctl dispatch movecursor 0,0

kill $picker_proc
