#!/bin/bash

DIR_PATH="$HOME/.config/cdlog"
FILE_NAME="log.txt"
FULL_PATH="${DIR_PATH}/${FILE_NAME}"


mkdir -p $DIR_PATH
touch $FULL_PATH
echo `pwd` >> "${FULL_PATH}"