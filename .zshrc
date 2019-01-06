# --------------------------------------------------
#  カレントディレクトリ表示（左）
# --------------------------------------------------

PROMPT='
%F{green}%(5~,%-1~/.../%2~,%~)%f
%F{green}%B●%b%f'

# --------------------------------------------------
#  git branch状態を表示（右）
# --------------------------------------------------

autoload -Uz vcs_info
setopt prompt_subst

# true | false
# trueで作業ブランチの状態に応じて表示を変える
zstyle ':vcs_info:*' check-for-changes false
# addしてない場合の表示
zstyle ':vcs_info:*' unstagedstr "%F{red}%B＋%b%f"
# commitしてない場合の表示
zstyle ':vcs_info:*' stagedstr "%F{yellow}★ %f"
# デフォルトの状態の表示
zstyle ':vcs_info:*' formats "%u%c%F{green}【 %b 】%f"
# コンフリクトが起きたり特別な状態になるとformatsの代わりに表示
zstyle ':vcs_info:*' actionformats '【%b | %a】'

precmd () { vcs_info }

RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# --------------------------------------------------
#  gitコマンド補完機能セット
# --------------------------------------------------

# autoloadの文より前に記述
fpath=(~/.zsh/completion $fpath)

# --------------------------------------------------
#  コマンド入力補完
# --------------------------------------------------

# 補完機能有効にする
autoload -U compinit
compinit -u

# 補完候補に色つける
autoload -U colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word
# 補完候補をハイライト
zstyle ':completion:*:default' menu select=1
# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true
# 大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完リストの表示間隔を狭くする
setopt list_packed

# コマンドの打ち間違いを指摘してくれる
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "

# --------------------------------------------------
#  $ cd 機能拡張
# --------------------------------------------------

# cdを使わずにディレクトリを移動できる
setopt auto_cd
# $ cd - でTabを押すと、ディレクトリの履歴が見れる
setopt auto_pushd

# --------------------------------------------------
#  $ tree でディレクトリ構成表示
# --------------------------------------------------

alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"

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


# --------------------------------------------------
#  その他のエイリアス
# --------------------------------------------------

alias B='php ./build'
alias CB='cd ./build_company'

alias cw='compass watch --time'

# --------------------------------------------------
#  bindkey
# --------------------------------------------------

# bindkeyを任意のキー（commandとかoption）にする設定方法
# 1. iTerm2の環境設定>Keys>追加（＋）
# 2. keyboard shortcut → 任意のキー　｜　action → Send Escape Sequence　｜　Esc+ → ●●●●●
# 3. bindekeyの設定で「bindkey '^[●●●●●' 関数名」にする

# コミット 3行用
function git_commit() {
	BUFFER='git commit -m "#'
	CURSOR=$#BUFFER
	BUFFER=$BUFFER'" -m "" -m ""'
}
zle -N git_commit
bindkey '^[git_commit' git_commit

# タブに名前を付ける
function tab_rename() {
	BUFFER="echo -ne \"\e]1;"
	CURSOR=$#BUFFER
	BUFFER=$BUFFER\\a\"
}
zle -N tab_rename
bindkey '^[tab_rename' tab_rename

# 単語単位で削除（前後）
# 前：option ,
# 後：option .
bindkey '^[word-remove-right' kill-word
bindkey '^[word-remove-left' backward-kill-word

# zsh起動時にtmux起動
[[ -z "$TMUX" && ! -z "$PS1" ]] && exec tmux
