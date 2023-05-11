#!/bin/sh

# gsettings
gsettings set org.gnome.desktop.interface gtk-theme $1
gsettings set org.gnome.desktop.wm.preferences theme $1

# gtk 2.0
sed -i -E 's/(gtk-theme-name=")(.*)(")/\1'$1'\3/g' ~/.gtkrc-2.0

# gtk 3.0
sed -i -E 's/(gtk-theme-name=)(.*)/\1'$1'/g' ~/.config/gtk-3.0/settings.ini

# gtk 4.0
rm -r ~/.config/gtk-4.0/*
cp -r /usr/share/themes/$1/gtk-4.0/* ~/.config/gtk-4.0/ || cp -r ~/.themes/$1/gtk-4.0/* ~/.config/gtk-4.0/
