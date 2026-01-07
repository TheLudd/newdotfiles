# Auto-start X on TTY 1-4
if [[ $(echo $TTY | xargs basename | sed 's/tty//') -le 4 ]]; then
    sx
fi
