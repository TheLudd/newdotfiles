# History configuration
HISTSIZE=100000
SAVEHIST=100000

# Shell options
setopt autocd extendedglob
unsetopt beep

# Vi mode
bindkey -v
bindkey '^R' history-incremental-search-backward

# Edit command line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
