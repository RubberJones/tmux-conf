#!/bin/sh

# set session name
SESSION="TFT"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then

###############################################################################
# start new session with our name
    tmux new-session -d -s $SESSION -n 'GUI'

###############################################################################
# create and setup pane for vpn connection
    tmux new-window -t $SESSION -n 'VPN'
    tmux send-keys -t 'VPN' \
        'cd ~/Downloads/VPN-Inotec/' C-m \
        './start-vpn.sh'

###############################################################################
# setup document window
    tmux new-window -t $SESSION -n 'DOC'
    tmux send-keys -t 'DOC' \
        'cd ~/Dokumente/asciidoctor-berichtsheft' C-m

###############################################################################
# start qtcreator in docker/podman container
    tmux send-keys -t 'GUI' \
        'cd ~/sourcen/mydockerfiles/qtcreator_qt4' C-m \
        './start-qtcreator-pod.sh' C-m \
        'cd ~/sourcen/tftGui' C-m 
fi

# attach session, on the main window
tmux attach-session -t $SESSION:'GUI'

