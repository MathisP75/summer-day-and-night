#!/bin/sh

# getting json config values
THEME_CONFIG="~/.config/hypr/themes/$1/$1.json"
GTK_THEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".gtkTheme")
KVANTUM_THEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".kvantumTheme")
COLOR_SCHEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".colorScheme")
ICON_THEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".iconTheme")
FONT=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".font")
NVIM_THEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".nvimTheme")
OBSIDIAN_THEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".obsidianTheme")
VS_CODE_THEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".vsCodeTheme")
VS_CODE_EXTRA_COLORS=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".vsCodeExtraColors")
DARK_READER_BACKGROUND_COLOR=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".darkReaderColors.background")
DARK_READER_TEXT_COLOR=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".darkReaderColors.text")

# wallpaper
killall hyprpaper
hyprpaper -c ~/.config/hypr/hyprpaper/$COLOR_SCHEME.conf &

# Change Waybar output depending on monitor
source ~/.config/hypr/scripts/detect-outputs.sh
sed -i -E 's/("output": ")(.*)(",)/\1'"$MAIN_DISPLAY"'\3/g' ~/.config/waybar/$COLOR_SCHEME/config

# waybar
killall waybar
waybar --config ~/.config/waybar/$COLOR_SCHEME/config --style ~/.config/waybar/$COLOR_SCHEME/style.css &

# gtk theme
sh ~/.config/hypr/scripts/set-gtk-theme.sh $GTK_THEME

# Kvantum Theme
if [[ ! "$KVANTUM_THEME" ]] # If no kvantum theme is set, use gtk2 QT style
then 
    sed -i -E 's/(style=)(.*)/\1'"gtk2"'/g' ~/.config/qt5ct/qt5ct.conf
else
    sed -i -E 's/(style=)(.*)/\1'"kvantum"'/g' ~/.config/qt5ct/qt5ct.conf
    kvantummanager --set $KVANTUM_THEME
fi

# font
gsettings set org.gnome.desktop.interface font-name "$FONT"
sed -i -E 's/(fixed=")(.*)(,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*)/\1'"$FONT"'\3/g' ~/.config/qt5ct/qt5ct.conf
sed -i -E 's/(general=")(.*)(,.*,.*,.*,.*,.*,.*,.*,.*,.*,.*)/\1'"$FONT"'\3/g' ~/.config/qt5ct/qt5ct.conf

# icon theme
gsettings set org.gnome.desktop.interface icon-theme $ICON_THEME
sed -i -E 's/(icon_theme=)(.*)/\1'"$ICON_THEME"'/g' ~/.config/qt5ct/qt5ct.conf

# kitty
sed -i '1d' ~/.config/kitty/kitty.conf
sed -i '1i\include colors/'$COLOR_SCHEME'.conf' ~/.config/kitty/kitty.conf
kill -s USR1 $(pidof kitty) # reload kitty config

# vs code theme
sed -i -E 's/("workbench.colorTheme": ")(.*)(",)/\1'"$VS_CODE_THEME"'\3/g' '.config/Code - OSS/User/settings.json'
sed -i -E 's/("workbench.colorCustomizations": \{)(.*)(\},)/\1'"$VS_CODE_EXTRA_COLORS"'\3/g' '.config/Code - OSS/User/settings.json'
sed -i -E 's/("editor.fontFamily": ")(.*)(,.*,.*",)/\1'"$FONT"'\3/g' '.config/Code - OSS/User/settings.json'

# Nvim theme
sed -i -E '8 s/(theme = ")(.*)(",)/\1'"$NVIM_THEME"'\3/g' ~/.config/nvim/lua/custom/chadrc.lua

# Obsidian theme (change the vault name/directory)
VAULT_DIRECTORY="Documents/Obsidian Vault"
sed -i -E 's/("cssTheme": ")(.*)(",)/\1'"$OBSIDIAN_THEME"'\3/g' "$VAULT_DIRECTORY/.obsidian/appearance.json"
sed -i -E 's/("textFontFamily": ")(.*)(",)/\1'"$FONT"'\3/g' "$VAULT_DIRECTORY/.obsidian/appearance.json"
sed -i -E 's/("monospaceFontFamily": ")(.*)(",)/\1'"$FONT"'\3/g' "$VAULT_DIRECTORY/.obsidian/appearance.json"
sed -i -E 's/("interfaceFontFamily": ")(.*)(")/\1'"$FONT"'\3/g' "$VAULT_DIRECTORY/.obsidian/appearance.json"

# Webcord
rm ~/.config/WebCord/Themes/*
cp ~/.config/themes/webcord/$COLOR_SCHEME ~/.config/WebCord/Themes/

# Betterdiscord
cp ~/.config/themes/betterdiscord/$COLOR_SCHEME/themes.json ~/.config/BetterDiscord/data/stable/

# Firefox
rm -r ~/.mozilla/firefox/*.default-release/chrome
cp -r ~/.config/themes/firefox/$COLOR_SCHEME/chrome ~/.mozilla/firefox/*.default-release/

# Zathura theme
cp ~/.config/themes/zathura/$COLOR_SCHEME/zathurarc ~/.config/zathura/

# Dark Reader colors
sqlite3 .mozilla/firefox/*.default-release/storage-sync-v2.sqlite "UPDATE storage_sync_data SET data = json_replace(data, '$.theme.darkSchemeBackgroundColor', '$DARK_READER_BACKGROUND_COLOR') WHERE ext_id LIKE 'addon@darkreader.org';"
sqlite3 .mozilla/firefox/*.default-release/storage-sync-v2.sqlite "UPDATE storage_sync_data SET data = json_replace(data, '$.theme.darkSchemeTextColor', '$DARK_READER_TEXT_COLOR') WHERE ext_id LIKE 'addon@darkreader.org';"
