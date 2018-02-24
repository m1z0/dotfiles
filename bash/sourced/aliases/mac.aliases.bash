if [ "$(uname)" = "Darwin" ]; then
	# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
	alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

	alias openports='sudo lsof -iTCP -sTCP:LISTEN -P'

	# JavaScriptCore REPL
	jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc";
	[ -e "${jscbin}" ] && alias jsc="${jscbin}";
	unset jscbin;

	# Trim new lines and copy to clipboard
	alias c="tr -d '\n' | pbcopy"

	# Recursively delete `.DS_Store` files
	alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

	# Empty the Trash on all mounted volumes and the main HDD.
	# Also, clear Apple’s System Logs to improve shell startup speed.
	# Finally, clear download history from quarantine. https://mths.be/bum
	alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

	# Show/hide hidden files in Finder
	alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
	alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

	# Hide/show all desktop icons (useful when presenting)
	alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
	alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

	# Flush Directory Service cache
	alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

	# Clean up LaunchServices to remove duplicates in the “Open With” menu
	alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

	# Merge PDF files
	# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
	alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

	# Disable Spotlight
	alias spotoff="sudo mdutil -a -i off"
	# Enable Spotlight
	alias spoton="sudo mdutil -a -i on"

	# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
	alias plistbuddy="/usr/libexec/PlistBuddy"

	# Airport CLI alias
	alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

	# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
	# (useful when executing time-consuming commands)
	alias badge="tput bel"

	# Lock the screen (when going AFK)
	alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
fi
