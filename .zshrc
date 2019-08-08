# call local {{{

# 配列形式で変数宣言
ZSH_ARRAY=(
            Ignore/.zshrc.slack
		)

for zsh in "${ZSH_ARRAY[@]}"
do
	source ~/dotfiles/zsh/"$zsh"
done

# }}}

# {{{
# 環境設定
# source ~/dotfiles/zsh/.zprofile

# プラグイン設定
# source ~/dotfiles/zsh/.zshrc.plugins_setting

# 起動時自動アタッチ設定
# source ~/dotfiles/zsh/.zshrc.auto_attach

# 基本設定
# source ~/dotfiles/zsh/.zshrc.basic

# エイリアス設定
# source ~/dotfiles/zsh/.zshrc.alias

# 表示設定
# source ~/dotfiles/zsh/.zshrc.apperance

# function setting
# source ~/dotfiles/zsh/.zshrc.functions
# }}}

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=~/.local/bin:$PATH

# stack completion (haskell)
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"

# zplug {{{

# zplugを使う
source ~/.zplug/init.zsh
# 自分自身をプラグインとして管理
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"

# enhancd
zplug 'b4b4r07/enhancd', use:"init.sh"
export ENHANCD_HYPHEN_NUM="${ENHANCD_HYPHEN_NUM:-20}"
# default "cd -" list number chagne to 20
# export ENHANCD_HYPHEN_NUM -n 20

# history関係
zplug "zsh-users/zsh-history-substring-search"

# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"

# gomi
zplug "b4b4r07/zsh-gomi"

# インストールしてないプラグインはインストール
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# }}}

# attach {{{
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
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
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

# basic {{{

[[ -z "$TMUX" && ! -z "$PS1" ]] && exec tmux

# tmuxが起動していない場合にalias設定を行う
#if [ $SHLVL = 1 ]; then
#    # tmuxにセッションがなかったら新規セッションを立ち上げた際に分割処理設定を読み込む
#    alias tmux="tmux -2 attach || tmux -2 new-session \; source-file ~/dotfiles/.tmux/new-session"
#fi

# 移動系便利コマンド デフォルトの状態から使える（多分
autoload -U compinit
compinit

# ESCキーのディレイを減らす
KEYTIMEOUT=0

# 色つきの補完
zstyle ':completion:*' list-colors di=34 fi=0

# 補完候補をカーソルで選択できる
zstyle ':completion:*:default' menu select=1

#補完リストに8ビットコードを使う
# setopt PRINT_EIGHT_BIT

# stack(haskell) completion setting

# opam rlwrap ocaml
alias ocaml="rlwrap ocaml"

# homebrewで必要
export PATH="/usr/local/sbin:$PATH"

# }}}

# alias {{{

# alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:?/} brew"
# alias brew="env PATH=${PATH/\/usr\/local\/include\.pyenv\/shims:?/} brew"

# tmux ペインエイリアス {{{

# if [ $SHLVL = 1 ]; then
#     alias tmuxg="tmux attach || tmux new-session \; source-file ~/.tmux/new-session"
# fi

# }}}

#  git エイリアス {{{

alias g="git"
compdef g=git

alias gs='git status --short --branch'
alias ga='git add -A'
alias gc='git commit -m'
alias gps='git push'
alias gpsu='git push -u'
alias gp='git pull origin'
alias gf='git fetch'

# logを見やすく
alias gl='git log --abbrev-commit --no-merges --date=short --date=iso'
# grep
alias glg='git log --abbrev-commit --no-merges --date=short --date=iso --grep'
# ローカルコミットを表示
alias glc='git log --abbrev-commit --no-merges --date=short --date=iso origin/html..html'

alias gd='git diff'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch'

alias gm='git merge'
alias gr='git reset'

# google検索
alias goo='open https://www.google.co.jp/search\?q\=`pbpaste`'

# }}}

#  c言語コンパイルと実行のエイリアス {{{

function with_echo() {
  echo $@
  $@
}

function cpp_compile() {
 # with_echo g++ -std=c++14 -g -O0 -o $1 $2
 with_echo g++ -std=c++2a -g -O0 -o $1 $2
}

function cpp_run() {
  cpp_file=$1
  exe_file=${cpp_file:0:-4}
  shift

  if [ -s $cpp_file ]; then
    if [ ! -f $exe_file ]; then
      cpp_compile $exe_file $cpp_file && ./$exe_file $@
    else
      cpp_date=`date -r $cpp_file +%s`
      exe_date=`date -r $exe_file +%s`
      if [ $cpp_date -gt $exe_date ]; then
        cpp_compile $exe_file $cpp_file && ./$exe_file $@
      else
        ./$exe_file $@
      fi
    fi
  else
    echo $cpp_file is empty
  fi
}

