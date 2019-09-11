#!/bin/bash

echo "

this repositories are required for this environment

    git clone git@github.com:RubberJones/tmux-conf.git ~/sourcen/
    git clone git@github.com:RubberJones/vimrc.git ~/sourcen/
    git clone git@github.com:RubberJones/mydockerfiles.git ~/sourcen/
"

SESSION="my-env"

# set up tmux
#tmux start-server

########## Neue tmux Session 'my-env' mit Fenster 'DOC-RTG' erzeugen.
tmux new-session -d -s $SESSION -n DOC-RTG

##### Pane 0
# wechsel ins Verzeichnis zur RTG Protokoll Dokumentation und für git status
# aus.
tmux send-keys "cd ~/sourcen/asciidoc/bus-rtg/" C-m
tmux send-keys "git status" C-m

###### Aufteilung der Panes
# +-------------------------+
# |                         |
# |                         |
# |    dokumentieren        |
# |                         |
# |                         |
# +-------------------------+
# |                         |
# |     asciidoctor         |
# |     container           |
# +-------------------------+
# Horizontale Aufteilung 50%
# Linke Seite vertikale Aufteilung auf 50%. Rechte Seite dient zum schreiben
# von Dokumentationen.
tmux splitw -v -p 15
tmux selectp -t 0

# Pane 0
tmux send-keys "cd ~/sourcen/asciidoc/bus-rtg/" C-m
tmux send-keys "vim main.adoc" C-m
# Pane 1, wird als letztes ausgeführt, da der Docker Container einige Zeit zum
# starten benötigt. Ansonsten können Einträge die in den Panes durcheinander
# kommen.
DOC_DIR=~/sourcen/asciidoc/bus-rtg/
tmux selectp -t 1
tmux send-keys "cd $DOC_DIR" C-m
#tmux send-keys "docker run --rm -it --user=$(id -u):$(id -g) --net=host -v $(pwd):/documents/ asciidoctor/docker-asciidoctor" C-m
tmux send-keys "docker run --rm -it --net=host -v $DOC_DIR:/documents/ asciidoctor/docker-asciidoctor" C-m
tmux send-keys "asciidoctor -r asciidoctor-diagram main.adoc"
#tmux send-keys "asciidoctor -a stylesheet=colony.css -a stylesdir=../stylesheets -r asciidoctor-diagram main.adoc"

tmux selectp -t 0
tmux send-keys ":NERDTree" C-m

##############################################################################
# new window doc-projects
##############################################################################
DOC_DIR=~/sourcen/asciidoc/doc-projects/
tmux new-window -t $SESSION -n DOC-PROJ
tmux send-keys "cd $DOC_DIR" C-m
tmux send-keys "git status" C-m
tmux splitw -v -p 15
tmux selectp -t 0
tmux send-keys "cd $DOC_DIR" C-m
tmux send-keys "vim main.adoc" C-m
tmux selectp -t 1
tmux send-keys "cd $DOC_DIR" C-m
#tmux send-keys "docker run --rm -it --user=$(id -u):$(id -g) --net=host -v $(pwd):/documents/ asciidoctor/docker-asciidoctor" C-m
tmux send-keys "docker run --rm -it --net=host -v $DOC_DIR:/documents/ asciidoctor/docker-asciidoctor" C-m
tmux send-keys "./gen.sh"
#tmux send-keys "asciidoctor -a stylesheet=colony.css -a stylesdir=../stylesheets -r asciidoctor-diagram main.adoc"
tmux selectp -t 0
tmux send-keys ":NERDTree" C-m

##############################################################################
# new window gui development
##############################################################################
GUI_DIR=~/sourcen/tftGui/
tmux new-window -t $SESSION -n GUI
tmux send-keys "cd $GUI_DIR" C-m
tmux send-keys "git status" C-m

##############################################################################
# new window compile gui for phytec platform
##############################################################################
PHY_DIR=~/sourcen/mydockerfiles/phy-env/
tmux new-window -t $SESSION -n PHY
tmux send-keys "cd $PHY_DIR" C-m
tmux send-keys "./03_compile.sh"

##############################################################################
# new window my environment stuff tmux, vim, ...
##############################################################################
ENV_DIR=~/sourcen/tmux-config
tmux new-window -t $SESSION -n MYENV
tmux send-keys "cd $ENV_DIR" C-m

# split window in three panes
tmux splitw -v -p 33
tmux selectp -t 0
tmux splitw -v -p 50

# pane 1 tmux-config
tmux selectp -t 0
tmux send-keys "cd ~/sourcen/tmux-config" C-m

# pane 2 vimrc
tmux selectp -t 1
tmux send-keys "cd ~/sourcen/vimrc" C-m

# pane 3
tmux selectp -t 2
tmux send-keys "cd ~/sourcen/mydockerfiles" C-m


### select window as default
tmux selectw -t 3

tmux -2 attach-session -t $SESSION

