autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{28}●'
zstyle ':vcs_info:*' unstagedstr '%F{11}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git hg svn

setopt prompt_subst

precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' %F{blue}[%F{green}%b%c%u%F{blue}]'
    } else {
        zstyle ':vcs_info:*' formats ' %F{blue}[%F{green}%b%c%u%F{red}●%F{blue}]'
    }
 
    vcs_info
}
 
PROMPT='%{%f%k%b%}
%{%K{black}%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{black}%}%~%{%B%F{green}%}${vcs_info_msg_0_}%E%{%b%}
%{%K{black}%}%{%K{black}%} %#%{%f%k%b%} '
