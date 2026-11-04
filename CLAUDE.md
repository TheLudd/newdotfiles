# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Arch Linux dotfiles repository using dwm window manager. Custom forks of suckless tools (dwm, st, dvtm, dmenu, dwmblocks) and truetm live in their own repos, cloned into `~/code/<name>` and installed system-wide (see `repos`).

## Commands

### Set up a machine
Four phases, each run by hand from the repo (cloned over https):
```bash
./init system        # once per machine, as the first user (sudo)
./init user          # once per user
                     # log out and back in
./init user-login    # once per user: ssh key, gh login, key upload
./init apps margin   # optional apps; `./init apps` lists them
```
A failing script does not stop the rest of its phase; failures are listed at the end. Every script can be rerun, so after a fix the phase is run again.

### Recompile suckless tools after changes
```bash
cd ~/code/dwm && make && sudo make install
cd ~/code/st && make && sudo make install
```

### Install system packages
```bash
sudo pacman -S --needed - < packages
xargs -a paru-packages paru -S --needed
```

## Architecture

### Directory Structure

- **`init`** - Entry point: `init system | user | user-login | apps [name...]`
- **`run-all`** - Runs the scripts in a phase folder in name order (numbered prefixes set the order), or only the named ones. Exports `lib/zshenv` and `config/zsh/exports.zsh` first, so XDG paths and tool homes (`CARGO_HOME`, `RUSTUP_HOME`, `GOPATH`...) match the login shell before the first relogin. Scripts that depend on an earlier one check for what they need and fail with a pointer to it
- **`system/`** - Once per machine: packages, rustup, paru and AUR packages, sources, `/etc` files (zshenv, locale, hosts, nginx, gnome-keyring PAM unlock on tty login), services
- **`user/`** - Once per user before the relogin: links (config, claude, bin, autorandr hooks, ssh config), docker group and zsh shell, this repo's origin to ssh, `setup-extras`
- **`user-login/`** - Once per user after the relogin: ed25519 key, `gh auth login` with `admin:public_key` and key upload (one login; the token goes into gnome-keyring)
- **`apps/`** - Optional per-user apps, one script per app (`margin`)
- **`repos`** - Repos cloned into `~/code/<name>` (https, then origin set to ssh) and installed system-wide by `system/50-sources`
- **`lib/clone`** - Clone a repo if missing and set its origin
- **`config/`** - Application configs, symlinked to `~/.config/`
- **`claude/`** - Claude Code config (settings.json, global CLAUDE.md, commands, skills). `user/10-link-claude` symlinks each entry individually into `~/.config/claude/`, which also holds untracked state
- **`bin/`** - User scripts, symlinked to `~/bin/`
- **`systemd/`** - System units, symlinked into `/etc/systemd/system` by `system/70-services`. `download-pacman-upgrades.timer` downloads pending upgrades to the pacman cache every Sunday (`checkupdates -d`, temporary db, no partial upgrade); `pup` installs them
- **`autorandr/`** - Monitor profiles with postswitch hooks, plus `hotplug.rules` and `autorandr-hotplug.service`: DRM hotplug events run autorandr through a unit that first sleeps 3s so a USB-C monitor's link renegotiation has finished before the mode is set. Resume still runs the package's `autorandr.service` directly.
- **`scripts/archinstall/`** - Fresh Arch Linux installation from the live USB. `install-encrypted` creates the first user through `add-user`, which also adds later users; every `wheel` member has passwordless sudo (`/etc/sudoers.d/wheel`)

### Configuration Management

Uses direct symlinking via shell scripts (no stow/chezmoi). `user/10-link-config` symlinks each app directory in `config/` to `~/.config/`.

### Neovim Setup

Located in `config/nvim/` with Lua configuration:
- LSP via Mason for TypeScript and other languages
- Tree-sitter for syntax highlighting
- Plugins: Telescope, Cmp, Copilot, Noice, Snacks

### Claude Code Hooks

`claude/settings.json` registers `bin/claude-notify` for the `UserPromptSubmit`, `Stop`, `StopFailure` and `Notification` events. It plays a freedesktop sound and sends a dunst notification when Claude finishes a turn longer than 10s, needs input, or fails. It is silent when the Claude terminal is the focused window.

### Dictation

`bin/dictation-stream` is a streaming speech-to-text daemon: NVIDIA Nemotron 3.5 streaming ASR run on the CPU through sherpa-onnx (installed in the pip venv at `~/.local/share/pip-venv`, see `pip-packages`), typing word by word into the focused window with xdotool. `bin/dictation-toggle` (dwm `Mod+V`) starts/stops it and `bin/dictation-status` feeds the dwmblocks indicator. The model lives in `~/.local/share/dictation/models` and is fetched by `dictation-stream install-model` from `bin/setup-extras`. `config/dictation/replacements.txt` holds "heard => wanted" fixes for words the model mishears; sherpa-onnx only offers greedy decoding for NeMo streaming models, so hotword boosting is not available.

### Bluetooth headset audio

Audio runs on PipeWire + WirePlumber. `bin/hp` / `bin/hs` switch the headset between A2DP and headset (mic) profile; they disable WirePlumber's `linking.pause-playback` around the switch, since the switch removes the sink and WirePlumber would otherwise pause media players over MPRIS. When a phone on the same multipoint headset takes it over, the browser's stream is left cut off from the sink: `bin/bt-audio-watch` (user service `bt-audio-watch.service`) listens to `pactl subscribe` and runs `bin/bt-audio-reset` (profile off and back) when a bluez sink has a playing stream but is not running, retrying with backoff while the phone holds the headset.

### margin (markdown reader/editor)

margin lives in its own repo at `~/code/margin`. It serves the markdown files in the folders listed in `~/.config/margin/config.json` (untracked, edited from margin's settings screen) at http://margin.local for reading and inline editing. Here it is wired up by:
- `apps/margin` (`init apps margin`): clones `~/code/margin` if missing, runs `make install` there, installing to `~/.local/bin/margin`, and restarts the service
- `config/systemd/user/margin.service`: a user service listening on 127.0.0.1:48217 (`-host margin.local` lets it accept that name), enabled through `default.target.wants` for every user and started only for users who have the binary (`ConditionPathExists`)
- `nginx/margin.conf` + `system/60-nginx`: an nginx site on port 80 proxying `margin.local` to the service, linked into `/etc/nginx/sites-enabled`; local connections only
- `system/60-hosts`: maps `margin.local` (and `dev.local`) to 127.0.0.1

### Zsh Configuration

Modular setup in `config/zsh/`:
- `.zshrc` sources individual modules
- Modules: aliases.bash, exports.zsh, options.zsh, plugins.zsh, completions.zsh, prompt.zsh

### Suckless Customization

Custom patches live in the forks in `~/code/<name>`. After modifying source:
1. Edit the C source or config.h
2. Run `make && sudo make install` in the source directory
3. Restart the application (for dwm: `Mod+Shift+Q` or use autorandr postswitch hook)
