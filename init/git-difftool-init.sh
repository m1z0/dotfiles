#!/usr/bin/env bash

git config --global difftool.sourcetree.cmd '/opt/homebrew-cask/Caskroom/araxis-merge/2014.4459/Araxis\ Merge.app/Contents/Utilities/compare -2 "$LOCAL" "$REMOTE"'
git config --global mergetool.sourcetree.cmd '/Applications/p4merge.app/Contents/MacOS/p4merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
git config --global --bool mergetool.sourcetree.trustexitcode true
git config --global difftool.Kaleidoscope.cmd 'ksdiff --partial-changeset --relative-path "$MERGED" -- "$LOCAL" "$REMOTE"'
git config --global mergetool.Kaleidoscope.cmd 'ksdiff --merge --output "$MERGED" --base "$BASE" -- "$LOCAL" --snapshot "$REMOTE" --snapshot'
git config --global --bool mergetool.Kaleidoscope.trustexitcode true
git config --global user.name "Krassimir Simeonov"
git config --global user.email "ksimeonov@gmail.com"