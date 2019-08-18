export LANG=ja_JP.UTF-8

export PATH="/bin:$PATH"

export PATH="~/.rbenv/shims:/usr/local/bin:$PATH"
eval "$(rbenv init -)"

# python
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# playFramewor
PATH=$PATH:~/Library/play-2.2.6

# xampp
export PATH=$PATH:/Applications/XAMPP/xamppfiles/bin

# llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

# setting java path
export JAVA_HOME=/Library/Java/Home

# stack path
export PATH=~/.local/bin:$PATH

# opam configuration
test -r /Users/y-s/.opam/opam-init/init.zsh && . /Users/y-s/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# for hdl
export PATH=$PATH:~/workspace/Row_layer/nand2tetris/tools
