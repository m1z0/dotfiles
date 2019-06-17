#!/usr/bin/env bash

get_script_dir() {
	SOURCE="${BASH_SOURCE[0]}"
	# While $SOURCE is a symlink, resolve it
	while [ -h "$SOURCE" ]; do
		DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
		SOURCE="$(readlink "$SOURCE")"
		# If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
	done
	DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
	echo $DIR
}

backup_file () {
	if [[ ! -f $1 ]]; then
		echo $1 "does not exist ..."
		return 1
	fi

	if [ ! -d "$HOME/$backup_dir" ]; then
		mkdir -p "$HOME/$backup_dir"
	fi

	timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
	echo "Backing up old $1 at '$HOME/$backup_dir/$1-$timestamp'"
	cp "$HOME/$1" "$HOME/$backup_dir/$1-$timestamp"
}

# will put the script dir in the var script_dir
script_dir=$(get_script_dir)

backup_dir=.dotfiles-backup
dest_dir=${HOME}

source_files=(
	gitconfig
   	gitignore_global
   	bash_profile
   	bashrc
   	vim
   	vimrc
   	private
   	fzf-extras/fzf-extras.sh
)

script_files=(
)

configs=(
	bash
)

deploy_with_backup() {
	#backup originals if exist
	for f in ${source_files[@]}; do
		fpath="${dest_dir}/${f}"
		if [[ ! -h ${fpath} ]]; then
			backup_file ".${fpath}"
		else
			echo "${fpath} is a symlink, skipping backup ..."
		fi
	done

	#create links
	for f in ${source_files[@]}; do
		dest_file="${dest_dir}/${f}"
		rm -rf -- "${dest_file}"
		if [ -e "${script_dir}/$f" ]; then
			ln -s "${script_dir}/${f}" "${dest_file}"
		fi
	done
}

if [ -n "$1" -a "$1" == "--dry-run" ]; then
	for f in ${source_files[@]}; do
		if [ ! -e $f ]; then
			echo "$f does not exist"
		fi
	done
else
	deploy_with_backup
fi
