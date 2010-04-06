#!/bin/bash

: ${WIN_MANAGER=xmonad}

# xcompmgr &
xrdb -load .Xdefaults
xset -b
xset r rate 199 29
xset +fp "/home/temoto/.fonts"
xsetroot -cursor_name left_ptr
xsetroot -fg "#1e1b1f" -bg "#131011" -mod 4 4
setxkbmap us,ru ,winkeys grp:caps_toggle
xscreensaver &
xbindkeys
eval `dbus-launch --sh-syntax`
gconftool-2 --spawn
gnome-terminal &
gvim &
exec "$WIN_MANAGER"
