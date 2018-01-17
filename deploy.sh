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

# will put the script dir in the var script_dir
get_script_dir script_dir

backup_dir=${HOME}/.dotfiles-backup
mkdir -p "$backup_dir"

source_files=(aliases bash_profile bashrc vim vimrc bash private fzf-extras/fzf-extras.sh)

#backup originals if exist
for f in ${source_files[@]}; do
	fpath="${HOME}/.${f}"
	if [[ ! -h "${fpath}" ]]; then
		cp -R "${fpath}" "${backup_dir}"
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