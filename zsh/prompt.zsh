

ASYNC_PROC=0
function async() {
    printf "%s" "$(git_status) $(suspended_jobs)" > "/tmp/zsh_prompt_$$"

    kill -s USR1 $$

    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi
}

function async_trigger() {
    ASYNC_PROC=$!
    async &!
}

function TRAPUSR1() {
    vcs_info
    RPROMPT='$(cat /tmp/zsh_prompt_$$)'
    ASYNC_PROC=0

    zle && zle reset-prompt
}

precmd() {
    print -P "\n%F{005}%~ $(node_prompt)"
}

# indicate a job (for example, vim) has been backgrounded
# If there is a job in the background, display a ✱
suspended_jobs() {
    local sj
    sj=$(jobs 2>/dev/null | tail -n 1)
    if [[ $sj == "" ]]; then
        echo ""
    else
        echo "%{%F{208}%}✱%f"
    fi
}

node_prompt() {
    [[ -f package.json || -d node_modules ]] || return

    local version=''
    local node_icon='\ue718'

    if dotfiles::exists node; then
        version=$(node -v 2>/dev/null)
    fi

    [[ -n version ]] || return

    dotfiles::print '029' "$node_icon $version"
}

git_status() {
    dotfiles::is_git || return

    local git_branch="$vcs_info_msg_0_"
    git_branch="${git_branch#heads/}"
    git_branch="${git_branch/.../}"

    [[ -z "$git_branch" ]] && return

    local INDEX git_status=""

    GIT_SYMBOL="\ue725"
    GIT_STATUS_ADDED=$(dotfiles::print '002' '+')
    GIT_STATUS_MODIFIED=$(dotfiles::print '003' '!')
    GIT_STATUS_UNTRACKED=$(dotfiles::print '009' '?')
    GIT_STATUS_RENAMED=$(dotfiles::print '208' '»')
    GIT_STATUS_DELETED=$(dotfiles::print '017' '✘')
    GIT_STATUS_STASHED=$(dotfiles::print '003' '$')
    GIT_STATUS_UNMERGED=$(dotfiles::print '016' '=')
    GIT_STATUS_AHEAD=$(dotfiles::print '012' '⇡')
    GIT_STATUS_BEHIND=$(dotfiles::print '011' '⇣')
    GIT_STATUS_DIVERGED=$(dotfiles::print '012' '⇕')
    GIT_STATUS_CLEAN=$(dotfiles::print '002' '✔')

    INDEX=$(command git status --porcelain -b 2>/dev/null)

    # Check for untracked files
    if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
        git_status="$GIT_STATUS_UNTRACKED$git_status"
    fi

    # Check for staged files
    if $(echo "$INDEX" | command grep '^A[ MDAU] ' &> /dev/null); then
        git_status="$GIT_STATUS_ADDED$git_status"
    elif $(echo "$INDEX" | command grep '^M[ MD] ' &> /dev/null); then
        git_status="$GIT_STATUS_ADDED$git_status"
    elif $(echo "$INDEX" | command grep '^UA' &> /dev/null); then
        git_status="$GIT_STATUS_ADDED$git_status"
    fi

    # Check for modified files
    if $(echo "$INDEX" | command grep '^[ MARC ]M ' &> /dev/null); then
        git_status="$GIT_STATUS_MODIFIED$git_status"
    fi

    # Check for renamed files
    if $(echo "$INDEX" | command grep '^R[ MD] ' &> /dev/null); then
        git_status="$GIT_STATUS_RENAMED$git_status"
    fi

    # Check for deleted files
    if $(echo "$INDEX" | command grep '^[MARCDU ]D ' &> /dev/null); then
        git_status="$GIT_STATUS_DELETED$git_status"
    elif $(echo "$INDEX" | command grep '^D[ UM] ' &> /dev/null); then
        git_status="$GIT_STATUS_DELETED$git_status"
    fi

    # Check for stashes
    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
        git_status="$GIT_STATUS_STASHED$git_status"
    fi

    # Check for unmerged files
    if $(echo "$INDEX" | command grep '^U[UDA] ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    elif $(echo "$INDEX" | command grep '^AA ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    elif $(echo "$INDEX" | command grep '^DD ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    elif $(echo "$INDEX" | command grep '^[DA]U ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    fi

    # Check whether branch is ahead
    local is_ahead=false
    if $(echo "$INDEX" | command grep '^## [^ ]\+ .*ahead' &> /dev/null); then
        is_ahead=true
    fi

    # Check whether branch is behind
    local is_behind=false
    if $(echo "$INDEX" | command grep '^## [^ ]\+ .*behind' &> /dev/null); then
        is_behind=true
    fi

    # Check wheather branch has diverged
    if [[ "$is_ahead" == true && "$is_behind" == true ]]; then
        git_status="$GIT_STATUS_DIVERGED$git_status"
    else
        [[ "$is_ahead" == true ]] && git_status="$GIT_STATUS_AHEAD$git_status"
        [[ "$is_behind" == true ]] && git_status="$GIT_STATUS_BEHIND$git_status"
    fi

    [[ -n "$git_status" ]] || git_status="$GIT_STATUS_CLEAN"

    dotfiles::bold "$git_status"
    dotfiles::print '241' "$git_branch"
}

dotfiles::exists() {
    command -v "$1" > /dev/null 2>&1
}

dotfiles::is_git() {
    [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]
}

dotfiles::bold() {
    echo -n "%B$1%b"
}

dotfiles::print() {
    local color content bold
    [[ -n "$1" ]] && color="%F{$1}" || color="%f"
    [[ -n "$2" ]] && content="$2" || content=""

    [[ -z "$2" ]] && content="$1"

    echo -n "$color"
    echo -n "$content"
    echo -n "%{%b%f%}"
}

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' %b'

add-zsh-hook precmd vcs_info
add-zsh-hook precmd async_trigger

PROMPT_SYMBOL='❯'
export PROMPT='%(?.%F{006}.%F{009})$PROMPT_SYMBOL%f '
export RPROMPT=''
