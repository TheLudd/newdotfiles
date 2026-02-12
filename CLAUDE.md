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

### Zsh Configuration

Modular setup in `config/zsh/`:
- `.zshrc` sources individual modules
- Modules: aliases.bash, exports.zsh, options.zsh, plugins.zsh, completions.zsh, prompt.zsh

### Suckless Customization

Custom patches applied to submodules in `sources/`. After modifying source:
1. Edit the C source or config.h
2. Run `sudo make clean install` in the source directory
3. Restart the application (for dwm: `Mod+Shift+Q` or use autorandr postswitch hook)
