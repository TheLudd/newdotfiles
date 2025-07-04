alias apap="sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo apt autoclean"
alias e=". doexit"
alias l="ls --color=auto -l"
alias ls="ls --color=auto"
alias ll="ls --color=auto -la"
alias mdir=". makedir"
alias rebase="git rebase -i HEAD~"
alias upnpm="sudo npm i -g npm && npm completion | sudo tee /etc/bash_completion.d/npm > /dev/null && npm -v "
alias mt="cd ~/mediatool"
alias pyser="python3 -m http.server"
alias hack=". createhack"
alias peace="git status | grep -P 'both (added|modified)' | sed -r 's/both .*:\s*(.*)$/\1/g' | xargs nvim -p"
alias vip="xargs -r nvim"
alias g="cd ~/code/gaius"
alias yui="yarn upgrade-interactive --latest && yarn-dedupe && yarn"
alias rim="git rebase -i master"
alias lb="git ch -b"
alias m="git checkout master"
alias hi=". hub-init"
alias prm="pr -r m"
alias prj="pr -r j"
alias pro="pr -r o"
alias prt="pr -r t"
alias prp="pr -r p"
alias pry="pr -r y"
alias prc="pr -r c"
alias prl="pr -r l"
alias y='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
alias ag='ag --path-to-ignore $XDG_CONFIG_HOME/ag/ignore'
alias a='ag --path-to-ignore $XDG_CONFIG_HOME/ag/ignore'
alias p='pnpm'
alias nv='cd ~/newdotfiles/config/nvim/'
alias mvjs=~/code/rename-js-file/bin/rename-js-file
alias sudo="sudo -E"
alias ...="cd ../.."
alias ....="cd ../../.."
alias uw='nodemon -q -x "clear; u" -e js,jsx,ts,tsx'
alias cat='bat -pp '
alias vi=nvim
alias vim=nvim
alias ca="run -w checkall"
alias lw="run -w lint --write --unsafe"
alias ts="run tsc --noEmit"
alias tsw="run tsc --noEmit -w"
