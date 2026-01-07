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

FOLDER_NAME="%{$fg_bold[cyan]%}%c%{$reset_color%}"
HOST_NAME="%{$fg_bold[cyan]%}%m%{$reset_color%}"

# Dynamic prompt update
autoload -Uz add-zsh-hook

update_prompt() {
  local last_exit=$?  # Capture exit status immediately
  PROMPT="${HOST_NAME} $(prompt_arrow $last_exit) ${FOLDER_NAME}$(git_prompt_info) "
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
