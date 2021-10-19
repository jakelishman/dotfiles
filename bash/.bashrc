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
_bashrc_sol_base03='1;30'
_bashrc_sol_base02='30'
_bashrc_sol_base01='1;32'
_bashrc_sol_base00='1;33'
_bashrc_sol_base0='1;34'
_bashrc_sol_base1='1;36'
_bashrc_sol_base2='37'
_bashrc_sol_base3='1;37'
_bashrc_sol_yellow='33'
_bashrc_sol_orange='1;31'
_bashrc_sol_red='31'
_bashrc_sol_magenta='35'
_bashrc_sol_violet='1;35'
_bashrc_sol_blue='34'
_bashrc_sol_cyan='36'
_bashrc_sol_green='32'

# If we're running iTerm2, then we can safely insert the sequence to enable
# italics into colour sequences.
if [[ "$TERM_PROGRAM" = "iTerm.app" ]]; then
    _bashrc_italics="3;"
elif [[ -n "$ConEmuBuild" ]]; then
    _bashrc_italics="42;"
elif [[ "$OS" = "Windows_NT" ]]; then
    _bashrc_italics="3;"
else
    _bashrc_italics=""
fi

_bashrc_sol_comment=${_bashrc_sol_base00}
_bashrc_sol_main=${_bashrc_sol_base0}

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
function _bashrc_ls_colors {
    LS_COLORS=""
    LS_COLORS+=":no=${_bashrc_italics}${_bashrc_sol_comment}"
    LS_COLORS+=":fi=${_bashrc_sol_main}"
    LS_COLORS+=":ex=${_bashrc_sol_blue}"
    LS_COLORS+=":di=${_bashrc_sol_magenta}"
    LS_COLORS+=":ln=${_bashrc_sol_green}"
    LS_COLORS+=":or=${_bashrc_sol_red}"
    export LS_COLORS
}
_bashrc_ls_colors

# Functions for better git integration with bash.
$(_bashrc_source_if_exists "${bash_files_dir}/git-prompt.sh")
$(_bashrc_source_if_exists "${bash_files_dir}/git-completion.bash")

# Make the git prompt show an asterisk if the index is dirty.
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_SSH

# The '\[', '\]' wrap non-printing characters. These ensure that readline knows
# how many characters are in the prompt, so it deletes the correct number when
# the line is cleared, and when it wraps.
function _bashrc_ansi_to_ps1 {
    echo -n '\[\e['$1'm\]'
}
ps1_reset='\[\e[0m\]'
if [ "$UID" -eq 0 ]; then
    ps1_username=$(_bashrc_ansi_to_ps1 $_bashrc_sol_red)
else
    ps1_username=$(_bashrc_ansi_to_ps1 $_bashrc_sol_magenta)
fi

if [[ -z $_bashrc_ps1_line_length ]]; then
    _bashrc_ps1_line_length=80
fi
if [[ -z $_bashrc_ps1_single_length ]]; then
    _bashrc_ps1_single_length=50
fi

# Print the relevant parts of the pre-prompt to the screen in a desired order.
function _bashrc_ps1_preprompt {
    declare -i cur_len=0
    declare -i line_len=0
    declare -a parts=("$(_bashrc_ps1_pwd)"
                      "$(_bashrc_ps1_conda)"
                      "$(_bashrc_ps1_git)")
    declare -a colours=("${_bashrc_sol_yellow}" "${_bashrc_sol_violet}" "${_bashrc_sol_green}")
    local pre
    local post
    for i in $(seq 0 $((${#parts[@]} - 1))); do
        cur_len=${#parts[$i]}
        pre=''
        post=''
        if [[ $cur_len -eq 0 ]]; then
            continue
        elif [[ $cur_len -gt $_bashrc_ps1_single_length ]]; then
            if [[ $line_len -ne 0 ]]; then
                pre='\n'
            fi
            post='\n'
            line_len=0
        elif [[ $line_len -eq 0 ]]; then
            line_len=$cur_len
        elif [[ $((line_len + cur_len)) -gt $_bashrc_ps1_line_length ]]; then
            pre='\n'
            line_len=$cur_len
        else
            pre=' '
            line_len=$((1 + line_len + cur_len))
        fi
        printf "$pre"'\e['"${colours[$i]}m${parts[$i]}"'\e[0m'"$post"
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
    if [[ -e "${bash_files_dir}/git-prompt.sh" ]]; then
        __git_ps1 '(%s)'
    fi
}

# Default prompt format.
function _bashrc_ps1 {
    local _ps1
    _ps1=${ps1_reset}
    _ps1+=$(_bashrc_ansi_to_ps1 ${_bashrc_sol_red})'`_bashrc_error_code`\n'${ps1_reset}
    _ps1+='`_bashrc_ps1_preprompt`\n'
    _ps1+=${ps1_username}'\u'$(_bashrc_ansi_to_ps1 ${_bashrc_sol_yellow})'@'
    _ps1+=$(_bashrc_ansi_to_ps1 ${_bashrc_sol_blue})'\h'${ps1_username}'\$'
    _ps1+=${ps1_reset}' '
    export PS1=$_ps1
}
_bashrc_ps1

# Continuation prompt format.
PS2=${ps1_reset}
if [[ -n "$USERNAME" ]]; then
    PS2+=${ps1_username}${USERNAME//?/-}
else
    PS2+=${ps1_username}${USER//?/-}
fi
PS2+=${ps1_yellow}'-'${ps1_blue}
PS2+=${HOSTNAME//?/-}${ps1_username}'>'
PS2+=${ps1_reset}' '
export PS2

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
