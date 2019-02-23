# zplug

# zplugを使う
source ~/.zplug/init.zsh
# 自分自身をプラグインとして管理
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"

# cd移動強化
zplug 'b4b4r07/enhancd', use:"init.sh"

# history関係
zplug "zsh-users/zsh-history-substring-search"

# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"


# インストールしてないプラグインはインストール
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load


# ################################# END Plug Setting ######################## #


# zsh起動時にtmux起動
[[ -z "$TMUX" && ! -z "$PS1" ]] && exec tmux


# 移動系便利コマンド デフォルトの状態から使える（多分
autoload -U compinit
compinit


PROMPT='
%F{green}%(5~,%-1~/.../%2~,%~)%f
%F{green}%B>> %b%f'


# ################################  start alias setting #################### #


# ###############################   new-session   ######################### #

# tmuxが起動していない場合にalias設定を行う
#if [ $SHLVL = 1 ]; then
#    # tmuxにセッションがなかったら新規セッションを立ち上げた際に分割処理設定を読み込む
#    alias tmux="tmux -2 attach || tmux -2 new-session \; source-file ~/dotfiles/.tmux/new-session"
#fi
#
# ##############################   END new-sission ######################## #


# --------------------------------------------------
#  git エイリアス
# --------------------------------------------------

alias g="git"
compdef g=git

alias gs='git status --short --branch'
alias ga='git add -A'
alias gc='git commit -m'
alias gps='git push'
alias gpsu='git push -u origin'
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



# ######################### ブランチ状況を表示 ################ #

# ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}[$branch_name]"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側(RPROMPT)にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'

# ############################################################# #



# compinitの初期化
autoload -U compinit
compinit

# 色つきの補完
zstyle ':completion:*' list-colors di=34 fi=0

# 補完候補をカーソルで選択できる
zstyle ':completion:*:default' menu select=1

#補完リストに8ビットコードを使う
setopt PRINT_EIGHT_BIT

