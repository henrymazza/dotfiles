export PATH=~/bin:/Users/HMz/.gem/ruby/1.8/bin:/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
export DAEMON='/Applications/Emacs.app/Contents/MacOS/EMacs'
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWDIRTYSTATE=true
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export GIT_EDITOR='mvim'
export EDITOR='mvim'
export ALTERNATE_EDITOR="mate -w"
export NODE_PATH="/usr/local/lib/node_modules"

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

  RVM=`/Users/HMz/.rvm/bin/rvm-prompt i v g`
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
alias pcat=pygmentize

function pless() {
    pcat "$1" | less -R
}

# Capistrano task completion
complete -C ~/.capistrano-completion.rb -o default cap

#history search binds
bind '"M-e": history-search-backward'
bind '"M-r": history-search-forward'





#autojump


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
data_dir=$([ -e ~/.local/share ] && echo ~/.local/share || echo ~)
export AUTOJUMP_HOME=${HOME}
if [[ "$data_dir" = "${HOME}" ]]
then
    export AUTOJUMP_DATA_DIR=${data_dir}
else
    export AUTOJUMP_DATA_DIR=${data_dir}/autojump
fi
if [ ! -e "${AUTOJUMP_DATA_DIR}" ]
then
    mkdir "${AUTOJUMP_DATA_DIR}"
    mv ~/.autojump_py "${AUTOJUMP_DATA_DIR}/autojump_py" 2>>/dev/null #migration
    mv ~/.autojump_py.bak "${AUTOJUMP_DATA_DIR}/autojump_py.bak" 2>>/dev/null
    mv ~/.autojump_errors "${AUTOJUMP_DATA_DIR}/autojump_errors" 2>>/dev/null
fi

AUTOJUMP='{ [[ "$AUTOJUMP_HOME" == "$HOME" ]] && (autojump -a "$(pwd -P)"&)>/dev/null 2>>${AUTOJUMP_DATA_DIR}/autojump_errors;} 2>/dev/null'
if [[ ! $PROMPT_COMMAND =~ autojump ]]; then
  export PROMPT_COMMAND="${PROMPT_COMMAND:-:} ; $AUTOJUMP"
fi 
alias jumpstat="autojump --stat"
function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";else false; fi }
