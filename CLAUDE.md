# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Arch Linux dotfiles repository using dwm window manager. Custom forks of suckless tools (dwm, st, dvtm, dmenu, dwmblocks) and truetm live in their own repos, cloned into `~/code/<name>` and installed system-wide (see `repos`).

## Commands

### Set up a machine
`scripts/archinstall/add-user <name>` creates a user, clones this repo into `~/newdotfiles` and runs `init` as that user; the guided Arch install runs it for the first user inside the chroot. After that, logging in offers the last phase.
```bash
./init               # system (until it has finished once on this machine) + user
                     # log out and back in: the next shell offers `init user-login`
./init system        # rerun one phase: system | user | user-login
./init user 30-node  # rerun only the named scripts of a phase
./init apps margin   # optional apps; `./init apps` lists them
```
`user-login` (gh login with the token in gnome-keyring, ssh key upload) needs the keyring that PAM creates at login, so it runs after the relogin: `user/90-pending-login` leaves a marker when it is not done yet, and `config/zsh/pending-setup.zsh` offers it at the tty login and in every terminal until `user-login/10-github` removes the marker. A failing script does not stop the rest of its phase; failures are listed at the end. Every script can be rerun, so after a fix the phase is run again.

### Recompile suckless tools after changes
```bash
cd ~/code/dwm && make && sudo make install
cd ~/code/st && make && sudo make install
```

### Packages
```bash
pis <pkg...>             # pacman install and add to `packages` (`parus` for AUR → `paru-packages`)
pkg-sync                 # list missing packages and extra ones (installed explicitly, not in the files)
pkg-sync install         # install the missing ones
pkg-sync remove [pkg...] # remove the extra ones; one another package needs is marked as a dependency
```
`pacman -S` / `paru -S` without recording is for trying things out; `pkg-sync` cleans that drift up later.

## Architecture

### Directory Structure

- **`init`** - Entry point: `init [system | user | user-login | apps [name...]]`. Without a phase it runs `system` unless `/var/lib/newdotfiles/system-done` exists (written by `run-all` when the whole system phase succeeds), then `user`
- **`run-all`** - Runs the scripts in a phase folder in name order (numbered prefixes set the order), or only the named ones. Exports `lib/zshenv` and `config/zsh/exports.zsh` first, so XDG paths and tool homes (`CARGO_HOME`, `RUSTUP_HOME`, `GOPATH`...) match the login shell before the first relogin. Scripts that depend on an earlier one check for what they need and fail with a pointer to it
- **`system/`** - Once per machine: packages, rustup, paru and AUR packages, sources, `/etc` files (zshenv, locale, hosts, nginx, gnome-keyring PAM unlock on tty login), services
- **`user/`** - Once per user before the relogin: links (config, claude, bin, autorandr hooks, ssh config), docker group and zsh shell, this repo's origin to ssh, `setup-extras`, pnpm + n + node LTS in the home (`PNPM_HOME`, `N_PREFIX`, no sudo), ed25519 key, the marker for `user-login`
- **`user-login/`** - Once per user after the relogin: `gh auth login` with `admin:public_key` and key upload (one login; the token goes into gnome-keyring)
- **`packages`**, **`paru-packages`** - Repo and AUR packages, installed by `system/10-packages` and `system/40-aur-packages`
- **`kept-packages`** - Packages installed by other means that stay (pacstrap base, paru, Kolide); `pkg-sync` skips them
- **`lib/hardware-packages`** - Prints the CPU microcode and GPU driver packages for the machine it runs on (sysfs PCI vendor ids); used by the installer, `system/10-packages` (which also regenerates the GRUB config when it installs microcode) and `pkg-sync`
- **`apps/`** - Optional per-user apps, one script per app (`margin`)
- **`repos`** - Repos cloned into `~/code/<name>` (https, then origin set to ssh) and installed system-wide by `system/50-sources`
- **`lib/clone`** - Clone a repo if missing and set its origin
- **`config/`** - Application configs, symlinked to `~/.config/`
- **`claude/`** - Claude Code config (settings.json, global CLAUDE.md, commands, skills). `user/10-link-claude` symlinks each entry individually into `~/.config/claude/`, which also holds untracked state
- **`bin/`** - User scripts, symlinked to `~/bin/`
- **`systemd/`** - System units, symlinked into `/etc/systemd/system` by `system/70-services`. `download-pacman-upgrades.timer` downloads pending upgrades to the pacman cache every Sunday (`checkupdates -d`, temporary db, no partial upgrade); `pup` installs them
- **`autorandr/`** - Monitor profiles with postswitch hooks, plus `hotplug.rules` and `autorandr-hotplug.service`: DRM hotplug events run autorandr through a unit that first sleeps 3s so a USB-C monitor's link renegotiation has finished before the mode is set. Resume still runs the package's `autorandr.service` directly.
- **`scripts/archinstall/`** - Fresh Arch Linux installation from the live USB. `install-encrypted` creates the first user through `add-user` (from a copy of the repo on the stick, since the chroot cannot see it), which also adds later users and runs `init` for them; in the chroot `systemctl` only enables units and the udev reload is skipped; every `wheel` member has passwordless sudo (`/etc/sudoers.d/wheel`)

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
