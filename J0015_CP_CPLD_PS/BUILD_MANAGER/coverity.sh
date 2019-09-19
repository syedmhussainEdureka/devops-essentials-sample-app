
#!/bin/bash

###############################################################################
# 
# csac -  Coverity Static Analysis Control
#
# A script for easier handling of Coverity Static Analysis process. This
# script can be used to build, analyze and/or commit source code for 
# Coverity Integrity Manager.
#
# An initialization file is required for this to be run successfully. 
#
# Note that user id and password used for commit command are not and should
# not be stored in this file for security reasons. They can be stored to 
# .smbpasswd file. Access control for this file should be set to 600.
#
# History:
#    02.01.2011/MEP ; Initial revision
#
###############################################################################
# Uncomment to print some debug prints
#debug=1

### Couple of functions ###

usage () {
# Print usage info

cat <<EOL
Usage:
`basename $0` [OPTION]...
Build, analyze and commit command line tool for Coverity.
  -b		Build target (required). There are defined in 
			the configuration file.
  -c		Command (required). One of
			- build, 
			- analyze, 
			- commit,
			- all.
  -d		Intermediary directory (required)
  -l		Use .smbpasswd in user's home directory for 
                authentication information
  -s            Settings file. Default is ~/.csa.ini.
  -h		This help
EOL

	exit
}

cmd_shift() {
	# Remove first item from command array
	placeholder=${cmd_arr[0]}
	unset cmd_arr[0]
	cmd_arr=("${cmd_arr[@]}")
}

### Script starts here ###

CURR_DIR=`pwd`

## Read parameters
while getopts ":lc:d:b:hs:" option
do
	case $option in 
	"l")
		auto_login=1
		;;
	"b")
		build=${OPTARG}
		;;
	"c")
		command=${OPTARG}
		;;
	"d")
		intdir=${OPTARG}
		;;
	"h")
		usage
		;;
	"s")
		settings_file=${OPTARG}
		;;
	*)
		echo "Unknown parameter"
		echo
		usage
		;;
	esac
done

# Check that required parameters have been given
if [ "x${intdir}" == "x" -o "x${build}" == "x" -o "x${command}" == "x" ]; then
	echo "Parameters missing!"
	usage
fi

## Define commands to be run

if [ ! -z ${command} ]; then
	case ${command} in 
		"build")
			cmd_arr=("build")
			;;
		"analyze")
			cmd_arr=("analyze")
			;;
		"commit")
			cmd_arr=("commit")
			;;
		"all")
			cmd_arr=("build" "analyze" "commit")
			;;
		*)
			echo "Unknown command"
			echo
			usage
			;;
	esac
fi

## Get parameters for build target.

if [ "x${settings_file}" == "x" ]; then
	settings_file=${HOME}/.csa.ini
fi

. ${settings_file}

# Some bash magic to make parameter reading easy
prebuild_dir=${CURR_DIR}/$(eval echo '${'"${build}_PREBUILD_DIR"'}')
prebuild_cmd=$(eval echo '${'"${build}_PREBUILD_CMD"'}')
build_dir=${CURR_DIR}/$(eval echo '${'"${build}_BUILD_DIR"'}')
build_cmd=$(eval echo '${'"${build}_BUILD_CMD"'}')
stream=$(eval echo '${'"${build}_STREAM"'}')
strip_path=$(eval echo '${'"${build}_STRIP_PATH"'}')

# For debug purposes
if [ ! -z $debug ]; then
	echo "settings: ${settings_file}"	
	echo "prebuild_dir: ${prebuild_dir}"
	echo "prebuild_cmd: ${prebuild_cmd}"
	echo "build_dir: ${build_dir}"
	echo "build_cmd: ${build_cmd}"
	echo "stream: ${stream}"
	echo "strip: ${strip_path}"
fi

## Run the requested commands (either one of these or all in correct order)
while [ ! -z ${cmd_arr[0]} ]; do
#	echo "Command: ${cmd_arr[0]}"
	case ${cmd_arr[0]} in 
		"build")
			if [ ! -z "${prebuild_cmd}" ]; then
				pushd ${prebuild_dir}
				${prebuild_cmd}
				popd
			fi
			if [ -d ${build_dir} ]; then
				pushd ${build_dir}
					${COVERITY_BIN_DIR}/cov-build --dir ${intdir} --config ${CONFIG_FILE} ${build_cmd}
				popd
			else
				echo "Build dir not found!"
				exit
			fi
			;;
		"analyze")
			${COVERITY_BIN_DIR}/cov-analyze --dir ${intdir} --user-model-file ${USER_MODEL_FILE} ${ANALYSIS_OPTIONS}
			;;
		"commit")
			if [ -z ${auto_login} ]; then
				# Ask authentication info
				echo "User name:"
				read username
				echo "Password:"
				read -s password
			else
				# Else get auth info from .smbpasswd file
				. ${HOME}/.smbpasswd
			fi
			${COVERITY_BIN_DIR}/cov-commit-defects --host ${COVERITY_HOST} --port ${COVERITY_PORT} --user ${username} --password ${password} --dir ${int_dir}--stream ${stream} --strip-path ${strip_path}
			;;
		*)
			# Shouldn't go here -> if goes, there is a bug in this script
			echo "Internal script error"
			exit
			;;
	esac
	echo
	cmd_shift
done