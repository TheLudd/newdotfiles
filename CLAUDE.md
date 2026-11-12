# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Arch Linux dotfiles repository using dwm window manager. Custom forks of suckless tools (dwm, st, dvtm, dmenu, dwmblocks) and truetm live in their own repos, cloned into `~/code/<name>` and installed system-wide (see `setup/repos`).

## Commands

### Set up a machine
`archinstall/add-user <name>` creates a user, clones this repo into `~/newdotfiles` and runs `init` as that user; the guided Arch install runs it for the first user inside the chroot. After that, logging in offers the last phase.
```bash
./init               # system (until it has finished once on this machine) + user
                     # log out and back in: the next shell offers `init user-login`
./init system        # rerun one phase: system | user | user-login
./init user 30-node  # rerun only the named scripts of a phase
./init apps margin   # optional apps; `./init apps` lists them
./init system github-runner  # rerun one unit's part of a phase
```
A machine's roles are the names in `/etc/newdotfiles/roles`, one per line (`workstation`, `server`). After changing that file, `./init system` and `./init user` set up what the new roles ask for.
`user-login` (gh login with the token in gnome-keyring, ssh key upload) needs the keyring that PAM creates at login, so it runs after the relogin: `setup/user/90-pending-login` leaves a marker when it is not done yet, and `config/zsh/pending-setup.zsh` offers it at the tty login and in every terminal until `setup/user-login/10-github` removes the marker. A failing script does not stop the rest of its phase; failures are listed at the end. Every script can be rerun, so after a fix the phase is run again.

### Recompile suckless tools after changes
```bash
cd ~/code/dwm && make && sudo make install
cd ~/code/st && make && sudo make install
```

### Packages
```bash
pis <pkg...>             # pacman install and add to `setup/packages` (`parus` for AUR → `setup/paru-packages`)
pkg-sync                 # list missing and extra packages (installed explicitly, not in the files); silent when in sync
pkg-sync install         # install the missing ones
pkg-sync remove [pkg...] # remove the extra ones; one another package needs is marked as a dependency
switch-kernel            # pick a kernel; installs it, sets GRUB's default and offers a reboot; the old one goes once the new one has booted
```
`pacman -S` / `paru -S` without recording is for trying things out; `pkg-sync` cleans that drift up later.

## Architecture

### Directory Structure

- **`init`** - Entry point: `init [system | user | user-login | apps [name...]]`. Without a phase it runs `system` unless `/var/lib/newdotfiles/system-done` exists (written by `run-all` when the whole system phase succeeds), then `user`
- **`setup/`** - Everything that sets a machine or a user up. The phase names and paths in this file (`system/10-packages`, `lib/clone`, `packages`) are relative to it
  - **`run-all`** - Runs the scripts in a phase folder in name order (numbered prefixes set the order), then that phase of each of the machine's units, or only the named scripts or units. Exports `lib/zshenv` and `config/zsh/exports.zsh` first, so XDG paths and tool homes (`CARGO_HOME`, `RUSTUP_HOME`, `GOPATH`...) match the login shell before the first relogin. Scripts run with `setup/` as the working directory and reach the rest of the repo through `$DOTFILES`. Scripts that depend on an earlier one check for what they need and fail with a pointer to it
  - **`system/`** - Once per machine: packages, rustup, paru and AUR packages, sources, `/etc` files (zshenv, locale, hosts, nginx, gnome-keyring PAM unlock on tty login), services
  - **`user/`** - Once per user before the relogin: links (config, claude, bin, autorandr hooks, ssh config), docker group and zsh shell, this repo's origin to ssh, `setup-extras`, pnpm + n + node LTS in the home (`PNPM_HOME`, `N_PREFIX`, no sudo), ed25519 key, the marker for `user-login`
  - **`user-login/`** - Once per user after the relogin: `gh auth login` with `admin:public_key` and key upload (one login; the token goes into gnome-keyring)
  - **`roles/`** - One file per role, naming the units a machine with that role gets (`workstation`: machines to work at; `server`: machines that host services). A machine can have several roles, and a unit named by several of them is set up once. What every machine gets is in the phase folders and package files
  - **`units/`** - One folder per unit, a self-contained piece of setup. Each part is optional: `packages` and `paru-packages`, and the executables `system`, `user` and `user-login`, run in the phase of that name. `lib/roles` prints the machine's roles, `lib/units` the units they name, `lib/wanted-packages repo|aur` the packages of the base files and those units (plus kernel and hardware packages for `repo`); `system/10-packages`, `system/40-aur-packages` and `pkg-sync` read the last
  - **`apps/`** - Optional per-user apps, one script per app (`margin`)
  - **`packages`**, **`paru-packages`** - Repo and AUR packages, installed by `system/10-packages` and `system/40-aur-packages`
  - **`kept-packages`** - Packages installed by other means that stay (pacstrap base, paru, Kolide); `pkg-sync` skips them
  - **`pip-packages`** - Packages for the pip venv, installed by `bin/setup-extras`
  - **`repos`** - Repos cloned into `~/code/<name>` (https, then origin set to ssh) and installed system-wide by `system/50-sources`
  - **`lib/kernel-package`** - Prints the machine's kernel: `/etc/newdotfiles/kernel` (chosen in the installer, changed with `switch-kernel`; both pick from `lib/kernels` through the menu in `lib/choose-kernel`), or `linux-lts`; used by `system/10-packages` and `pkg-sync`. `files/pacman-hooks/99-grub.hook` (installed by `system/60-grub`) runs `lib/update-grub` when a kernel is installed or removed, which regenerates grub.cfg with the machine's kernel as the default entry. `switch-kernel` keeps the other kernels as GRUB fallbacks and lists them in `/var/lib/newdotfiles/pending-kernel-cleanup`; the first shell running the chosen kernel offers to remove them (`config/zsh/pending-setup.zsh`)
  - **`lib/hardware-packages`** - Prints the CPU microcode and GPU driver packages for the machine it runs on (sysfs PCI vendor ids), plus `dkms` and the kernel's headers when a chip needs a DKMS driver (`lib/usb-present`); used by the installer (which passes its kernel choice), `system/10-packages`, `switch-kernel` and `pkg-sync`
  - **`lib/clone`** - Clone a repo if missing and set its origin
  - **`lib/install-pnpm`** - Install a standalone pnpm into `PNPM_HOME`; reads no other file, so it can be piped into another user's bash
  - **`files/`** - What the system phase installs outside the home:
    - **`dkms/`** - Drivers built with DKMS, registered by a `system/` script on machines with the chip; the DKMS pacman hook rebuilds them for each installed kernel
    - **`systemd/`** - System units, symlinked into `/etc/systemd/system` by `system/70-services`. `download-pacman-upgrades.timer` downloads pending upgrades to the pacman cache every Sunday (`checkupdates -d`, temporary db, no partial upgrade); `pup` installs them
    - **`nginx/`** - nginx sites, linked into `/etc/nginx/sites-enabled` by `system/60-nginx`
    - **`pacman-hooks/`** - pacman hooks, installed by `system/60-grub`
