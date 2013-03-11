#!/bin/zsh

# All directories not disabled
for dir in *[^.disabled](/); do
  for target in `ls $dir`; do
    if [ $HOME/.$target ]; then
      rm -irf $HOME/.$target
    fi
    ln -s $HOME/dotfiles/$dir/$target $HOME/.$target
  done
done

