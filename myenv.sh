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
# +------------+------------|
# |   bash     |            |
# |0           |            |
# +------------+ dokumen-   |
# |   asciidoc | tieren     |
# |1  container|            |
# +------------+            |
# |   main.adoc|            |
# |2           |3           |
# +------------+------------|
# Horizontale Aufteilung 50%
# Linke Seite vertikale Aufteilung auf 50%. Rechte Seite dient zum schreiben
# von Dokumentationen.
tmux splitw -h -p 50
tmux selectp -t 0
tmux splitw -v -p 66
tmux splitw -v -p 50

# Pane 2
tmux send-keys "cd ~/Dokumente/asciidoc/bus-rtg/" C-m
tmux send-keys "vim main.adoc" C-m

# Pane 3
tmux selectp -t 3
tmux send-keys "cd ~/Dokumente/asciidoc/bus-rtg/" C-m
tmux send-keys "vim ~/Dokumente/asciidoc/bus-rtg/protocol-structure.adoc" C-m

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

tmux selectp -t 3

########### Create a new window called yocto-git
#tmux new-window -t $SESSION:1 -n yocto-git
#tmux send-keys "cd /mnt/data/yocto" C-m
#tmux send-keys "git show-branch" C-m
#tmux send-keys "git log --oneline" C-m
#
###### Create pane 2 horizontally by 50%
#tmux splitw -h -p 50
#tmux send-key "cd /mnt/data/yocto/build/conf" C-m
#tmux send-key "ls" C-m
#
## select build window
#tmux selectw -t 0
#
## Setup fertig, betrete die tmux session!
# Parameter -2 benötige ich, damit die Darstellung von Vim richtig funktioniert
tmux -2 attach-session -t $SESSION

