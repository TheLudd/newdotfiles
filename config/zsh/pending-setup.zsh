# Offer to finish the setup (gh login, ssh key upload) when user/90-pending-login
# left a marker holding the dotfiles repo's path. Runs at the tty login before
# X starts, and in every terminal until user-login/10-github removes it.
() {
	local marker=$XDG_STATE_HOME/init/pending-user-login
	[[ -f $marker ]] || return
	read -q "?Finish setup (gh login, ssh key upload)? [y/N] " || { echo; return }
	echo
	"$(<$marker)/init" user-login
}

# Offer to remove the old kernels once the kernel bin/switch-kernel switched to
# has booted. Asks in every shell until they are removed.
() {
	local old
	old=$(switch-kernel --pending 2>/dev/null) || return
	read -q "?Booted $(</etc/newdotfiles/kernel). Remove ${old//$'\n'/ }? [y/N] " || { echo; return }
	echo
	switch-kernel --cleanup
}
