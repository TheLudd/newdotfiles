# PATH configuration
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.yarn/bin:$XDG_DATA_HOME/pnpm/bin:$XDG_DATA_HOME/pnpm:$XDG_DATA_HOME/npm/bin:$XDG_DATA_HOME/n/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

# The Wayland session's versions of commands that exist for both sessions
# (bin/dwl-session); path.zsh sets PATH anew in every shell.
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    path=("$HOME/bin/wayland" $path)
fi
