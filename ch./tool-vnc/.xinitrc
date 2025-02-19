#!/bin/bash
#

: "${DISPLAY:=":0"}"
export DISPLAY

# # Load resources
# for file in "$HOME/.Xresources" "/etc/X11/Xresources"; do
# 	if [ -f "$file" ]; then
# 		echo "Loading resource: $file"
# 		xrdb -merge "$file"
# 	fi
# done

# # Load keymaps
# for file in "$HOME/.Xkbmap" "/etc/X11/Xkbmap"; do
# 	if [ -f "$file" ]; then
# 		echo "Loading keymap: $file"
# 		# shellcheck disable=SC2046
# 		setxkbmap $(<"$file")
# 		XKB_IN_USE=yes
# 	fi
# done

# # Load xmodmap if not using XKB
# if [ -z "$XKB_IN_USE" ]; then
# 	for file in "$HOME/.Xmodmap" "/etc/X11/Xmodmap"; do
# 		if [ -f "$file" ]; then
# 			echo "Loading modmap: $file"
# 			xmodmap "$file"
# 		fi
# 	done
# fi

# unset XKB_IN_USE

exec dbus-launch --exit-with-session xfce4-session
