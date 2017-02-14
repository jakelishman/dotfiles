alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l'
alias grep='grep --color=auto'
alias mkdir='mkdir -p -v'

alias glo='git log --oneline'
alias gs='git status'

ADDTOPATH=""
ADDTOPATH+="$HOME/.cargo/bin:"
ADDTOPATH+="/usr/local/var/homebrew/linked:"
ADDTOPATH+="/usr/local/opt/gcc/bin:"
ADDTOPATH+="/usr/local/opt/coreutils/libexec/gnubin:"
export PATH="$ADDTOPATH$PATH"

ADDTOMAN=""
ADDTOMAN+="/usr/local/opt/coreutils/libexec/gnuman:"
export MAN="$ADDTOMAN$MAN"

export CC=gcc GCC_COLORS
export EDITOR=vim
export PAGER=less
# -F autoquits less if the output can be displayed on one screen.
# -r displays control characters raw (like ANSI colour codes).
# -X disables sending the clear screen instruction on load.
export LESS=FrX

# In general, this gives non-files as comment-coloured, files as standard text,
# executables as blue, directories as magenta and symlinks as green (unless
# they're broken links, in which case they're red.
export LS_COLORS="no=01;32:fi=01;34:di=00;35:ln=00;32:or=01;31:ex=00;34"

# Export mono prefix for homebrew
export MONO_GAC_PREFIX="/usr/local"

# Functions for better git integration with bash.
source ~/.dotfiles/git-prompt.sh
source ~/.dotfiles/git-completion.bash

# Make the git prompt show an asterisk if the index is dirty.
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_SSH

# Source relevant API tokens - this file shouldn't be on github.
source ~/.api-tokens.sh

# The '\[', '\]' wrap non-printing characters. These ensure that readline knows
# how many characters are in the prompt, so it deletes the correct number when
# the line is cleared, and when it wraps.

colourred='\[\e[0;31m\]'
colourgreen='\[\e[0;32m\]'
colouryellow='\[\e[0;33m\]'
colourblue='\[\e[0;34m\]'
colourmagenta='\[\e[0;35m\]'
colourbase0='\[\e[1;34m\]'
if [ "$UID" -eq 0 ]; then
    colourusername=${colourred}
else
    colourusername=${colourmagenta}
fi

# Print out the exit code of the previous command if it wasn't 0.
function __error_code {
    code=$?
    if [ "${code}" -ne 0 ]; then
        printf "\n(${code})"
    fi
}

PS1=''
PS1+=${colourred}'`__error_code`\n'
PS1+=${colouryellow}'[\w] '${colourgreen}'`__git_ps1 "(%s)"`\n'
PS1+=${colourusername}'\u'${colouryellow}'@'
PS1+=${colourblue}'\h'${colourusername}'\$'
PS1+=${colourbase0}' '

PS2=''
PS2+=${colourusername}${USER//?/-}
PS2+=${colouryellow}'-'${colourblue}
PS2+=${HOSTNAME//?/-}${colourusername}'>'
PS2+=${colourbase0}' '
export PS1 PS2
