# Enable autologin
# /etc/systemd/system/getty@tty1.service.d/autologin.conf
#
# [Service]
# ExecStart=
# ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin sarath %I $TERM
#
# Autologin into sway
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec sway
fi

