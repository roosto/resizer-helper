#!/usr/bin/env bash

ME=$(basename "${BASH_SOURCE[0]}")
DEFAULT_RESIZE=1024

# if we know the terminal width, set the -w option for fold
# the value should be a multiple of 8, the default tabstop
FOLD_WIDTH_OPT=$( [[ $COLUMNS ]] && echo '-w' $(( COLUMNS - COLUMNS % 8 )) )

function show_help {
# The `<<-EOF` style heredoc is a bash extension that will strip leading tabs
# from the text inside the heredoc
# For more info, see: https://www.tldp.org/LDP/abs/html/here-docs.html
	fold $FOLD_WIDTH_OPT -s <<-EOF
		Usage $ME [-s newSize] file [file ...]
		
		This script will resize, in place, any number of supplied image files, such that afterwards, their largest edge will be equal to the value specified by -s or $DEFAULT_RESIZE, if the -s option is skipped.
EOF
}

function print_error {
	echo "$ME: ERROR: " "$@" 1>&2
}

function error_out {
	print_error "$@"
	exit 1
}

if [[ $# -eq 0 ]]
then
	{
		show_help && echo ''
	} 1>&2
	error_out 'no files supplied'
fi

while [[ $# -gt 0 ]]
do
    sips --resampleHeightWidthMax $DEFAULT_RESIZE "$1"
    shift
done
