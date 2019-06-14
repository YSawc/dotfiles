# rbenvパス

# 日本語設定
export LANG=ja_JP.UTF-8

export PATH="~/.rbenv/shims:/usr/local/bin:$PATH"
eval "$(rbenv init -)"

# Setting PATH for Python 3.7
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

PATH=$PATH:~/Library/play-2.2.6

#XAMPPのパス
export PATH=$PATH:/Applications/XAMPP/xamppfiles/bin

# NeoVim起動用
#export XDG_CONFIG_HOME="$HOME/.config"

# export GOPATH=$HOME/go

# llvm ( LSP c, cpp )
export PATH="/usr/local/opt/llvm/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

source ~/.zshrc
