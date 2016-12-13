alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l'
alias grep='grep --color=auto'
alias more='less'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'

alias glo='git log --oneline'
alias gs='git status'

CC=gcc
PATH="/usr/local/var/homebrew/linked:/usr/local/opt/gcc/bin/:/usr/local/opt/coreutils/libexec/gnubin":$PATH
MANPATH="/usr/local/opt/coreutils/libexec/gnuman":$MANPATH
export CC PATH MANPATH

alias vim='vim --servername VIM'

PAGER=less
# -F autoquits less if the output can be displayed on one screen.
# -r displays control characters raw (like ANSI colour codes).
# -X disables sending the clear screen instruction on load.
LESS=FrX
EDITOR=vim
# In general, this gives non-files as comment-coloured, files as standard text,
# executables as blue, directories as magenta and symlinks as green (unless
# they're broken links, in which case they're red.
LS_COLORS="no=01;32:fi=01;34:di=00;35:ln=00;32:or=01;31:ex=00;34"
export EDITOR GCC_COLORS LESS PAGER GIT_SSH LS_COLORS

# Functions for better git integration with bash.
source ~/.git-prompt.sh
source ~/.git-completion.bash

# Make the git prompt show an asterisk if the index is dirty.
export GIT_PS1_SHOWDIRTYSTATE=1

# Source relevant API tokens - this file shouldn't be on github.
source ~/.api-tokens.sh

# The '\[', '\]' wrap non-printing characters. These ensure that readline knows
# how many characters are in the prompt, so it deletes the correct number when
# the line is cleared, and when it wraps.

# Initialise empty PS1.
PS1=''
# Extra newline for spacing out new inputs.
PS1+='\n'
# Working directory in yellow, in square brackets.
PS1+='\[\e[0;33m\][\w] '
# Show a git status prompt in green if relevant.
PS1+='\[\e[0;32m\]`__git_ps1 "(%s)"`\n'
# Username in magenta.
PS1+='\[\e[0;35m\]\u'
# @ symbol in yellow.
PS1+='\[\e[0;33m\]@'
# System hostname in blue.
PS1+='\[\e[0;34m\]\h'
# Prompt symbol ($ or #) in magenta.
PS1+='\[\e[0;35m\]\$'
# Reset to solarized dark base0 colour for default text.
PS1+='\[\e[1;34m\] '

# Set the PS2 (continuation prompt).
PS2=''
# Magenta for the username length
PS2+='\[\e[0;35m\]----'
# Yellow for the @
PS2+='\[\e[0;33m\]-'
# Blue for the hostname
PS2+='\[\e[0;34m\]------'
# Magenta for the prompt
PS2+='\[\e[0;35m\]>'
# Reset to solarized dark bas0 colour for input.
PS2+='\[\e[1;34m\] '
export PS1 PS2
