# TODO: remove from here eventually
function mac_readlink() 
{
	TARGET_FILE=$1

	cd `dirname $TARGET_FILE`
	TARGET_FILE=`basename $TARGET_FILE`

	# Iterate down a (possible) chain of symlinks
	while [ -L "$TARGET_FILE" ]
	do
		TARGET_FILE=`readlink $TARGET_FILE`
		cd `dirname $TARGET_FILE`
		TARGET_FILE=`basename $TARGET_FILE`
	done

	# Compute the canonicalized name by finding the physical path
	# for the directory we're in and appending the target file.
	PHYS_DIR=`pwd -P`
	RESULT=$PHYS_DIR/$TARGET_FILE
	echo $RESULT
}

# Source stuff!
bash_dirs="lib completion plugins aliases"
for dir in $bash_dirs; do
  LIB="${BASH}/sourced/${dir}/*.bash"
  for config_file in $LIB; do
	  test "${BASHIT_VERBOSE}" == "TRUE" && ( echo sourcing $config_file )
	  source "$config_file"
  done
done

# Source Privates
pushd "${BASH}/../.private/bash" > /dev/null 2>&1
PRIVATES=$(pwd -P)
popd > /dev/null 2>&1
for config_file in ${PRIVATES}/*.bash; do
	test "${BASHIT_VERBOSE}" == "TRUE" && ( echo sourcing $config_file )
	source "$config_file"
done

unset config_file
unset bash_dirs
unset PRIVATES