#!/bin/ash

DOT_DIRECTORY="/home/${USER}/dotfiles"
echo "link home directory dotfiles"
for f in .??*
do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    ln -sfn ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
echo "Linked directory dotfiles!"