- **`archinstall/`** - Fresh Arch Linux installation from the live USB. `install-encrypted` creates the first user through `add-user` (from a copy of the repo on the stick, since the chroot cannot see it), which also adds later users and runs `init` for them; in the chroot `systemctl` only enables units and the udev reload is skipped; every `wheel` member has passwordless sudo (`/etc/sudoers.d/wheel`)
- **`config/`** - Application configs, symlinked to `~/.config/`
- **`claude/`** - Claude Code config (settings.json, global CLAUDE.md, commands, skills). `user/10-link-claude` symlinks each entry individually into `~/.config/claude/`, which also holds untracked state
- **`bin/`** - User scripts, symlinked to `~/bin/`
- **`githooks/`** - This repo's git hooks (`core.hooksPath`, set by `user/30-git-hooks`). `reference-transaction` signals dwmblocks (signal 4) on any branch, HEAD or remote-tracking ref change, so the dotfiles block (`bin/check-dotfiles-repo`) updates on commit, push and branch switches
- **`autorandr/`** - Monitor profiles with postswitch hooks, plus `hotplug.rules` and `autorandr-hotplug.service`: DRM hotplug events run autorandr through a unit that first sleeps 3s so a USB-C monitor's link renegotiation has finished before the mode is set. Resume still runs the package's `autorandr.service` directly.

### Configuration Management

Uses direct symlinking via shell scripts (no stow/chezmoi). `setup/user/10-link-config` symlinks each app directory in `config/` to `~/.config/`.

### Neovim Setup

Located in `config/nvim/` with Lua configuration:
- LSP via Mason for TypeScript and other languages
- Tree-sitter for syntax highlighting
- Plugins: Telescope, Cmp, Copilot, Noice, Snacks

### Claude Code Hooks

`claude/settings.json` registers `bin/claude-notify` for the `UserPromptSubmit`, `Stop`, `StopFailure` and `Notification` events. It plays a freedesktop sound and sends a dunst notification when Claude finishes a turn longer than 10s, needs input, or fails. It is silent when the Claude terminal is the focused window.

### Dictation

`bin/dictation-stream` is a streaming speech-to-text daemon: NVIDIA Nemotron 3.5 streaming ASR run on the CPU through sherpa-onnx (installed in the pip venv at `~/.local/share/pip-venv`, see `setup/pip-packages`), typing word by word into the focused window with xdotool. `bin/dictation-toggle` (dwm `Mod+V`) starts/stops it and `bin/dictation-status` feeds the dwmblocks indicator. The model lives in `~/.local/share/dictation/models` and is fetched by `dictation-stream install-model` from `bin/setup-extras`. `config/dictation/replacements.txt` holds "heard => wanted" fixes for words the model mishears; sherpa-onnx only offers greedy decoding for NeMo streaming models, so hotword boosting is not available.

### Bluetooth chip

