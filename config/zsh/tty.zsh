# Start a graphical session on login: X with dwm on tty1-2, Wayland with dwl on
# tty3-4. A user runs one at a time, since both would share the user's systemd
# manager and D-Bus session bus.
if [[ "$TTY" == /dev/tty<-> ]] && (( ${TTY##/dev/tty} <= 4 )); then
    if pgrep -u "$USER" -x 'dwm|dwl' >/dev/null; then
        print "a graphical session is already running"
    elif (( ${TTY##/dev/tty} <= 2 )); then
        sx
    else
        dwl-session
    fi
fi
