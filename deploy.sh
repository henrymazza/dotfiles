#!/bin/zsh
setopt extended_glob

# All directories not disabled
for dir in `ls -d *~*.disabled(/)`; do
  echo $dir
  for target in `ls $dir`; do
    echo ".. " $target
    rm -irf $HOME/.$target
    ln -s $HOME/dotfiles/$dir/$target $HOME/.$target
  done
done

