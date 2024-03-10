export PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/.yarn/bin:$XDG_DATA_HOME/npm/bin:$XDG_DATA_HOME/pnpm"

# Lines configured by zsh-newuser-install
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
unsetopt beep
bindkey -v
bindkey '^R' history-incremental-search-backward

source $HOME/.bash_aliases

export EDITOR='nvim'

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PNPM_HOME=$XDG_DATA_HOME/pnpm

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ludwig/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# .zshrc configuration for prompt with current folder and git status

# Activate colors
autoload -U colors && colors

# ---- GIT
#
# Color definitions
fg[red]=$'\e[31m'
fg[blue]=$'\e[34m'
fg[yellow]=$'\e[33m'
fg_bold[blue]=$'\e[1;34m'
reset_color=$'\e[0m'

# Theme variables for Git Prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Configure Git Prompt
parse_git_dirty() {
    if [[ -n $(git status -s 2> /dev/null) ]]; then
        echo "${ZSH_THEME_GIT_PROMPT_DIRTY}"
    else
        echo "${ZSH_THEME_GIT_PROMPT_CLEAN}"
    fi
}

git_prompt_info() {
    git rev-parse --git-dir > /dev/null 2>&1 || return # Exit if not a git repo
    local branch=$(git branch 2> /dev/null | grep '\*' | cut -d ' ' -f2-3)
    local branchStatus=$(parse_git_dirty)
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${branchStatus}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

prompt_arrow() {
  if [ $? -eq 0 ]; then
    arrow_color="%{$fg_bold[green]%}"
  else
    arrow_color="%{$fg_bold[red]%}"
  fi
  echo "${arrow_color}➜ %{$reset_color%}"
}

FOLDER_NAME="%{$fg_bold[cyan]%}%c%{$reset_color%}"
HOST_NAME="%{$fg_bold[cyan]%}%m%{$reset_color%}"

# Correcting the prompt setup for dynamic evaluation
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_prompt

update_prompt() {
  PROMPT="${HOST_NAME} $(prompt_arrow) ${FOLDER_NAME}$(git_prompt_info) "
}

# Initial call to set the prompt
update_prompt

# Make sure to load the necessary Zsh modules for colors and hooks
autoload -U colors && colors

