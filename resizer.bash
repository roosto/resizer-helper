#!/usr/bin/env bash

ME=$(basename "${BASH_SOURCE[0]}")
DEFAULT_RESIZE=1024

# if we know the terminal width, set the -w option for fold
# the value should be a multiple of 8, the default tabstop
FOLD_WIDTH_OPT=$( [[ $COLUMNS ]] && echo '-w' $(( COLUMNS - COLUMNS % 8 )) )

# prints the script's usage message to STDOUT,  wrapped to terminal's width
function show_usage {
	fold $FOLD_WIDTH_OPT -s <<-EOF
		Usage: $ME [-h] [-s newSize] file [file ...]
	EOF
}

# prints the script's usage & help messages to STDOUT, wrapped to terminal's width
function show_help_and_usage {

	show_usage
	echo ''

	# For more info on `<<-EOF` style heredocs, see: https://www.tldp.org/LDP/abs/html/here-docs.html
	fold $FOLD_WIDTH_OPT -s <<-EOF
		This script will resize, in place, any number of supplied image files, such that afterwards, their largest edge will be equal to the value specified by -s or $DEFAULT_RESIZE, if the -s option is skipped.
EOF
}

function print_error {
	echo "$ME:" "$@" 1>&2
}

function error_out {
	print_error "$@"
	exit 1
}

saw_bad_args=false
new_size=$DEFAULT_RESIZE
while getopts "hs:" OPT
do
	case $OPT in
		h)	show_help_and_usage
			exit
		;;
		s)
			if echo "$OPTARG" | grep --quiet '^[1-9][0-9]*$'
			then
				new_size=$OPTARG
			else
				error_out "\`$OPTARG': not a valid value for -s; values must be numeric"
			fi
		;;
		'?')
			saw_bad_args=true
		;;
		*)
			error_out 'error while parsing arguments'
		;;
	esac
done

if $saw_bad_args
then
	show_usage 1>&2
	exit 1
fi

# move over all incoming cli args that were just parsed as options
shift $(($OPTIND - 1))

if [[ $# -eq 0 ]]
then
	error_out 'no files supplied'
fi

while [[ $# -gt 0 ]]
do
	sips --resampleHeightWidthMax $DEFAULT_RESIZE $new_size
	shift
done
