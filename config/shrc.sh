if [ "$ZSH_VERSION" ]; then
    export TERM_TOOLS=$(dirname $(dirname $0:A))
else
    export TERM_TOOLS="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
fi

# Don't pause VIM upon Ctrl-S shortcut..
if [ -t 1 ]; then
    stty stop undef
    stty -ixon
fi

# vim by default
export EDITOR="vim"

# Store extensive history
export SAVEHIST=10000
export HISTSIZE=50000
export HISTFILESIZE=1000000

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

    # Colors in LS
    alias ls='ls -G'
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

    # Colors in LS
    alias ls='ls --color=auto'
fi

# Don't make core dumps by default
ulimit -c 0

# make less more friendly for non-text input files
if [ -e /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
   export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
   export LESS=' -R '
elif [ -e /usr/local/bin/src-hilite-lesspipe.sh ]; then
   export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
   export LESS=' -R '
fi

if type "fd" > /dev/null; then
    export FZF_DEFAULT_COMMAND="fd --type f"
else
    export FZF_DEFAULT_COMMAND="fdfind --type f"
    alias fd=fdfind
fi

export FZF_DEFAULT_OPTS="--extended --bind=pgup:up,pgdn:down "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
    export HISTFILE=$TERM_TOOLS/.zsh-history

    autoload -U history-search-end
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end history-search-end

    bindkey -M viins $terminfo[kbs] backward-delete-char # Backspace

    for mode in vicmd viins
    do
        bindkey -M $mode $terminfo[kcub1] backward-char # Left
        bindkey -M $mode $terminfo[kcuf1] forward-char  # Right

        bindkey -M $mode $terminfo[khome] beginning-of-line
        bindkey -M $mode "^A"             beginning-of-line
        bindkey -M $mode $terminfo[kend]  end-of-line
        bindkey -M $mode "^E"             end-of-line
        bindkey -M $mode '\e[3~'          delete-char

        bindkey -M $mode $terminfo[kdch1] delete-char # Delete
        bindkey -M $mode '\e[3~'          delete-char

        bindkey -M $mode $terminfo[kcuu1] history-beginning-search-backward-end # Down
        bindkey -M $mode "^[[A"           history-beginning-search-backward-end # Down
        bindkey -M $mode $terminfo[kcud1] history-beginning-search-forward-end  # Up
        bindkey -M $mode "^[[B"           history-beginning-search-forward-end  # Up
    done

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
            psvar[1]="1"
        elif [[ ${KEYMAP} == main ]] ||
             [[ ${KEYMAP} == viins ]] ||
             [[ ${KEYMAP} = '' ]] ||
             [[ $1 = 'beam' ]]; then
            echo -ne '\e[5 q'
            psvar[1]=""
        fi
        zle reset-prompt
    }
    zle -N zle-keymap-select

    PR_COUNT=0
    _my_precmd() {
       # Switch to insert mode, add newline before prompt (except first)
       ((PR_COUNT++))
       if ! [ $PR_COUNT = 1 ]; then
           echo -e '\e[5 q'
       else
           echo -ne '\e[5 q'
       fi
       psvar[1]=""
       psvar[2]=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    }
    precmd_functions+=(_my_precmd)

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
    compinit -d $TERM_TOOLS/.zcompdump-$ZSH_VERSION

    # Set up a table with color codes (from oh-my-zsh's spectrum.zsh)
    typeset -AHg FX FG BG

    FX=(
        reset     "%{[00m%}"
        bold      "%{[01m%}" no-bold      "%{[22m%}"
        italic    "%{[03m%}" no-italic    "%{[23m%}"
        underline "%{[04m%}" no-underline "%{[24m%}"
        blink     "%{[05m%}" no-blink     "%{[25m%}"
        reverse   "%{[07m%}" no-reverse   "%{[27m%}"
    )

    for color in {000..255}; do
        FG[$color]="%{[38;5;${color}m%}"
        BG[$color]="%{[48;5;${color}m%}"
    done

    source $TERM_TOOLS/config/prompt.zsh
    source $TERM_TOOLS/config/fzf.zsh
fi

# bash-specific configuration
if [ "$BASH_VERSION" ]; then
    export HISTFILE=$TERM_TOOLS/.bash-history

    # ls after every cd
    function cd()  {
         builtin cd "$@" && ls_safe
    }

    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

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
