if [ "$ZSH_VERSION" ]; then
    export TERM_TOOLS=$(dirname $(dirname $0:A))
else
    export TERM_TOOLS="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
fi

# Don't pause VIM upon Ctrl-S shortcut..
stty stop undef
stty -ixon

# vim by default
export EDITOR="vim"

# Store extensive history
export SAVEHIST=10000
export HISTSIZE=50000
export HISTFILESIZE=1000000
export HISTFILE=$TERM_TOOLS/history

# zstyle :compinstall filename '/Users/wjakob/.zshrc'
# autoload -Uz compinit
# compinit

# enable core dumps
ulimit -c unlimited 2>/dev/null

# 256 colors
if [[ "$TERM" == "xterm" ]]; then
	export TERM="xterm-256color"
fi

if uname | grep Darwin > /dev/null; then
	# Mac specific commands

	# Also bind find to 'gfind' (install via brew)
	alias find=gfind

	# top: sort by cpu
	alias top="top -o cpu"

    export BROWSER=/Applications/Firefox.app/Contents/MacOS/firefox-bin

	# ls with a 1-second timeout
	function ls_safe {
		$TERM_TOOLS/config/timeout3.sh -t 1 ls -G
	}

    function skim () {
        /Applications/Skim.app/Contents/MacOS/Skim $@ &> /dev/null &
    }

    # Don't include "_something" AppleDouble files in tar files, etc.
    export COPYFILE_DISABLE=1
else
	alias gnome-open=gvfs-open
	alias open=gvfs-open
	alias gdate=date

	function ls_safe {
		$TERM_TOOLS/config/timeout3.sh -t 1 ls --color=auto
	}

    # Support High-DPI in Qt5 apps
    export QT_AUTO_SCREEN_SCALE_FACTOR=1

    # GNU ls: don't wrap entries with spaces into quotes
    export QUOTING_STYLE=literal
fi

# Don't make core dumps by default
ulimit -c 0

# Colors in LS
alias ls='ls -G'

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Ninja: fancy status message
export NINJA_STATUS="[%u/%r/%f] "

# Generate a compile_commands.json file
alias cmake='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1'

# Convenience flags to switch between release and debug mode
alias cmake_deb='cmake $@ -GNinja -DCMAKE_BUILD_TYPE=DEBUG'
alias cmake_rel='cmake $@ -GNinja -DCMAKE_BUILD_TYPE=RELEASE'

# CMake aliases for various compilers
alias cmake_gcc='cmake $@ -GNinja -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_COMPILER=gcc'
alias cmake_clang='cmake $@ -GNinja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++'
alias cmake_clean='rm -rf CMakeCache.txt CMakeFiles'

# Other aliases
alias grpe=grep
alias gdb='gdb -quiet'
alias n=ninja
alias python=python3
alias ipython=ipython3
alias pip=pip3
alias octave='octave --no-gui-libs'
alias pdb='python3 -u -m pdb -c continue'

# zsh-specific configuration
if [ "$ZSH_VERSION" ]; then
    autoload -U history-search-end
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end history-search-end

    bindkey $terminfo[kbs]   backward-delete-char           # Backspace
    bindkey $terminfo[kdch1] delete-char                    # Delete
    bindkey '\e[3~'          delete-char
    bindkey $terminfo[khome] beginning-of-line              # Home
    bindkey "^A"             beginning-of-line
    bindkey $terminfo[kend]  end-of-line                    # End
    bindkey "^E"             end-of-line
    bindkey $terminfo[kcuu1] history-beginning-search-backward-end # Down
    bindkey "^[[A"           history-beginning-search-backward-end # Down
    bindkey $terminfo[kcud1] history-beginning-search-forward-end  # Up
    bindkey "^[[B"           history-beginning-search-forward-end  # Up

    bindkey $terminfo[kcub1] backward-char                  # Left
    bindkey $terminfo[kcuf1] forward-char                   # Right

    bindkey -M vicmd $terminfo[khome] beginning-of-line
    bindkey -M vicmd "^A"             beginning-of-line
    bindkey -M vicmd $terminfo[kend]  end-of-line           # End
    bindkey -M vicmd "^E"             end-of-line
    bindkey -M vicmd '\e[3~'          delete-char

	# ls after every cd
	function chpwd() {
		emulate -L zsh
		ls_safe
	}

	# no error if glob fails to expand (scp fix)
	unsetopt nomatch

	# Automatically escape wildcards in 'scp', 'rsync', and any command with http/ftp args
	autoload -U url-quote-magic
	zle -N self-insert url-quote-magic
	zstyle -e :urlglobber url-other-schema \ '[[ $words[1] == scp ]] && reply=("*") || reply=(http https ftp)'

	# VI mode: enable
	export KEYTIMEOUT=1
	bindkey -v

    # VI mode: allow deleting beyond original insertion
    bindkey -M viins '^?' backward-delete-char
    bindkey -M viins '^H' backward-delete-char

    # Change cursor shape for different vi modes.
    function zle-keymap-select {
      if [[ ${KEYMAP} == vicmd ]] ||
         [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'

      elif [[ ${KEYMAP} == main ]] ||
           [[ ${KEYMAP} == viins ]] ||
           [[ ${KEYMAP} = '' ]] ||
           [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
      fi
    }
    zle -N zle-keymap-select

    _fix_cursor() {
       echo -ne '\e[5 q'
    }
    precmd_functions+=(_fix_cursor)

	# Perform a prefix history search when navigating previous commands
	bindkey -M vicmd 'k' history-beginning-search-backward
	bindkey -M vicmd 'j' history-beginning-search-forward

    autoload -U edit-command-line
	zle -N edit-command-line
	bindkey -M vicmd V edit-command-line

	# Share history between multiple terminals
    setopt inc_append_history
    setopt share_history

    # Completions
    zstyle :compinstall filename '~/.zshrc'
    autoload -Uz compinit
    compinit -d $TERM_TOOLS/zcompdump-$ZSH_VERSION

    # A colorful prompt
    PROMPT="%{%f%k%b%}
%{%K{black}%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{black}%}%~%{%B%F{green}%}%E%{%b%}
%{%K{black}%}%{%K{black}%} %#%{%f%k%b%} "
fi

# bash-specific configuration
if [ "$BASH_VERSION" ]; then
	# ls after every cd
	function cd()  {
		 builtin cd "$@" && ls_safe
	}

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

