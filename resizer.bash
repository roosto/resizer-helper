#!/usr/bin/env bash

ME=$(basename "${BASH_SOURCE[0]}")
DEFAULT_NEW_SIZE=1024

while [[ $# -gt 0 ]]
do
    sips --resampleHeightWidthMax $DEFAULT_NEW_SIZE "$1"
    shift
done
