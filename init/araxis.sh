#!/usr/bin/env bash 
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo ln -s /opt/homebrew-cask/Caskroom/araxis-merge/2014.4459/Araxis\ Merge.app/Contents/Utilities/compare /usr/local/bin/compare
sudo ln -s /opt/homebrew-cask/Caskroom/araxis-merge/2014.4459/Araxis\ Merge.app/Contents/Utilities/araxishgmerge /usr/local/bin/araxishgmerge
sudo ln -s /opt/homebrew-cask/Caskroom/araxis-merge/2014.4459/Araxis\ Merge.app/Contents/Utilities/araxisgitmerge /usr/local/bin/araxishgmerge 