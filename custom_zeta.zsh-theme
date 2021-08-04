# Zeta theme for oh-my-zsh
# Tested on Linux, Unix and Windows under ANSI colors.
# Copyright: Skyler Lee, 2015

# Colors: black|red|blue|green|yellow|magenta|cyan|white
local black=$fg[black]
local red=$fg[red]
local blue=$fg[blue]
local green=$fg[green]
local yellow=$fg[yellow]
local magenta=$fg[magenta]
local cyan=$fg[cyan]
local white=$fg[white]

local black_bold=$fg_bold[black]
local red_bold=$fg_bold[red]
local blue_bold=$fg_bold[blue]
local green_bold=$fg_bold[green]
local yellow_bold=$fg_bold[yellow]
local magenta_bold=$fg_bold[magenta]
local cyan_bold=$fg_bold[cyan]
local white_bold=$fg_bold[white]

local highlight_bg=$bg[red]

#local zeta='ζ'
local zeta='$'

# Machine name.
function get_box_name {
    if [ -f ~/.box-name ]; then
        cat ~/.box-name
    else
#        echo $HOST
		echo %m
    fi
}

# User name.
function get_usr_name {
    local name="%n"
    if [[ "$USER" == 'root' ]]; then
        name="%{$highlight_bg%}%{$white_bold%}$name%{$reset_color%}"
    fi
    echo $name
}

# Directory info.
function get_current_dir {
    echo "${PWD/#$HOME/~}"
}

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$blue_bold%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$green_bold%} ✔ "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red_bold%} ✘ "

# Git status.
ZSH_THEME_GIT_PROMPT_ADDED="%{$green_bold%}+"
ZSH_THEME_GIT_PROMPT_DELETED="%{$red_bold%}-"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$magenta_bold%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$blue_bold%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$cyan_bold%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$yellow_bold%}?"

# Git sha.
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="[%{$green_bold%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

function get_git_prompt {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git_prompt_status)"
        if [[ -n $git_status ]]; then
            git_status="[$git_status%{$reset_color%}]"
        fi
        local git_prompt=" <$(git_prompt_info)$git_status>"
        echo $git_prompt
    fi
}

function get_time_stamp {
    echo "%*"
}

function get_space {
    local str=$1$2
    local zero='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero/}}
    local size=$(( $COLUMNS - $len - 1 ))
    local space=""
    while [[ $size -gt 0 ]]; do
        space="$space "
        let size=$size-1
    done
    echo $space
}

get_space () {
	local STR=$1$2
	local zero='%([BSUbfksu]|([FB]|){*})'
	local LENGTH=${#${(S%%)STR//$~zero/}}
	local SPACES=""
	(( LENGTH = ${COLUMNS} - $LENGTH - 1))
	for i in {0..$LENGTH}
		do
		  SPACES="$SPACES "
		done
	echo $SPACES
}


function virtualenv_or_conda_info {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		echo '('%F{blue}`basename $VIRTUAL_ENV`%f') '
	elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
		echo %F{magenta_bold}'('`basename $CONDA_DEFAULT_ENV`') '%f
	fi
}


NEWLINE=$'\n'
# Prompt: # USER@MACHINE: DIRECTORY <BRANCH [STATUS]> --- (TIME_STAMP)
# > command
function print_prompt_head {
	local head="$(virtualenv_or_conda_info)\
${NEWLINE}"
    local left_prompt="%{$cyan_bold%}$(get_usr_name)\
%{$cyan_bold%}@\
%{$cyan_bold%}$(get_box_name):\
%{$yellow_bold%}$(get_current_dir)%{$reset_color%}\
$(get_git_prompt) "
    #local right_prompt="%{$blue_bold%}[$(get_time_stamp)]%{$reset_color%} "
    #print -rP "$head$left_prompt$(get_space $left_prompt $right_prompt)$right_prompt"
	#print -rP "$head$left_prompt$right_prompt"
	print -rP "$left_prompt$right_prompt"
}

function get_prompt_indicator {
    if [[ $? -eq 0 ]]; then
        echo "%{$white_bold%}$zeta %{$reset_color%}"
    else
        #echo "%{$red_bold%}$zeta %{$reset_color%}"
		echo "%{$magenta_bold%}$zeta %{$reset_color%}"
    fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd print_prompt_head
setopt prompt_subst

PROMPT='$(get_prompt_indicator)'
RPROMPT='$(git_prompt_short_sha)'
