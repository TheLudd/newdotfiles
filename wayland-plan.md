# dwl alongside dwm: Wayland migration plan

## Goal

The setup will offer dwl on Wayland next to dwm on X, chosen by tty: tty1-2 start X, tty3-4 start dwl, the rest stay plain terminals. The X session stays fully intact until the Wayland session is proven.

- Each user runs one graphical session at a time; several users run theirs side by side on separate ttys.
- Scripts keep their names; the Wayland versions live in `bin/wayland/`, first in `PATH` in the dwl session.
- st and dmenu stay for X; the Wayland session uses foot and wmenu.

## Steps

1. **Packages.** `setup/packages` gains the Wayland stack; nothing is removed.
    - `wlroots` (the version the dwl tag targets), `wayland-protocols`, `xorg-xwayland`
    - `foot`, `wmenu`, `swaybg`, `kanshi`, `swaylock`, `swayidle`
    - `grim`, `slurp`, `wf-recorder`, `wl-clipboard`, `wtype`, `wlopm`, `xdg-desktop-portal-wlr`
    - `setup/paru-packages` gains `lswt`.
    - foot and wmenu come from packages: foot is set up in `foot.ini` at runtime and wmenu takes only command-line options, so neither is cloned.
2. **dwl fork on GitHub.** dwl lives on Codeberg; the fork will be pushed to GitHub once, the same way st, dmenu, dwm and dwmblocks are:
    ```sh
    gh repo create TheLudd/dwl --public
    git clone https://codeberg.org/dwl/dwl ~/code/dwl
    cd ~/code/dwl
    git remote rename origin upstream
    git remote add origin git@github.com:TheLudd/dwl.git
    git checkout -b master <release tag matching Arch's wlroots>
    git push -u origin master
    ```
    `setup/user-repos` then lists it, so `user/50-sources` clones it per user and installs it into `~/.local` like dwm:
    ```
    dwl https://github.com/TheLudd/dwl.git git@github.com:TheLudd/dwl.git
    ```
3. **dwl config.** In the fork:
    - Port keybindings and rules from dwm's `config.h` (Mod+V, Mod+Q, Mod+S, Mod+W).
    - Apply the `bar`, `systray` and `foreign-toplevel` patches.
    - Extend dwl's rules with a position and size, so the webcam rule floats the preview at 320x180 in the bottom-right corner, 20px from the edges. dwl opens new windows on the monitor under the mouse, as the X version does.
    - Add a function that animates the focused floating window to fullscreen and back, frame by frame from a timer in dwl's event loop, bound to the key that runs `webcam fullscreen` in dwm.
    - Add inactive-window opacity through `wlr_scene_buffer_set_opacity`.
    - Set `monrules` (scale, mode, position per output) and `xkb_rules` for the keymap.
4. **Session start.**
    - `config/dwl/startup` runs dunst, nm-applet, blueman-applet, `swaybg`, `kanshi`, `screen-timeout-watch` and `dwmblocks -p` feeding the bar. It exports `PATH="$HOME/bin/wayland:$PATH"` and `ELECTRON_OZONE_PLATFORM_HINT=auto`, and runs `systemctl --user import-environment WAYLAND_DISPLAY`.
    - `config/zsh/tty.zsh` runs `sx` on tty1-2 and `dwl -s ~/.config/dwl/startup` on tty3-4, and refuses to start either while `dwm` or `dwl` already runs for the user:
    ```zsh
    if [[ "$TTY" == /dev/tty<-> ]]; then
        if pgrep -u "$USER" -x 'dwm|dwl' >/dev/null; then
            print "a graphical session is already running"
        else
            case ${TTY##/dev/tty} in
                1|2) sx ;;
                3|4) dwl -s ~/.config/dwl/startup ;;
            esac
        fi
    fi
    ```
5. **Wayland scripts.** `bin/wayland/` holds the same names as their X versions:
    - `lock` (swaylock, with swayidle powering the monitors off after 1 minute: `wlopm --off '*'`)
    - `screenshot` (`grim -g "$(slurp)" - | wl-copy -t image/png`)
    - `screen-record` (`wf-recorder -g "$(slurp)"`, stopped with SIGINT)
    - `screen-timeout` (restarts swayidle with the timeout for the power state; on timeout `wlopm --off '*'` powers the monitors off, on activity `wlopm --on '*'`)
    - `webcam` (mpv with `--wayland-app-id=webcam`; no `xdotool`, the dwl rule places it)
    - `claude-notify` (silent when the focused toplevel listed by `lswt` is the Claude terminal, matched by title)
    - `dmenu`, a wrapper running `wmenu` with the same arguments, so `switch-wifi` and `set-headphones` stay untouched
6. **Shared changes**, with X behaviour unchanged:
    - `config/zsh/path.zsh` puts `$HOME/bin/wayland` first when `WAYLAND_DISPLAY` is set:
      ```zsh
      [[ -n "$WAYLAND_DISPLAY" ]] && path=("$HOME/bin/wayland" $path)
      ```
    - `claude/settings.json` calls `claude-notify` by name instead of `$HOME/bin/claude-notify`.
    - `bin/dictation-stream` types with `wtype` instead of `xdotool` when `WAYLAND_DISPLAY` is set.
    - `config/dunst/dunstrc` sets `dmenu = dmenu`, so the context menu (`ctrl+shift+period`) finds dmenu on X and the wmenu wrapper on Wayland.
7. **Configs.** `config/foot/foot.ini` and `config/kanshi/config` (profiles; the `docked` primary choice moves to dwl's `monrules`).
8. **Docs.** CLAUDE.md gains a Wayland section: the tty mapping, `bin/wayland/`, dwl in `user-repos`, kanshi.

## Decisions

| Point | Decision |
| --- | --- |
| Blanking | Monitors power off (`wlopm --off`), unlike X, where DPMS stays off for the USB-C hub. To be retested with the hub at home |
| `claude-notify` focus check | dwl `foreign-toplevel` patch + `lswt`; silent while the Claude terminal has focus, as today |
| Webcam | Fixed corner placement from a dwl rule; the fullscreen animation moves into dwl itself |
| Serein voice keys | Work only while Serein has focus; not used today |
| dunst context menu | `dmenu` by name in `dunstrc` |

The home USB-C monitor flap needs a retest with kanshi, since the 3s settle delay lives in `autorandr-hotplug.service`.

## Running both

Each user runs one graphical session at a time. Two users each run their own, X or dwl, on separate ttys: each user has their own systemd user manager and D-Bus session bus, and logind hands the display and devices to the session on the active VT. The `tty.zsh` guard checks only the user's own processes (`pgrep -u "$USER"`).

Two sessions for one user would clash, because they share that user's systemd user manager and D-Bus session bus:

- only one dunst can own `org.freedesktop.Notifications`
- only one bar can own `StatusNotifierWatcher`
- `DISPLAY` / `WAYLAND_DISPLAY` in the user manager is whatever the last session imported
- `xdg-desktop-portal` keeps the desktop it started with
- dictation has a single pidfile

Shared without changes:

- `dwmblocks` runs with `-p` under dwl, so every `kill -N $(pidof dwmblocks)` keeps working.
- `switch-wifi` and `set-headphones` reach wmenu through the `bin/wayland/dmenu` wrapper.
- `autorandr-hotplug.service` fails without an X display in the Wayland session, which has no effect.
- Serein, Chrome, Brave, Slack, Discord and Spotify pick their backend from the environment.

What doubles: keybindings and rules live in both dwm's and dwl's `config.h`, and `sxrc` and `config/dwl/startup` would share their common part through a sourced file.
