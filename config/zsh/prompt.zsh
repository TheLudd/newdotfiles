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

# Branch of the repo at $1 (default: current dir), or the short hash when detached
git_branch() {
    git -C "${1:-.}" symbolic-ref --short HEAD 2> /dev/null \
      || git -C "${1:-.}" rev-parse --short HEAD 2> /dev/null
}

# Get git branch info for prompt
git_prompt_info() {
    git rev-parse --git-dir > /dev/null 2>&1 || return
    local branch=$(git_branch)
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

# Project name from a repo's common git dir: the folder holding the bare repo
# (<project>/.bare), the folder holding the worktrees when the main checkout is
# one of them (<project>/master/.git next to <project>/<worktree>), else the repo folder
git_project_name() {
  local common=$1 main=${1:h} gitdir
  if [[ ${common:t} != .git ]]; then
    echo ${main:t}
    return
  fi
  for gitdir in $common/worktrees/*/gitdir(N); do
    if [[ ${$(<$gitdir):h:h} == ${main:h} ]]; then
      echo ${main:h:t}
      return
    fi
  done
  echo ${main:t}
}

# The last two folders of a path inside a repo, "…/" in front when deeper
short_subpath() {
  local -a parts=(${(s:/:)1})
  (( $#parts > 2 )) && echo "…/${(j:/:)parts[-2,-1]}" || echo ${(j:/:)parts}
}

# Sets reply=(label subpath) for the repo at $1; fails outside git.
# label: project[:worktree][ › submodule], the worktree left out when it is
# named like the project or its branch. subpath: where $1 is inside the repo
git_repo_label() {
  local -a info
  info=("${(@f)$(git -C "$1" rev-parse --path-format=absolute --show-toplevel \
    --git-common-dir --show-prefix --show-superproject-working-tree 2> /dev/null)}")
  local top=$info[1] common=$info[2] prefix=${info[3]%/} super=$info[4]
  [[ -n $top ]] || return 1

  local label
  if [[ -n $super ]]; then
    git_repo_label $super
    label="$reply[1] › ${top#$super/}"
  else
    local project=$(git_project_name $common) worktree=${top:t}
    label=$project
    [[ $worktree != $project && $worktree != $(git_branch $top) ]] \
      && label+=":$worktree"
  fi
  reply=($label "${prefix:+$(short_subpath $prefix)}")
}

# Names this pane's tag in truetm after the repo; empty outside git, so truetm
# shows the folder name
send_tag_label() {
  [[ -n $TRUETM ]] && printf '\e]7770;%s\a' "$1"
}

HOST_NAME="%{$fg_bold[cyan]%}%m%{$reset_color%}"

# Dynamic prompt update
autoload -Uz add-zsh-hook

update_prompt() {
  local last_exit=$?  # Capture exit status immediately
  local label where
  if git_repo_label .; then
    label=$reply[1]
    where=$label${reply[2]:+/$reply[2]}
  else
    where="${PWD/#$HOME/~}"
  fi
  send_tag_label $label
  local folder="%{$fg_bold[cyan]%}${where}%{$reset_color%}"
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
