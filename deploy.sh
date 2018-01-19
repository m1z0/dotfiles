#!/usr/bin/env bash

get_script_dir() {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	eval "$1=\"$DIR\""
}

backup_file () {
	if [ ! -d "$HOME/$backup_dir" ]; then
		mkdir -p "$HOME/$backup_dir"
	fi
	timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
	echo "Backing up old .$1 at '$HOME/$backup_dir/.$1-$timestamp'"
	cp "$HOME/.$1" "$HOME/$backup_dir/.$1-$timestamp"
}


# will put the script dir in the var script_dir
get_script_dir script_dir

backup_dir=.dotfiles-backup

source_files=(gitconfig gitignore_global aliases bash_profile bashrc vim vimrc bash private fzf-extras/fzf-extras.sh)

#backup originals if exist
for f in ${source_files[@]}; do
	fpath="${HOME}/.${f}"
	if [[ ! -h "${fpath}" ]]; then
		backup_file "${fpath}"
	else
		echo "${fpath} is a symlink, skipping backup ..."
	fi
done

#create links
for f in ${source_files[@]}; do
	dest_file="${HOME}/.${f}"
	rm -rf -- "${dest_file}"
	ln -s "${script_dir}/${f}" "${dest_file}"
done
