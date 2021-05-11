#!/bin/sh

# set session name
SESSION="FLU"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then

###############################################################################
# start new session with our name
    tmux new-session -d -s $SESSION -n 'flutter'
    tmux send-keys -t 'flutter' \
        'cd ~/development/flutter' C-m \
        'git remote update' C-m

###############################################################################
# go to flutter my flutter projects directory, start android-studio and
# microsoft visual studio code.
    tmux new-window -t $SESSION -n 'SRC'
    tmux send-keys -t 'SRC' \
        'cd ~/sourcen/flutter/' C-m \
        'studio.sh &' C-m \
        'code &' C-m \
fi

# attach session, on the SRC window
tmux attach-session -t $SESSION:'SRC'

