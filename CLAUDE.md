# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Arch Linux dotfiles repository using dwm window manager. Custom forks of suckless tools (dwm, st, dvtm, dmenu, dwmblocks) maintained as git submodules in `sources/`.

## Commands

### Full installation from scratch
```bash
bash init
```

### Run installation scripts only
```bash
bash run-all installs
```

### Run setup/symlink scripts only
```bash
bash run-all setups
```

### Recompile suckless tools after changes
```bash
cd sources/dwm && sudo make clean install
cd sources/st && sudo make clean install
```

### Install system packages
```bash
sudo pacman -S - < packages
paru -S - < paru-packages
```

## Architecture

### Directory Structure

- **`init`** - Main entry point, initializes submodules and runs installs + setups
- **`run-all`** - Executes all scripts in a given folder (e.g., `run-all installs`)
- **`installs/`** - Installation scripts (paru, fonts, compile sources)
- **`setups/`** - Post-install configuration (symlinks, locale, services, ssh)
- **`sources/`** - Git submodules for suckless tools (dwm, st, dvtm, dmenu, dwmblocks)
- **`config/`** - Application configs, symlinked to `~/.config/`
- **`claude/`** - Claude Code config (settings.json, global CLAUDE.md, commands, skills). `setups/claude` symlinks each entry individually into `~/.config/claude/`, which also holds untracked state
- **`bin/`** - User scripts, symlinked to `~/bin/`
- **`autorandr/`** - Monitor profiles with postswitch hooks
- **`scripts/archinstall/`** - Fresh Arch Linux installation scripts

### Configuration Management

Uses direct symlinking via shell scripts (no stow/chezmoi). The `setups/config` script symlinks each app directory in `config/` to `~/.config/`.

### Neovim Setup

Located in `config/nvim/` with Lua configuration:
- LSP via Mason for TypeScript and other languages
- Tree-sitter for syntax highlighting
- Plugins: Telescope, Cmp, Copilot, Noice, Snacks

### Claude Code Hooks

`claude/settings.json` registers `bin/claude-notify` for the `UserPromptSubmit`, `Stop`, `StopFailure` and `Notification` events. It plays a freedesktop sound and sends a dunst notification when Claude finishes a turn longer than 10s, needs input, or fails. It is silent when the Claude terminal is the focused window.

### margin (markdown reader/editor)

margin lives in its own repo at `~/code/margin`. It serves the markdown files in the folders listed in `~/.config/margin/config.json` (untracked, edited from margin's settings screen) at http://localhost:48217 for reading and inline editing. Here it is wired up by:
- `installs/margin`: runs `make install` in `~/code/margin`, installing to `~/.local/bin/margin`, and restarts the service
- `config/systemd/user/margin.service`: a user service, enabled through `default.target.wants`

### Zsh Configuration

Modular setup in `config/zsh/`:
- `.zshrc` sources individual modules
- Modules: aliases.bash, exports.zsh, options.zsh, plugins.zsh, completions.zsh, prompt.zsh

### Suckless Customization

Custom patches applied to submodules in `sources/`. After modifying source:
1. Edit the C source or config.h
2. Run `sudo make clean install` in the source directory
3. Restart the application (for dwm: `Mod+Shift+Q` or use autorandr postswitch hook)
