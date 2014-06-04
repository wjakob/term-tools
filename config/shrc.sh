# TERMINAL CONFIG
# source from ~/.bashrc or ~/.zshrc

# directory containing these tools
export TERM_TOOLS=~/term-tools

# vim by default instead of emacs
#set -o vi
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
fi

# autojump
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh
if [ "$BASH_VERSION" ]; then
	complete -F _cd j
fi

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

	function ls_safe {
		$TERM_TOOLS/config/timeout3.sh -t 1 ls --color=auto
	}
fi

alias today="google calendar today"

# autojump wrapper (I've renamed "function j" in
#   autojump.sh to "function j_impl")
function j {
	local _p=$PWD
	j_impl $@

	if [[ "$PWD" == "$_p" ]] && [ -d "$1" ]; then
		cd $1
		echo -e "\\033[31m${PWD}\\033[0m"
	fi
}

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

	# Perform a previx history search when navigating previous commands
	bindkey -M vicmd 'k' history-search-backward
	bindkey -M vicmd 'j' history-search-forward
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

	# The correctall feature is at times painful to use with 'cp' and 'mv' -- disable it!
	# http://superuser.com/questions/251818/exceptions-to-zsh-correctall-feature
	alias cp='nocorrect cp '
	alias mv='nocorrect mv '
fi

function pw { $TERM_TOOLS/config/make-password.pl -p -a $1 ~/.pwdata ; }
