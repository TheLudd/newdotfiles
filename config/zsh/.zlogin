if [[ $(echo $TTY | xargs basename | sed 's/tty//') -le 4 ]]; then
    sx
fi
