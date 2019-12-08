#!/bin/bash

DOT_DIRECTORY="${HOME}/dotfiles"
echo "link home directory dotfiles"
cd ${DOT_DIRECTORY}
for f in .??*
do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    ln -sfn ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
echo "Linked directory dotfiles!"
