#!/bin/bash

# NOTE: This script file must be run with `source scd.sh` to work correctly
# See: https://unix.stackexchange.com/questions/27139/script-to-change-current-directory-cd-pwd

TARGET_DIR=$1
START_DIR=$2

if [[ -z "$TARGET_DIR" ]]
then 
    echo "Script invoked without target directory. Must pass in target directory as first argument of script."
    return 1
fi 

if [[ -z "$START_DIR" ]]
then
    START_DIR=$(pwd)
fi

echo "Searching in $START_DIR for directory $TARGET_DIR..."

PATHTODIR=`(find $START_DIR -type d -name "$TARGET_DIR" -print -quit) | head -n 1`


if [[ -z "$PATHTODIR" ]]
then
    echo "Nothing found! Exiting..."
    return 1
fi

echo "Found:"
echo $PATHTODIR

echo "Switching directories..."
cd $PATHTODIR

echo "Complete!"