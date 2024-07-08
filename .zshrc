# basic {{{

# homebrew
export PATH="/usr/local/sbin:$PATH"

# }}}

# alias {{{

alias lg='lazygit'

# git
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
alias gsw='git switch'

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
gco_fzf_log() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --cycle --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
    -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

git_reset_--soft_HEAD^() {
  git reset --soft HEAD^
}
# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.zprofile

### forgit {{{1
export FORGIT_NO_ALIASES=1
PATH="$PATH:$FORGIT_INSTALL_DIR/bin"
#}}}1

if [ -e /home/ysawc/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ysawc/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [[ $(command -v starship) ]]; then
  eval "$(starship init zsh)"
else
  if [[ $(command -v cargo) ]]; then
    eval "$(curl -sS https://starship.rs/install.sh | sh)"
  fi
fi
### End of Zinit's installer chunk

if ! [[ $(command -v cargo) ]]; then
  if [[ $(command -v curl) ]]; then
    eval "$(curl https://sh.rustup.rs -sSf | sh)"
  fi
fi

# https://github.com/ajeetdsouza/zoxide
if [[ $(command -v zoxide) ]]; then
  eval "$(zoxide init zsh)"
  alias zi=__zoxide_zi
else
  eval "$(cargo install zoxide --locked && zoxide init zsh)"
fi

if ! [[ $(command -v rg) ]]; then
  eval "$(cargo install ripgrep)"
fi

if ! [[ $(command -v zellij) ]]; then
  eval "$(cargo install zellij)"
elif [[ -z $ZELLIJ ]]; then
  zellij
fi


if ! [[ $(command -v fzf) ]]; then
  # https://github.com/junegunn/fzf#using-git
  if [[ $(command -v git) ]]; then
    eval "$(git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install)"
  fi
fi
### End of Zinit's installer chunk