The Foxconn MediaTek MT7902 Bluetooth chip (USB `0489:e156`) is missing from btusb's id table in stock kernels (the id is in bluetooth-next), so btusb binds it as a generic controller, never loads its firmware and the reset times out (`hci0: Opcode 0x0c03 failed: -110`). `setup/system/60-btusb-mt7902` registers `setup/files/dkms/btusb-mt7902` on machines with the chip: its `fetch-source` downloads btusb.c for the kernel being built from the stable tree and adds the id. A kernel that already has the id gets an unchanged btusb, and the DKMS module can then go.

### Screen blanking and lock

DPMS stays off so USB-C monitor hubs stay awake; the screen is only blanked by the X screensaver. `bin/screen-timeout` sets it from the power state: never on external power (or without a battery), after 10 minutes on battery. `bin/screen-timeout-watch`, started from `config/sx/sxrc`, reruns it on every `power_supply` udev event. `bin/lock` (dwm `Mod+Q`) blanks after 1 minute while slock is up and restores the power policy on unlock.

### Bluetooth headset audio

Audio runs on PipeWire + WirePlumber. `bin/hp` / `bin/hs` switch the headset between A2DP and headset (mic) profile; they disable WirePlumber's `linking.pause-playback` around the switch, since the switch removes the sink and WirePlumber would otherwise pause media players over MPRIS. When a phone on the same multipoint headset takes it over, the browser's stream is left cut off from the sink: `bin/bt-audio-watch` (user service `bt-audio-watch.service`) listens to `pactl subscribe` and runs `bin/bt-audio-reset` (profile off and back) when a bluez sink has a playing stream but is not running, retrying with backoff while the phone holds the headset.

### margin (markdown reader/editor)

margin lives in its own repo at `~/code/margin`. It serves the markdown files in the folders listed in `~/.config/margin/config.json` (untracked, edited from margin's settings screen) at http://margin.local for reading and inline editing. Here it is wired up by:
- `setup/apps/margin` (`init apps margin`): clones `~/code/margin` if missing, runs `make install` there, installing to `~/.local/bin/margin`, and restarts the service
- `config/systemd/user/margin.service`: a user service listening on 127.0.0.1:48217 (`-host margin.local` lets it accept that name), enabled through `default.target.wants` for every user and started only for users who have the binary (`ConditionPathExists`)
- `setup/files/nginx/margin.conf` + `setup/system/60-nginx`: an nginx site on port 80 proxying `margin.local` to the service, linked into `/etc/nginx/sites-enabled`; local connections only
- `setup/system/60-hosts`: maps `margin.local` (and `dev.local`) to 127.0.0.1

### GitHub Actions runners

The `github-runner` unit (role `server`) lets a machine run GitHub Actions jobs for private repositories. Its `system` step creates the `gh-runner` system user (no login, home `/var/lib/gh-runner`, mode 700, not in `wheel` or `docker`) with an id range for rootless podman, installs pnpm in its home and installs the `github-runner` command and the `github-runner@.service` template.
```bash
github-runner add OWNER/REPO     # download a runner, register it to the repo, start it; refuses public repos
github-runner remove OWNER/REPO  # stop, unregister, delete its folder
github-runner list
```
- A runner serves one repository: `~gh-runner/runners/<owner>-<repo>`, service `github-runner@<owner>-<repo>`, labels `self-hosted`, `linux`, `arch`. Which repositories a machine serves is not in this repo
- Jobs run directly on the machine as `gh-runner`, at `Nice=10` / `CPUWeight=20`
- All runners share the node versions that `actions/setup-node` downloads (`AGENT_TOOLSDIRECTORY=~gh-runner/tool-cache`) and pnpm with its versions and store (`PNPM_HOME`; pnpm switches to the project's `packageManager` version itself). Checkouts stay between runs, so `actions/checkout` only fetches
- Jobs start the services they need with `podman compose -f <file> up -d` (the `podman` unit): the first job starts the containers, later jobs find them running. `gh-runner` lingers and the service sets `XDG_RUNTIME_DIR`, which rootless podman needs. Images' health checks are not applied, so a job waits for a service itself
- Workflows use `runs-on: [self-hosted, arch]`, `actions/setup-node` with `node-version-file: package.json` and no `cache:`, and plain `pnpm install --frozen-lockfile`; `pnpm/action-setup` is not needed

### Containers

docker (root daemon, `docker` group) is on every machine. The `podman` unit (roles `workstation` and `server`) adds podman beside it: containers run as the user who starts them, without a daemon, each user with their own images and containers. Its `system` step makes image names without a registry resolve to Docker Hub and makes `podman compose` run `podman-compose`, so compose files written for docker work unchanged.

### Zsh Configuration

Modular setup in `config/zsh/`:
- `.zshrc` sources individual modules
- Modules: aliases.bash, exports.zsh, options.zsh, plugins.zsh, completions.zsh, prompt.zsh

### Suckless Customization

Custom patches live in the forks in `~/code/<name>`. After modifying source:
1. Edit the C source or config.h
2. Run `make && sudo make install` in the source directory
3. Restart the application (for dwm: `Mod+Shift+Q` or use autorandr postswitch hook)