alias -s cpp=cpp_run

alias clang-omp='/usr/local/opt/llvm/bin/clang -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'

# }}}

# cpp alias {{{
alias clang-omp++='/usr/local/opt/llvm/bin/clang++ -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'
# }}}

# lazygit呼び出しエイリアス
alias lg='lazygit'

# pbcopy && pbpaste
alias _pb_cp='pbcopy && pbpaste'

# }}}

# apperance {{{
# PROMPT='
# %F{green}%(5~,%-1~/.../%2~,%~)%f
# %F{green}%B>> %b%f'


# ######################### ブランチ状況を表示 ################ #
#
## ブランチ名を色付きで表示させるメソッド
#function rprompt-git-current-branch {
#  local branch_name st branch_status
#
#  if [ ! -e  ".git" ]; then
#    # gitで管理されていないディレクトリは何も返さない
#    return
#  fi
#  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
#  st=`git status 2> /dev/null`
#  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
#    # 全てcommitされてクリーンな状態
#    branch_status="%F{green}"
#  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
#    # gitに管理されていないファイルがある状態
#    branch_status="%F{red}?"
#  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
#    # git addされていないファイルがある状態
#    branch_status="%F{red}+"
#  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
#    # git commitされていないファイルがある状態
#    branch_status="%F{yellow}!"
#  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
#    # コンフリクトが起こった状態
#    echo "%F{red}!(no branch)"
#    return
#  else
#    # 上記以外の状態の場合は青色で表示させる
#    branch_status="%F{blue}"
#  fi
#  # ブランチ名を色付きで表示する
#  echo "${branch_status}[$branch_name]"
#}
#
## プロンプトが表示されるたびにプロンプト文字列を評価、置換する
#setopt prompt_subst
#
## プロンプトの右側(RPROMPT)にメソッドの結果を表示させる
#RPROMPT='`rprompt-git-current-branch`'
#
# ############################################################# #

# ### gitのステータスを表示する ###
autoload -Uz add-zsh-hook

setopt prompt_subst

typeset -A emoji
emoji[ok]=$'\U2705'
emoji[error]=$'\U274C'
emoji[git]=$'\U1F500'
emoji[git_changed]=$'\U1F37A'
emoji[git_untracked]=$'\U1F363'
emoji[git_clean]=$'\U2728'
emoji[right_arrow]=$'\U2794'

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

    git_indicator=("${emoji[git]}  %{%F{blue}%}${git_info[branch]}%{%f%}")
    (( ${git_info[clean]}     )) && git_indicator+=("${emoji[git_clean]}")
    (( ${git_info[changed]}   )) && git_indicator+=("${emoji[git_changed]}  %{%F{yellow}%}${git_info[changed]} changed%{%f%}")
    (( ${git_info[untracked]} )) && git_indicator+=("${emoji[git_untracked]}  %{%F{red}%}${git_info[untracked]} untracked%{%f%}")
  }
   _vcs_git_indicator="${git_indicator}"
}

add-zsh-hook precmd _vcs_git_indicator

function {
  local dir='%{%F{blue}%B%}%~%{%b%f%}'
  # local now='%{%F{yellow}%}%D{%b %e %a %R %Z}%{%f%}'  # 現在時刻の表示　zshのステータスバーに表示済みなので、無効化しておく
  local rc="%(?,${emoji[ok]} ,${emoji[error]}  %{%F{red}%}%?%{%f%})"
  local user='%{%F{green}%}%n%{%f%}'
  local host='%{%F{green}%}%m%{%f%}'
  [ "$SSH_CLIENT" ] && local via="${${=SSH_CLIENT}[1]} %{%B%}${emoji[right_arrow]}%{%b%} "
  local git='$_vcs_git_indicator'
  local mark=$'\n%# '
  PROMPT="$dir $user($via$host) $rc $git$mark"
  RPROMPT="$now"
}
# #############################

# }}}

# functions {{{

# source zsh {{{
zrc(){
	source ~/.zshrc
}
# }}}

# source ~/.vimrc {{{
vimrc(){
	source ~/.vimrc
}
# }}}

# git checkout with fzf {{{
gco_fzf() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
# }}}

# git checkout with fzf include remote {{{
gco_fzf_remote_with() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
# }}}

# fzf cd {{{
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# }}}
