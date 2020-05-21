#!/usr/bin/env bash

subl_symlink() {
  if [ "$(uname)" = "Darwin" ]; then
    ST_APP=$(osascript -e 'POSIX path of (path to application "Sublime Text")')
    ln -sf "$ST_APP/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
  fi
}

fag(){
  local line
  line=`ag --nocolor "$1" | fzf` \
    && vim $(cut -d':' -f1 <<< "$line") +$(cut -d':' -f2 <<< "$line")
}    
