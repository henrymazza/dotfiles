export PATH=~/bin:/usr/local/sbin:~/.rbenv/bin:/usr/local/share/npm/bin:$PATH
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWDIRTYSTATE=true
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export GIT_EDITOR="mate --name 'Git Commit Message' -w -l 1"
export EDITOR='mvim -f'
export ALTERNATE_EDITOR="mate -w"
export NODE_PATH="/usr/local/lib/node_modules"

# # To disable coreutils delete this session
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
# # Terminal colours (after installing GNU coreutils)
# NM="\[\033[0;38m\]" #means no background and white lines
# HI="\[\033[0;37m\]" #change this for letter colors
# HII="\[\033[0;31m\]" #change this for letter colors
# SI="\[\033[0;33m\]" #this is for the current directory
# IN="\[\033[0m\]"
# if [ "$TERM" != "dumb" ]; then
#   export LS_OPTIONS='--color=auto'
#   eval `dircolors ~/.dir_colors`
# fi
# # Useful aliases
# alias ls='ls $LS_OPTIONS -hF'
# alias ll='ls $LS_OPTIONS -lhF'
# alias l='ls $LS_OPTIONS -lAhF'
# # End of coreutils session

eval "$(rbenv init -)"

shopt -s globstar autocd

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

  RVM=`rbenv version | awk '{print $1}'`
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
alias duf='du -kd 1 | sort -nr | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'

function pless() {
    pcat "$1" | less -R
}

# Capistrano task completion
complete -C ~/.capistrano-completion.rb -o default cap

# SSH completion
complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh

#history search binds
# bind '"M-e": history-search-backward'
# bind '"M-r": history-search-forward'

# History Hacks
HISTSIZE=9000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignorespace:ignoredups
shopt -s histappend
PROMPT_COMMAND="$PROMPT_COMMAND;history -a; history -n"





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


fp () { #find and list processes matching a case-insensitive partial-match string
        ps Ao pid,comm|awk '{match($0,/[^\/]+$/); print substr($0,RSTART,RLENGTH)": "$1}'|grep -i $1|grep -v grep
}

fk () { # build menu to kill process
    IFS=$'\n'
    PS3='Kill which process? '
    select OPT in $(fp $1) "Cancel"; do
        if [ $OPT != "Cancel" ]; then
            kill $(echo $OPT|awk '{print $NF}')
        fi
        break
    done
    unset IFS
}
