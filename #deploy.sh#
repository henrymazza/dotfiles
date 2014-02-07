#!/bin/zsh
setopt extended_glob

# All directories not disabled
for dir in `ls -d *~*.disabled(/)`; do
  for target in `ls $dir`; do
    if [ ! -L $HOME/.$target ]; then
      if [ -f $HOME/.$target ]; then
        echo "[Warning]:" $target " is a regular file."
      elif [ -d $HOME/.$target ]; then
        echo "[Warning]:" $target " is a regular directory."
      else
        echo "Linking... " $target
        ln -s $HOME/dotfiles/$dir/$target $HOME/.$target
      fi
    fi
  done
done

