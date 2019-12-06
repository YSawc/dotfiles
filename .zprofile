ZSH_ARRAY=(
            Ignore/.zshrc.slack
		)
for zsh in "${ZSH_ARRAY[@]}"
do
	source ~/dotfiles/zsh/"$zsh"
done

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

# cpp
# export CPATH="/usr/local/Cellar/opencv/4.1.2/include/opencv4"
export CPATH="/usr/local/include/opencv4"

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
# x11
export PKG_CONFIG_PATH="/opt/X11/lib/pkgconfig"
# expat
export PKG_CONFIG_PATH="/usr/local/opt/expat/lib/pkgconfig"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# for hdl
export PATH=$PATH:~/workspace/Row_layer/nand2tetris/tools

# nodenv
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export NODELDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export NODECPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# fsharp
export MONO_GAC_PREFIX="/usr/local"

# golang
export PATH="$HOME/go/bin/:$PATH"

# react
# prettier
export PATH=$PATH:./node_modules/.bin

# another {{{1

# vim with LANG_C
alias vim='LANG=C vim'
alias vi='LANG=C vim'

# cpp {{{2
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

alias clang-omp++='/usr/local/opt/llvm/bin/clang++ -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'

# }}}

# haskell
eval "$(stack --bash-completion-script stack)"

## ocaml
# opam rlwrap ocaml
alias ocaml="rlwrap ocaml"
# opam configuration
test -r /Users/y-s/.opam/opam-init/init.zsh && . /Users/y-s/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# }}}

