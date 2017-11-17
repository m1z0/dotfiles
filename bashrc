if [ -n "$PS1" ]; then

	if [ -r "${HOME}/.config/.bashrc_local" ]; then
		source "${HOME}/.config/.bashrc_local";
	fi

	source ~/.bash_profile;
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
