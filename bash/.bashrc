# Available hooks:
#   bashrc-hook-init.bash: Run before (almost) anything else.
#   bashrc-hook-environment-variables.bash: After the environment is created.
#   bashrc-hook-final.bash: The last thing before control is passed to the user.
# 
# If these files exist in the in the $bash_files_dir (=$HOME/.bash_files), then
# they will be sourced at the relevant time in the rc file.  These can be used
# for machine-specific hooks and need not be committed to source control.

# Do nothing if bash is not running interactively.
reset_extglob=$(shopt -p extglob)
shopt -s extglob
case "$-" in
    !(*i*) ) return ;;
esac
eval "$reset_extglob"
unset reset_extglob

# Source a file, but only if it exists.  This function actually returns an
# executable command so that sourced functions and variables will be in the
# correct scope.  Call this like:
#   `__source if exists "file-to-source.sh"`
# i.e. with surrounding backticks.
function _bashrc_source_if_exists { echo eval "\
    if [ -e \"$1\" ]; then \
        source \"$1\" ; \
    fi";
}

# Print out the exit code of the previous command if it wasn't 0.
function _bashrc_error_code {
    code=$?
    if [ "${code}" -ne 0 ]; then
        printf "\n(%s)" ${code}
    fi
}

# Directory to store additional bash files sourced in this file and other
# initialisations.
bash_files_dir="$HOME/.bash_files"

# Get the initialisation hook.
$(_bashrc_source_if_exists "${bash_files_dir}/bashrc-hook-init.bash")

## Variable setup

# ANSI colour codes corresponding to the solarised colours.
sol_base03='1;30'
sol_base02='30'
sol_base01='1;32'
sol_base00='1;33'
sol_base0='1;34'
sol_base1='1;36'
sol_base2='37'
sol_base3='1;37'
sol_yellow='33'
sol_orange='1;31'
sol_red='31'
sol_magenta='35'
sol_violet='1;35'
sol_blue='34'
sol_cyan='36'
sol_green='32'

# If we're running iTerm2, then we can safely insert the sequence to enable
# italics into colour sequences.
if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
    italics="3;"
else
    italics=""
fi

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
#
# The proceeding '0;' resets any colour flags.
LS_COLORS=""
LS_COLORS+=":no=${italics}${sol_base00}"
LS_COLORS+=":fi=${sol_base0}"
LS_COLORS+=":ex=${sol_blue}"
LS_COLORS+=":di=${sol_magenta}"
LS_COLORS+=":ln=${sol_green}"
LS_COLORS+=":or=${sol_red}"
export LS_COLORS

# Functions for better git integration with bash.
$(_bashrc_source_if_exists "${bash_files_dir}/git-prompt.sh")
$(_bashrc_source_if_exists "${bash_files_dir}/git-completion.bash")

# Make the git prompt show an asterisk if the index is dirty.
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_SSH

# The '\[', '\]' wrap non-printing characters. These ensure that readline knows
# how many characters are in the prompt, so it deletes the correct number when
# the line is cleared, and when it wraps.
ps1_red='\[\e['$sol_red'm\]'
ps1_green='\[\e['$sol_green'm\]'
ps1_yellow='\[\e['$sol_yellow'm\]'
ps1_blue='\[\e['$sol_blue'm\]'
ps1_magenta='\[\e['$sol_magenta'm\]'
ps1_violet='\[\e['$sol_violet'm\]'
ps1_base0='\[\e['$sol_base0'm\]'
ps1_reset='\[\e[0m\]'
if [ "$UID" -eq 0 ]; then
    ps1_username=$ps1_red
else
    ps1_username=$ps1_magenta
fi

if [[ -z $bashrc_ps1_line_length ]]; then
    bashrc_ps1_line_length=80
fi
if [[ -z $bashrc_ps1_single_length ]]; then
    bashrc_ps1_single_length=50
fi

# Print the relevant parts of the pre-prompt to the screen in a desired order.
function _bashrc_ps1_preprompt {
    declare -i cur_len=0
    declare -i line_len=0
    declare -a parts=("$(_bashrc_ps1_pwd)"
                      "$(_bashrc_ps1_conda)"
                      "$(_bashrc_ps1_git)")
    declare -a colours=("${sol_yellow}" "${sol_violet}" "${sol_green}")
    local pre
    local post
    for i in $(seq 0 $((${#parts[@]} - 1))); do
        cur_len=${#parts[$i]}
        pre=''
        post=''
        if [[ $cur_len -eq 0 ]]; then
            continue
        elif [[ $cur_len -gt $bashrc_ps1_single_length ]]; then
            if [[ $line_len -ne 0 ]]; then
                pre='\n'
            fi
            post='\n'
            line_len=0
        elif [[ $line_len -eq 0 ]]; then
            line_len=$cur_len
        elif [[ $((line_len + cur_len)) -gt $bashrc_ps1_line_length ]]; then
            pre='\n'
            line_len=$cur_len
        else
            pre=' '
            line_len=$((1 + line_len + cur_len))
        fi
        echo -en "$pre"
        echo -en '\e['"${colours[$i]}m${parts[$i]}"
        echo -en '\e[0m'
        echo -en "$post"
    done
    echo ""
}

# Print a string representing the current working directory.
if [[ (${BASH_VERSINFO[0]} -ge "5")\
      || ((${BASH_VERSINFO[0]} -eq "4") && (${BASH_VERSINFO[1]} -ge 3)) ]]; then
    function _bashrc_ps1_pwd {
        echo "[${PWD/#$HOME/\~}]"
    }
else
    function _bashrc_ps1_pwd {
        echo "[${PWD/#$HOME/~}]"
    }
fi

# Print a string showing the conda status.
function _bashrc_ps1_conda {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "($CONDA_DEFAULT_ENV)";
    fi
}

# Print a string showing the git status.
function _bashrc_ps1_git {
    if [ -e "${bash_files_dir}/git-prompt.sh" ]; then
        __git_ps1 '(%s)'
    fi
}

# Default prompt format.
PS1=${ps1_reset}
PS1+=${ps1_red}'$(_bashrc_error_code)\n'${ps1_reset}
PS1+='$(_bashrc_ps1_preprompt)\n'
PS1+=${ps1_username}'\u'${ps1_yellow}'@'
PS1+=${ps1_blue}'\h'${ps1_username}'\$'
PS1+=${ps1_reset}' '

# Continuation prompt format.
PS2=${ps1_reset}
PS2+=${ps1_username}${USER//?/-}
PS2+=${ps1_yellow}'-'${ps1_blue}
PS2+=${HOSTNAME//?/-}${ps1_username}'>'
PS2+=${ps1_reset}' '
export PS1 PS2

# Source machine-specific code
$(_bashrc_source_if_exists \
    "${bash_files_dir}/bashrc-hook-environment-variables.bash")

# Permanent aliases.
alias ll='ls -l'
alias mkdir='mkdir -p'

# Alias ls and grep to use colours correctly if the version in the path works
# with the colouring option.  BSD (Mac) ls doesn't recognise the --color=auto
# option, but the Homebrew GNU ls does, so this colour test comes after the
# machine-specific setup which may alter the PATH.
ls_add_options=''
if ls --color=auto &>/dev/null; then
    ls_add_options+=' --color=auto'
fi
if ls --group-directories-first &>/dev/null; then
    ls_add_options+=' --group-directories-first'
fi
alias ls='ls${ls_add_options}'

if echo | grep --color=auto "" &>/dev/null; then
    alias grep='grep --color=auto'
fi

# Source any final bash hooks.
$(_bashrc_source_if_exists "${bash_files_dir}/bashrc-hook-final.bash")
