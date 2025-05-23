# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#
# Custom TT
# 
# Prompt
PS_COLOR="31m"
if [ "$HOST" == "nextstep" ]; then PS_COLOR="34m"; fi
PS1="\[\e]0;\w\a\] \n[\!] \[\033[31;$PS_COLOR\]\u:\h\[\033[32m\] \w\[\033[30m\]\[\033[1;33m\] > \[\033[0m\]"

# Colors for ls command
LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS
alias ll='ls -al'

# So you can quickly print a column by piping through one of the awkN-s
alias awk1='awk "{ print \$1 }"'
alias awk2='awk "{ print \$2 }"'
alias awk3='awk "{ print \$3 }"'
alias awk4='awk "{ print \$4 }"'

# Sime niceties
export VISUAL=vim
export EDITOR="$VISUAL"
export TIME="TIME REPORT - K: %K KB,    M: %M KB,     CPU: %P,    Time: %e seconds"
alias hless='history | less'
alias gs='git status'
alias gw='git switch'
alias gb='git branch'
alias gl='git log'
alias glo='git log --oneline'
alias glog='git log --oneline --graph'


# List all git extra files (that could be removed)
alias g-extra='git status -s | grep -e "??" | awk2'
alias g-root='git rev-parse --show-toplevel'
alias g-parent='git log --pretty=%P -n 1'
alias g-which-branch='git branch -a --contains'

# Log all commands ran on this machine
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
    __git_complete gs git_status
    __git_complete gw git_switch
    __git_complete gb git_branch
    __git_complete gl git_log
    __git_complete glo git_log
    __git_complete glog git_log
fi

sea() {
  local dir
  dir=$(pwd)

  if [[ "$dir" == $(realpath "$PROJECTS_ROOT/tt-metal")* ]]; then
    source python_env/bin/activate
  elif [[ "$dir" == $(realpath "$PROJECTS_ROOT/tt-mlir")* ]]; then
    source env/activate
  elif [[ "$dir" == $(realpath "$PROJECTS_ROOT/tt-xla")* ]]; then
    source venv/activate
  elif [[ "$dir" == $(realpath "$PROJECTS_ROOT/tt-forge-fe")** ]]; then
    source env/activate
  else
    echo "Unknown project for sea"
    return 1
  fi
}

# Install direnv
eval "$(direnv hook bash)"

# export TTMLIR_TOOLCHAIN_DIR=/proj_sw/user_dev/ndrakulic/ttmlir-toolchain
# export TTMLIR_VENV_DIR=/proj_sw/user_dev/ndrakulic/ttmlir-toolchain/venv
# export TTFORGE_TOOLCHAIN_DIR=/proj_sw/user_dev/ndrakulic/ttforge-toolchain
# export TTFORGE_VENV_DIR=/proj_sw/user_dev/ndrakulic/ttforge-toolchain/venv

export PATH="/home/ndrakulic/.cargo/bin:$PATH"

export CCACHE_DIR=/localdev/ndrakulic/ccache
export PROJECTS_ROOT=/localdev/ndrakulic