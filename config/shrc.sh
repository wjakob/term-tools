# TERMINAL CONFIG
# source from ~/.bashrc or ~/.zshrc

# directory containing these tools
if [ "$ZSH_VERSION" ]; then
    export TERM_TOOLS=$(dirname $(dirname $0:A))
else
    export TERM_TOOLS="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
fi

# vim by default
export EDITOR="vim"

# store more shell history
export HISTSIZE=1000000
export HISTFILESIZE=1000000

# enable core dumps
ulimit -c unlimited 2>/dev/null

# 256 colors
if [[ "$TERM" == "xterm" ]]; then
	export TERM="xterm-256color"
fi

# syntax highlighting in less
if [ -e /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
	export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
	export LESS=' -R '
elif [ -e /usr/local/bin/src-hilite-lesspipe.sh ]; then
	export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
	export LESS=' -R '
fi


[[ -s /usr/share/autojump/autojump.sh ]] && source /usr/share/autojump/autojump.sh
[[ -s /usr/local/etc/autojump.sh ]] && source /usr/local/etc/autojump.sh

# send ctrl-s to vim
# see http://unix.stackexchange.com/questions/12107/how-to-unfreeze-after-accidentally-pressing-ctrl-s-in-a-terminal
stty stop undef
stty -ixon

if uname | grep Darwin > /dev/null; then
	# Mac specific commands

	# ls with a 1-second timeout
	function ls_safe {
		$TERM_TOOLS/config/timeout3.sh -t 1 ls -G
	}

	# Also bind find to 'gfind' (install via brew)
	alias find=gfind

	# top: sort by cpu
	alias top="top -o cpu"
else
	alias gnome-open=gvfs-open
	alias gqview=geeqie
	alias open=gvfs-open
	alias gdate=date

	function ls_safe {
		$TERM_TOOLS/config/timeout3.sh -t 1 ls --color=auto
	}
fi

alias today="{ echo 'Today: ' && google calendar list --cal=.* --date=today && echo -e ' \nTomorrow: ' && google calendar list --cal=.* --date=tomorrow } | grep -ve '^\[' | grep -ve '^$'"

# ZSH-SPECIFIC CONFIG
if [ "$ZSH_VERSION" ]; then
	ZSH=$HOME/.oh-my-zsh
	ZSH_THEME="wjakob"
	plugins=(zsh-syntax-highlighting)
	source $ZSH/oh-my-zsh.sh

	# ls after every cd
	function chpwd() {
		emulate -L zsh
		ls_safe
	}

	# vim keybindings for zsh
	bindkey '\e[3~' delete-char

	# no error if glob fails to expand (scp fix)
	unsetopt nomatch

	# Automatically escape wildcards in 'scp' and 'rsync' commands
	__remote_commands=(scp rsync)
	autoload -U url-quote-magic
	zle -N self-insert url-quote-magic
	zstyle -e :urlglobber url-other-schema '[[ $__remote_commands[(i)$words[1]] -le ${#__remote_commands} ]] && reply=("*") || reply=(http https ftp)'

	# Enable VIM mode, adjust delays
	export KEYTIMEOUT=1
	bindkey -v

	# VIM mode: visualize the current editing mode
	vim_ins_mode="[INS]"
	vim_cmd_mode="[CMD]"
	vim_mode=$vim_ins_mode
	function zle-keymap-select {
		vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
		zle reset-prompt
	}
	function zle-line-finish {
		vim_mode=$vim_ins_mode
	}
	zle -N zle-keymap-select
	zle -N zle-line-finish
	RPROMPT='${vim_mode}'

	autoload up-line-or-history
	autoload down-line-or-history

	# Perform a prefix history search when navigating previous commands
	bindkey -M vicmd 'k' history-beginning-search-backward
	bindkey -M vicmd 'j' history-beginning-search-forward
	bindkey -M vicmd 'v' edit-command-line
	source $TERM_TOOLS/config/zsh-vi-search.zsh
fi

# BASH-SPECIFIC CONFIG
if [ "$BASH_VERSION" ]; then
	# ls after every cd
	function cd()  {
		 builtin cd "$@" && ls_safe
	}

	# Custom terminal: blue path and yellow git branch
	#export PROMPT_DIRTRIM=2  # uncomment to trim to 2 directories
	DEFAULT_COLOR="\[\e[0m\]"
	PS1_COLOR="\[\e[34m\]"
	TITLEBAR="\[\e]0;\h \w\007\]"
	PS1="$TITLEBAR\n$PS1_COLOR\h:\w\n \$$DEFAULT_COLOR "

	# don't put duplicate lines or lines starting with space in the history.
	export HISTCONTROL=ignoreboth

	# don't clobber history
	shopt -s histappend

	# check the window size after each command and, if necessary,
	# update the values of LINES and COLUMNS.
	shopt -s checkwinsize

	# automatically correct cd spelling errors
	shopt -s cdspell

	# The correctall feature is at times painful to use with 'cp', 'mv', and 'mkdir' -- disable it!
	# http://superuser.com/questions/251818/exceptions-to-zsh-correctall-feature
	alias cp='nocorrect cp '
	alias mv='nocorrect mv '
	alias mkdir='nocorrect mkdir '
fi

function pw { $TERM_TOOLS/config/make-password.pl -p -a $1 ~/.pwdata ; }

function get_timezone {
	if [ -z "$TZNAME" ]; then
		if [ -f /etc/timezone ]; then
			TZNAME=`cat /etc/timezone`
		elif [ -h /etc/localtime ]; then
			TZNAME=`readlink /etc/localtime | sed "s/\/usr\/share\/zoneinfo\///"`
		fi
	fi
}

# Convenience to convert between EST/PST/CE(S)T
function from_pst { gdate --date="TZ=\"US/Pacific\"    $@" }
function from_est { gdate --date="TZ=\"US/Eastern\"    $@" }
function from_cet { gdate --date="TZ=\"Europe/Berlin\" $@" }
function to_pst   { get_timezone; TZ="US/Pacific"    gdate --date="TZ=\"$TZNAME\" $@" }
function to_est   { get_timezone; TZ="US/Eastern"    gdate --date="TZ=\"$TZNAME\" $@" }
function to_cet   { get_timezone; TZ="Europe/Berlin" gdate --date="TZ=\"$TZNAME\" $@" }
