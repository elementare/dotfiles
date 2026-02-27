#!/bin/bash

export PATH="$HOME/.config/hypr/scripts:$HOME/.local/bin:$PATH"
export BRIGHTNESS_ICON="/usr/share/icons/Papirus-Dark/64x64/status/brightness-high.svg"
export BRIGHTNESS_APPNAME="OSD"

# Terminate already running polybar, stalonetray, sxhkd and dunst instances
processes=("waybar" "mako" "dunst" "swaybg" "eww.*bar")

for process in "${processes[@]}"; do
    if pgrep -f "$process"; then
        pkill -9 -f "$process" > /dev/null
        sleep 0.1
    fi
done


# Launch stalonetray
# [[ "$RICETHEME" != "z0mbi3" ]] && stalonetray -c "$HOME"/.config/bspwm/stalonetrayrc & sleep 0.1 && xdo hide -N stalonetray && touch "/tmp/syshide.lock"

waybar &

# Inicia uma nova instância do swaybg com o papel de parede desejado
swaybg -i /home/elementare/.config/hypr/walls/wall-04.webp -m fill &

mako &
# Launch dunst notification daemon
# dunst -config "$HOME"/.config/hypr/dunstrc &


# Launch eww daemon
pidof -q ~/eww/target/release/eww || { ~/eww/target/release/eww -c "$HOME"/.config/hypr/eww daemon & }

# Launch polkit
pidof -q polkit-gnome-authentication-agent-1 || { /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & }

# Fix cursor
xsetroot -cursor_name left_ptr
