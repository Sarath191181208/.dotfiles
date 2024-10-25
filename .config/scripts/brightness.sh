#!/bin/sh
set -eu
# You can call this script like this:
# $./brightness.sh up
# $./brightness.sh down

get_brightness () {
    b=$(brightnessctl i | rg "\(.*\)" | sed 's/.*(\([0-9]*\)%.*/\1/')
}

send_notification () {
    # Send the notification
    brightness_level=$(printf "%.0f" "$b")
    # urgency="normal"
    body="Brightness: $brightness_level%"
    notify-send "Brightness" "$body" -i /usr/share/icons/misc/display-brightness.svg
}

case $1 in
up|down)
    if [ "$1" = "up" ]; then
        brightnessctl s "+5%" > /dev/null
    else
        brightnessctl s "5%-" > /dev/null
    fi
    get_brightness
    send_notification
    ;;
esac
