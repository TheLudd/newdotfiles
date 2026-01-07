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
    local branch=$(git branch 2> /dev/null | grep '\*' | cut -d ' ' -f2-3)
    local branchStatus=$(parse_git_dirty)
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${branchStatus}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# Arrow color based on last command exit status
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

# Dynamic prompt update
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_prompt

update_prompt() {
  PROMPT="${HOST_NAME} $(prompt_arrow) ${FOLDER_NAME}$(git_prompt_info) "
}

# Initial call to set the prompt
update_prompt
