# Enable autologin
# /etc/systemd/system/getty@tty1.service.d/autologin.conf
#
# [Service]
# ExecStart=
# ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin sarath %I $TERM
#
# Autologin into sway
export XDG_CURRENT_DESKTOP=sway
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec sway

  export GDK_SCALE=1.25
  export GDK_DPI_SCALE=1

  export QT_SCALE_FACTOR=1.25
  export QT_AUTO_SCREEN_SCALE_FACTOR=0
fi

