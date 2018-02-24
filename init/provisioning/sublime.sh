#!/usr/bin/env bash

ST_DIR="$HOME/Library/Application Support/Sublime Text 3"

if [ "$(uname)" = "Linux" ]; then
  ST_DIR="$HOME/.config/sublime-text-3"
fi

# installing subl cli command
if [ "$(uname)" = "Darwin" ]; then
  ST_APP=$(osascript -e 'POSIX path of (path to application "Sublime Text")')
  ln -sf "$ST_APP/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi

