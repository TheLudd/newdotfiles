# Editor
export EDITOR='nvim'

# XDG Base Directory Specification compliance
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PNPM_HOME=$XDG_DATA_HOME/pnpm
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history
export REDISCLI_RCFILE="$XDG_CONFIG_HOME"/redis/redisclirc
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export GHCUP_USE_XDG_DIRS=true
export STACK_XDG=1
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"

# AWS configuration
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

# Misc
TRIAL_PERIOD_IN_DAYS=3000

# temp disable claude code auto update
export DISABLE_AUTOUPDATER=1
