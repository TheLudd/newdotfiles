# Auto-start X on TTY 1-4
if [[ -n "$TTY" && "$TTY" == /dev/tty* ]]; then
    tty_num=${TTY##/dev/tty}
    if [[ "$tty_num" =~ ^[0-9]+$ && "$tty_num" -le 4 ]]; then
        sx
    fi
fi
