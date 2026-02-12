# Prompt configuration with current folder and git status

# Activate colors
autoload -U colors && colors

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

# Check if git repo has uncommitted changes
parse_git_dirty() {
    if [[ -n $(git status -s 2> /dev/null) ]]; then
        echo "${ZSH_THEME_GIT_PROMPT_DIRTY}"
    else
        echo "${ZSH_THEME_GIT_PROMPT_CLEAN}"
    fi
}

# Get git branch info for prompt
git_prompt_info() {
    git rev-parse --git-dir > /dev/null 2>&1 || return
    local branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    # If detached HEAD, show short commit hash instead
    [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2> /dev/null)
    local branchStatus=$(parse_git_dirty)
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${branchStatus}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# Arrow color based on last command exit status
prompt_arrow() {
  local exit_status=$1
  if [[ $exit_status -eq 0 ]]; then
    echo "%{$fg_bold[green]%}➜ %{$reset_color%}"
  else
    echo "%{$fg_bold[red]%}➜ %{$reset_color%}"
  fi
}

# Path display: git-aware or standard with ~ substitution
git_aware_path() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -n "$git_root" ]]; then
    local repo_parent=$(dirname "$git_root")
    local repo_name=$(basename "$git_root")
    local relative=${PWD#$git_root}

    if [[ "$repo_parent" == "$HOME" ]]; then
      echo "~/${repo_name}${relative}"
    else
      echo "$(basename "$repo_parent")/${repo_name}${relative}"
    fi
  else
    echo "${PWD/#$HOME/~}"
  fi
}

HOST_NAME="%{$fg_bold[cyan]%}%m%{$reset_color%}"

# Dynamic prompt update
autoload -Uz add-zsh-hook

update_prompt() {
  local last_exit=$?  # Capture exit status immediately
  local folder="%{$fg_bold[cyan]%}$(git_aware_path)%{$reset_color%}"
  PROMPT="${HOST_NAME} $(prompt_arrow $last_exit) ${folder}$(git_prompt_info) "
}

# Hook for before each prompt (handles vim exit, command completion, etc.)
add-zsh-hook precmd update_prompt

# Hook for directory changes
add-zsh-hook chpwd update_prompt

# Widget to clear screen and reset prompt (for Ctrl+L)
clear-screen-and-update() {
  clear
  update_prompt
  zle reset-prompt
}
zle -N clear-screen-and-update
bindkey '^L' clear-screen-and-update

# Initial call to set the prompt
update_prompt
