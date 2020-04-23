# tmux{{{1

export TERM=xterm-256color

# attach {{{2
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]}Tmux is Running ..${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session
# }}}

# }}}

# basic {{{

[[ -z "$TMUX" && ! -z "$PS1" ]] && exec tmux

autoload -U compinit
compinit

KEYTIMEOUT=0

zstyle ':completion:*' list-colors di=34 fi=0

zstyle ':completion:*:default' menu select=1

# setopt PRINT_EIGHT_BIT

# stack(haskell) completion setting

# homebrew
export PATH="/usr/local/sbin:$PATH"

# }}}

# alias {{{

alias lg='lazygit'

alias _pb_cp='pbcopy && pbpaste'

# git
alias g="git"
compdef g=git
alias gs='git status --short --branch'
alias ga='git add -A'
alias gc='git commit -m'
alias gps='git push'
alias gpsu='git push -u'
alias gp='git pull origin'
alias gf='git fetch'
alias gl="git log --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s %C(red)%d %C(cyan)[%an]' --date=format:'%c' --all --graph"
alias gd='git diff'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch'
alias gm='git merge'
alias gr='git reset'

# }}}

# appearrance {{{1
# git status {{{2
autoload -Uz add-zsh-hook
setopt prompt_subst
function _vcs_git_indicator () {
  typeset -A git_info
  local git_indicator git_status
  git_status=("${(f)$(git status --porcelain --branch 2> /dev/null)}")
  (( $? == 0 )) && {
    git_info[branch]="${${git_status[1]}#\#\# }"
    shift git_status
    git_info[changed]=${#git_status:#\?\?*}
    git_info[untracked]=$(( $#git_status - ${git_info[changed]} ))
    git_info[clean]=$(( $#git_status == 0 ))

    git_indicator=(" %{%F{blue}%}${git_info[branch]}%{%f%}")
	(( ${git_info[clean]}     )) && git_indicator+=("%{%F{green}%}clean%{%f%}")
    (( ${git_info[changed]}   )) && git_indicator+=("%{%F{yellow}%}${git_info[changed]} changed%{%f%}")
    (( ${git_info[untracked]} )) && git_indicator+=("%{%F{red}%}${git_info[untracked]} untracked%{%f%}")
  }
   _vcs_git_indicator="${git_indicator}"
}

add-zsh-hook precmd _vcs_git_indicator

function {
local git='$_vcs_git_indicator'
PROMPT="%F{cyan}%n%f:%F{yellow}%~%f$git %F{blue}"$'\n'"%%%f "
}
# }}}
# }}}

# functions {{{

zrc(){
	source ~/.zshrc
}
zprofile(){
	source ~/.zprofile
}
vimrc(){
	source ~/.vimrc
}
gco_fzf() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
gco_fzf_remote() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# }}}

# TODO:
# contcoll ubuntu
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.zprofile

# Zplugin {{{
### Added by Zplugin's installer
source "$HOME/.zinit/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk
zplugin light chrissicool/zsh-256color
zplugin light zsh-users/zsh-completions
zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-syntax-highlighting
zplugin ice wait lucid; zplugin light b4b4r07/enhancd
export ENHANCD_HYPHEN_NUM="${ENHANCD_HYPHEN_NUM:-30}" # default "cd -" list number chagne to 20
# }}}
