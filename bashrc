export PATH=~/bin:/Applications/Emacs.app/Contents/MacOS/bin/:/Users/HMz/.gem/ruby/1.8/bin:/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8:/usr/local/sbin:$PATH
export DAEMON='/Applications/Emacs.app/Contents/MacOS/EMacs'
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWDIRTYSTATE=true
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export GIT_EDITOR='mate -w'
export EDITOR='mate'
export ALTERNATE_EDITOR=""

prompt_command () {
  if [ $? -eq 0 ]; then # set an error string for the prompt, if applicable
      PROMPT="\[\033[0;34m\]»"
  else
      PROMPT="\[\033[0;31m\]»"
  fi

  local GREEN="\[\033[0;32m\]"
  local CYAN="\[\033[0;36m\]"
  local BCYAN="\[\033[1;36m\]"
  local BLUE="\[\033[0;34m\]"
  local GRAY="\[\033[0;37m\]"
  local DKGRAY="\[\033[1;30m\]"
  local WHITE="\[\033[1;37m\]"
  local RED="\[\033[0;31m\]"
  # return color to Terminal setting for text color
  local DEFAULT="\[\033[0;39m\]"

  DIR="\w"

  RVM=`/Users/HMz/.rvm/bin/rvm-prompt i v`
  BRANCH=`__git_ps1 [%s]`
    
  # if it's an .git folder, which in my convension is a git repository
  # then show only the relevant part of the path
  # O comeando para git root:
  # git config --global --add alias.root '!pwd'
  if [ "" != "$BRANCH" ]; then
    DIR=$(pwd -P)
    BASE_DIR=`expr "$(git root)" : "\(/.*/\).*"`
    DIR=`expr "$DIR" : ".*$BASE_DIR\(.*\)"`
    DIR="${BCYAN}$DIR"
  elif [ -z "$INSIDE_EMACS" ]; then
    DIR="${GRAY}$DIR"
  fi
  
  printf "\n"
  
  BRANCH_POS=$COLUMNS
  if [ $RVM ]; then
    if [ $RVM != 'system' ]; then
      printf "\033[0;31m%*s\r" "$COLUMNS" "[$RVM]"
      BRANCH_POS=$[$COLUMNS-${#RVM}-2]
    fi
  fi

  # __git_ps1 já retorna formatado, não precisa de IF
  printf "\033[0;32m%*s\r" $BRANCH_POS "$BRANCH"

  # printf quebra a linha: o segunte volta para a linha de cima
  echo -en "\033[1A"
  
  export PS1="\n${DIR} ${POS}\n${PROMPT}${DEFAULT} "
}
PROMPT_COMMAND=prompt_command

if [[ -s /Users/HMz/.rvm/scripts/rvm ]] ; then source /Users/HMz/.rvm/scripts/rvm ; fi
  
source /usr/local/etc/bash_completion.d/git-completion.bash

alias ll="ls -lh"
alias ss="ifork script/server"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../../"

# Capistrano task completion
complete -C ~/.capistrano-completion.rb -o default cap

#history search binds
bind '"M-e": history-search-backward'
bind '"M-r": history-search-forward'

################################################################
# AUTOJUMP
#This shell snippet sets the prompt command and the necessary aliases

#Copyright Joel Schaerer 2008, 2009
#This file is part of autojump

#autojump is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#autojump is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with autojump.  If not, see <http://www.gnu.org/licenses/>.
_autojump() 
{
        local cur
        cur=${COMP_WORDS[*]:1}
        while read i
        do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done  < <(autojump --bash --completion $cur)
}
complete -F _autojump j
AUTOJUMP='{ (autojump -a "$(pwd -P)"&)>/dev/null 2>>${HOME}/.autojump_errors;} 2>/dev/null'
if [[ ! $PROMPT_COMMAND =~ autojump ]]; then
  export PROMPT_COMMAND="${PROMPT_COMMAND:-:} && $AUTOJUMP"
fi 
alias jumpstat="autojump --stat"
function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";fi }
