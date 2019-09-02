#!/bin/bash

SESSION="my-env"

# set up tmux
#tmux start-server

########## Neue tmux Session 'my-env' mit Fenster 'DOC-RTG' erzeugen.
tmux new-session -d -s $SESSION -n DOC-RTG

##### Pane 0
# wechsel ins Verzeichnis zur RTG Protokoll Dokumentation und für git status
# aus.
tmux send-keys "cd ~/Dokumente/asciidoc/bus-rtg/" C-m
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
tmux send-keys "cd ~/Dokumente/asciidoc/bus-rtg/" C-m
tmux send-keys "vim main.adoc" C-m
# Pane 1, wird als letztes ausgeführt, da der Docker Container einige Zeit zum
# starten benötigt. Ansonsten können Einträge die in den Panes durcheinander
# kommen.
DOC_DIR=~/Dokumente/asciidoc/bus-rtg/
tmux selectp -t 1
tmux send-keys "cd $DOC_DIR" C-m
#tmux send-keys "docker run --rm -it --user=$(id -u):$(id -g) --net=host -v $(pwd):/documents/ asciidoctor/docker-asciidoctor" C-m
tmux send-keys "docker run --rm -it --net=host -v $DOC_DIR:/documents/ asciidoctor/docker-asciidoctor" C-m
tmux send-keys "asciidoctor -r asciidoctor-diagram main.adoc"
#tmux send-keys "asciidoctor -a stylesheet=colony.css -a stylesdir=../stylesheets -r asciidoctor-diagram main.adoc"

tmux selectp -t 0
tmux send-keys ":NERDTree" C-m

##############################################################################
# new window doc-todo
##############################################################################
DOC_DIR=~/Dokumente/asciidoc/doc-todo/
tmux new-window -t $SESSION -n DOC-TODO
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

### select window as default
tmux selectw -t 3

tmux -2 attach-session -t $SESSION

