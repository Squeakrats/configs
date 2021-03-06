# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_profile_extra ] && source ~/.bash_profile_extra

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
# force_color_prompt=yes

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


#  Customize BASH PS1 prompt to show current GIT repository and branch.
#  by Mike Stewart - http://MediaDoneRight.com

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White
DankGreen="\[\033[38;5;64m\]" # Dank

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[38;5;160m\]"         # Red
BGreen="\[\033[38;5;028m\]"       # Green
BGold="\[\033[38;5;220m\]"
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;38;5;089m\]"
UBPurple="\[\033[4;38;5;089m\]"
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\033[0;103m"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
else
    SU=${BCyan}         # User is normal (well ... most of us are).
fi

hash git;
if [ $? -eq 0 ] && [ ! "$use_git_prompt" = "no" ]; then
	use_git_prompt="yes"
fi

GitClean="$BGreen"
GitDirty="$BRed"

export git_prompt='$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then \
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [ "$?" -eq "0" ]; then \
    echo "'$GitClean'"$(__git_ps1 " (%s)"); \
  else \
    echo "'$GitDirty'"$(__git_ps1 " {%s}"); \
  fi) '$BGold'\$ "; \
else \
  echo " '$Yellow'\$ "; \
fi)'

if [ "$use_git_prompt" = "yes" ]; then
	PS1="$DankGreen \T| $UBPurple\w$Color_Off$BPurple on \h$Color_Off$git_prompt$Color_Off"
else # No git prompt.
	if [ "$color_prompt" = "yes" ]; then
		PS1="$DankGreen\u@\h - \T $Yellow\w \$ "
	else
		PS1='\u@\h:\w\$ '
	fi

fi

export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.

# -i Ignore case, -w highlight unread, -g highlight first match, -M verbose prompt
# -M no init termcap, -F quit if only one screen, -P Prompt 
export LESS='-i -w  -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

#tput Color Capabilities:
# tput setab [1-7] – Set a background color using ANSI escape
# tput setb [1-7] – Set a background color
# tput setaf [1-7] – Set a foreground color using ANSI escape
# tput setf [1-7] – Set a foreground color

#tput Text Mode Capabilities:
# tput bold – Set bold mode
# tput dim – turn on half-bright mode
# tput smul – begin underline mode
# tput rmul – exit underline mode
# tput rev – Turn on reverse mode
# tput smso – Enter standout mode (bold on rxvt)
# tput rmso – Exit standout mode
# tput sgr0 – Turn off all attributes

#Color Code for tput:
# 0 – Black
# 1 – Red
# 2 – Green
# 3 – Yellow
# 4 – Blue
# 5 – Magenta
# 6 – Cyan
# 7 – White
# 8 - Not used
# 9 - Reset to default color

# LESS man page colors (makes Man pages more readable).
# Start blink
export LESS_TERMCAP_mb=$(tput bold)
# Start bold
export LESS_TERMCAP_md=$(tput bold; tput setaf 5)

# Turn off bold, blink, underline
export LESS_TERMCAP_me=$(tput sgr0)

# Start, Stop standout
export LESS_TERMCAP_so=$(tput smso; tput setaf 1; tput setab 7)
export LESS_TERMCAP_se=$(tput sgr0)

# Start, Stop underline
export LESS_TERMCAP_us=$(tput smul)
export LESS_TERMCAP_ue=$(tput rmul)

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export PAGER=less
export EDITOR=vim
export VISUAL=vim


shopt -s autocd
shopt -s cdspell
shopt -s checkhash
shopt -s checkjobs

# append to the history file, don't overwrite it
shopt -s histappend

export GOPATH=/home/swilson/Projects/Gopath
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


uw () {
	sshpass -p "`cat $HOME/.mypass`" "$@"
}

alias uwssh="uw ssh best-linux.cs.wisc.edu"
