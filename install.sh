#!/bin/bash

TMUX_LOC=~/
TMUX_CONF=.tmux.conf

if [ -f "$TMUX_LOC/$TMUX_CONF" ]; then
	echo "file exists"
	read -p "do you want to override it (y/n)? " answer
	if [ $answer != 'y' ]; then
		exit 1
	fi
fi

echo "copy file $TMUX_CONF to your home directory."
cp $TMUX_CONF $TMUX_LOC

echo "copy myenv.sh startup script to ~/bin."
cp ./myenv.sh ~/bin/

exit 0

