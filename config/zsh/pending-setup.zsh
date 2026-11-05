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
