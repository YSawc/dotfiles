"initialize {{{1

" finish when user have sudo
if exists('$SUDO_USER')
  finish
endif

if has("unix")
	set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
endif

" disable builtins
let g:loaded_gzip=1
let g:loaded_tar=1
let g:loaded_tarPlugin=1
let g:loaded_zip=1
let g:loaded_zipPlugin=1
let g:loaded_rrhelper=1
let g:loaded_2html_plugin=1
let g:loaded_vimball=1
let g:loaded_vimballPlugin=1
let g:loaded_getscript=1
let g:loaded_getscriptPlugin=1
let g:loaded_netrw=1
let g:loaded_netrwPlugin=1
let g:loaded_netrwSettings=1
let g:loaded_netrwFileHandlers=1

" }}}

" basic {{{1

" encoding
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
scriptencoding utf-8

" light weight setting {{{2
if 1
	set lazyredraw
	set ttyfast
endif
" }}}

set noswapfile

" auto reload when branch changed
set autoread

" mute seting
set t_vb=
set visualbell
set noerrorbells

" delete using backspace & ctrl+h
set backspace=2

" completion in comandLine
set wildmenu
set wildmode=full

" enable modeline
set modeline
set modelines=3

" hilight in visual mode
hi Visual cterm=reverse ctermbg=NONE

" selector of short form
set virtualedit+=block

" moving wrap
set whichwrap=h,l,b,s,<,>,[,]

" cursor setting: always set cursor center
set scrolloff=100

" foftmethod setting
set foldmethod=marker

set ttimeoutlen=10

" synmaxcol setting
set synmaxcol=256

" setting save session
if has('mac')
	set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal
endif

set display=lastline

set pumheight=10

set signcolumn=yes

" https://vim-jp.org/vimdoc-ja/change.html#fo-table
set formatoptions-=cro

set completeopt=menuone,noinsert,noselect

" setting for undo
if has('persistent_undo')
	set undodir=~/.cache/vim/undo
	augroup vimrc-undofile
		autocmd!
		autocmd BufReadPre ~/* setlocal undofile
	augroup END
endif

" delete whitespace preBufWeite
" autocmd BufWritePre * :silent keeppatterns %s/\s\+$//ge

" limit of highlight
augroup vimrc-highlight
  autocmd!
  autocmd Syntax * if 10000 < line('$') | syntax sync minlines=100 | endif
augroup END

" Search the word nearest to the cursor in new window.
nnoremap <C-w>*  <C-w>s*

" disable auto resize window
set noequalalways

" }}}

" cursorline {{{1

" refactor of cursorLine {{{2
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  " TODO: toggle over nerdTree_open
  " TIP:
  " g:NERDTree.IsOpen()

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END
" }}}

" }}}

" grep {{{1

" fzfSearch
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)
" }}}

" apperance {{{1

" setting list
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

set cursorline

" set for statusLine
set laststatus=2

" }}}

" search in command_line {{{1

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

" }}}

" color lines {{{1

" colorscheme gruvbox
" colorscheme molokai
set termguicolors

let g:rigel_lightline = 1

" highlight Normal guibg=black guifg=white
" set background=dark


" }}}

" map {{{1

nnoremap x "_x

" define usermap {{{2
let g:mapleader = "\<Space>"
" }}}

" editting dotfiles {{{2

let $VIMRC = $HOME . '/.vimrc'
nnoremap <silent> <Leader>ev :<C-u>edit $VIMRC<CR>

let $ZSHRC = $HOME . '/.zshrc'
nnoremap <silent> <Leader>ez :<C-u>edit $ZSHRC<CR>

" }}}

nnoremap <silent> <Leader>en :<C-u>NeoSnippetEdit<CR>

" vpbuffer
nnoremap <silent> <Leader>lb :<C-u>LoadBuffer<CR>

inoremap <silent> jj <ESC>

map <C-a> <ESC>^
imap <C-a> <ESC>I
map <C-e> <ESC>$
imap <C-e> <ESC>A

nnoremap ; :

nnoremap o O<ESC>
nnoremap O o
vnoremap d $d

nnoremap Y y$
nnoremap <silent> yY :<C-u>%y<CR>

nnoremap <silent> dD :<C-u>%d<CR>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q!<CR>

" TODO: reset
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>

noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')

" moving command line
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up>   <C-p>
cnoremap <Down> <C-n>

" tmux {{{2
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap <Tab> <C-w>w
nnoremap <S-Tab> <C-w>W
nnoremap s0 <C-w>t
nnoremap sT <C-w>T
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap th :-tabm<CR>
nnoremap tl :+tabm<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
" }}}

" move line
nnoremap <C-Up> "zdd<Up>"zP
nnoremap <C-Down> "zdd"zp
vnoremap <C-Up> "zx<Up>"zP`[V`]
vnoremap <C-Down> "zx"zp`[V`]

" move in insert
inoremap <C-f> <Right>
inoremap <C-b> <Left>

" toggle hilight
nnoremap <silent> <Leader><Leader> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap <Esc><Esc> :nohlsearch<CR>

nnoremap <Leader>bf :Buffers<CR>

" move in QuickFix
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

autocmd QuickFixCmdPost vimgrep cwindow
autocmd QuickFixCmdPost *grep* cwindow

nnoremap <Leader>c :<C-u>Ag --hidden <cword><CR>

" ripgrep map
nnoremap <Leader>r :Rg<Leader>
nnoremap <Leader>rc :exec 'Rg' expand('<cword>')
nnoremap <Leader>g :Rg<Leader>
nnoremap <Leader>gc :exec 'Rg' expand('<cword>')

" register map
function! s:_registerCurrentFileDir()
	if has('mac')
		let @* = expand('%')
		echo '[' @* '] <- copied fileDir'
	elseif has('unix')
		" TODO: support this
		echo expand('%')
	endif
endfunction
nnoremap <Leader>rcb :<C-u>call <SID>_registerCurrentFileDir()<CR>

" vim slash(/) with match_num {{{2
nnoremap <expr> / _(":%s/<Cursor>/&/gn")

function! s:move_cursor_pos_mapping(str, ...)
    let left = get(a:, 1, "<Left>")
    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
    return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
    return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction
" }}}

nnoremap <C-j> }
nnoremap <C-k> {

" universal_tags
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" window mode with number
let i = 1
while i <= 9
    execute 'nnoremap <Space>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile

" help closeer
augroup helpMapping
	au!
	au FileType help nnoremap <buffer> <silent> q :q<CR>
augroup END

" Quick toggle options.
nnoremap <silent> <Leader>or :<C-u>setlocal relativenumber! relativenumber?<CR>
nnoremap <silent> <Leader>on :<C-u>setlocal number! number?<CR>
nnoremap <silent> <Leader>ow :<C-u>setlocal wrap! wrap?<CR>

" print current buffer path
nnoremap <silent> <Leader>pp :<C-u>echo expand('%')<CR>

" Insert the line to the next line.
nnoremap <Leader>pl :<C-u>call append(expand('.'), '')<CR>

nnoremap + <C-a>
nnoremap - <C-x>

" }}}

" misc {{{1

" yank with copy
" need +clickboard
if has('unix')
	" set clipboard+=unnamedplus
elseif has('mac')
	set clipboard+=unnamed
endif
" }}}

" each_lang {{{1

set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" fileTypeIndent{{{2
augroup fileTypeIndent
	autocmd!
	autocmd BufRead,BufNewFile *.go setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.rs setlocal tabstop=4 softtabstop=4 shiftwidth=4
	autocmd BufRead,BufNewFile *.hs setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd BufRead,BufNewFile *.cabal setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd BufRead,BufNewFile *.copl setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.java setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.s setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.c setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.h setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.asm setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd BufRead,BufNewFile *.md setlocal tabstop=2 softtabstop=2 shiftwidth=2  expandtab
	autocmd BufRead,BufNewFile *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.ts setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.tsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.asm setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.fs setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.ml setlocal tabstop=4 softtabstop=4 shiftwidth=4
	autocmd BufRead,BufNewFile *.hs setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd BufRead,BufNewFile *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.s setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile *.hdl setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd BufRead,BufNewFile Makefile setlocal tabstop=8 softtabstop=8 shiftwidth=8
	autocmd BufRead,BufNewFile *.make setlocal tabstop=4 softtabstop=4 shiftwidth=4
	autocmd BufRead,BufNewFile *.dockerfile setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufRead,BufNewFile Dockerfile setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END
" }}}

" SyntaxSettings {{{2
if 0
	augroup SyntaxSettings
	    autocmd!
	    " autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
	augroup END
endif
" }}}

" }}}

" for optimization {{{1

if 0
	echo 'test'
	file reading profile
	function! ProfileCursorMove() abort
	  let profile_file = expand('~/log/vim-profile.log')
	  if filereadable(profile_file)
	    call delete(profile_file)
	  endif

	  normal! gg
	  normal! zR

	  execute 'profile start ' . profile_file
	  profile func *
	  profile file *

	  augroup ProfileCursorMove
	    autocmd!
	    autocmd CursorHold <buffer> profile pause | q
	  augroup END

	  for i in range(100)
	    call feedkeys('j')
	  endfor
	endfunction

	syntax report time
	" https://stackoverflow.com/questions/19030290/syntax-highlighting-causes-terrible-lag-in-vim
	set syntime=on
	syntime report
endif

" }}}

" basic plugin {{{1
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'    " Dependency: status line
" dependencied: ale
let g:lightline = {
	\ 'colorscheme': 'rigel',
	\ 'active': {
	\   'left': [
	\     ['mode', 'paste'],
	\     ['readonly', 'filename', 'modified', 'ale'],
	\   ],
	\ },
	\ 'component_function': {
	\   'ale': 'ALEGetStatusLine'
	\ }
\ }

Plug 'bronson/vim-trailing-whitespace'
let g:extra_whitespace_ignored_filetypes = ['vimshell']

" fzf for vim {{{2
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

nnoremap <Leader><C-p> :FZFFileList<CR>
command! FZFFileList call fzf#run({
			\ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
			\ 'sink': 'e',
			\ 'down': '30%',
			\ })
" TODO: call with row hight and back back in the buffer
nnoremap <Leader><C-b> :FZFFileListInBuffer<CR>
command! FZFFileListInBuffer call fzf#run({
			\ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
			\ 'sink': 'e',
			\ 'window': 'enew',
			\ })

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" }}}

" nerdTree {{{2
if 0
Plug 'scrooloose/nerdtree'
let g:NERDTreeWinPos = "right"
" nerdtree sync other tabs
Plug 'jistr/vim-nerdtree-tabs'
if 0
	nnoremap <space>; :<C-u>NERDTreeToggle<CR>
else
	nnoremap <space>; :<C-u>NERDTreeTabsToggle<CR>
endif
nnoremap <space>n :<C-u>let NERDTreeIgnore = ['\.']<LEFT><LEFT>
endif
let g:extra_whitespace_ignored_filetypes = ['unite']
Plug 'Xuyuanp/nerdtree-git-plugin'
" }}}

" easy togle of comment
Plug 'scrooloose/nerdcommenter'
let g:NerdCommenter_do_mapping = 0
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

" light cursorWord
let g:loaded_matchparen = 1
Plug 'itchyny/vim-parenmatch'

Plug 'Lokaltog/vim-easymotion'
let g:EasyMotion_do_mapping = 0
map <Leader>f <plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0
let g:EasyMotion_skipfoldedline = 0
let g:EasyMotion_cmigemo = 1

Plug 'Shougo/unite.vim'
" unite_vim {{{2

nnoremap <Leader>uf :<C-u>Unite file<CR>

let g:unite_enable_start_insert = 1

if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
	let g:unite_source_grep_recursive_opt = ''
endif

let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" }}}

Plug 'Shougo/neomru.vim'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Shougo/vimshell.vim'
nnoremap <silent> <Leader>v :VimShell
nnoremap <silent> <Leader>vp :VimShellPop

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = ''
let g:ctrlp_show_hidden=1
Plug 'LeafCage/yankround.vim' " dependency: 'ctrlpvim/ctrlp.vim'
nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
let g:yankround_max_history = 4
nnoremap <silent> <Leader>y<C-p> :<C-u>CtrlPYankRound<CR>

" Plug 'lambdalisue/gina.vim'

Plug 'airblade/vim-gitgutter'

" ag for vim
Plug 'rking/ag.vim'

" resize
Plug 'simeji/winresizer'
let g:winresizer_start_key = '<Leader><C-T>'
let g:winresizer_vert_resize = 5

" markdown
Plug 'tpope/vim-markdown'
Plug 'previm/previm'
" let g:previm_open_cmd =  'open -a Chrome'
au BufRead,BufNewFile *.md set filetype=markdown
Plug 'tyru/open-browser.vim'

" translate.vim
Plug 'skanehira/translate.vim'

" OrgMode
Plug 'jceb/vim-orgmode'

" auto brackets
Plug 'cohama/lexima.vim'

" textObj
Plug 'tpope/vim-surround'

" easy Session
Plug 'skanehira/vsession'
let g:vsession_use_fzf = 1

" Plug 'tyru/eskk.vim'

" quickrun
Plug 'thinca/vim-quickrun'


" universal_ctags
set tags+=.ctags
Plug 'majutsushi/tagbar'
Plug 'szw/vim-tags'
let g:vim_tags_ctags_binary = '.ctags'
nnoremap <C-]> g<C-]>
let g:tagbar_map_togglesort = "r" " conflict default map of 's' with my tmux toggle Key.

" sandwitch vital_import
Plug 'machakann/vim-sandwich'

" textObj
Plug 'machakann/vim-swap'

Plug 'mbbill/undotree'
nmap <Leader>u :UndotreeToggle<CR>

Plug 'junegunn/vim-emoji'

Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

Plug 'tpope/vim-fugitive'
nnoremap <Leader>vfb :Gblame<CR>

Plug 'rhysd/git-messenger.vim'
nmap <Leader>pg <Plug>(git-messenger)

Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-y>'
autocmd FileType html,css EmmetInstall

" incsearch {{{2

Plug 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
function! s:noregexp(pattern) abort
  return '\V' . escape(a:pattern, '\')
endfunction

function! s:config() abort
  return {'converters': [function('s:noregexp')]}
endfunction

noremap <silent><expr> z/ incsearch#go(<SID>config())

" migemo
Plug 'haya14busa/incsearch-migemo.vim'
map m/ <Plug>(incsearch-migemo-/)
map m? <Plug>(incsearch-migemo-?)
map mg/ <Plug>(incsearch-migemo-stay)

" }}}

Plug 'haya14busa/vim-edgemotion'
map [d <Plug>(edgemotion-k)
map ]d <Plug>(edgemotion-j)

Plug 'rhysd/clever-f.vim'
let g:clever_f_across_no_line = 1
let g:clever_f_timeout_ms = 2000
let g:clever_f_use_migemo = 1

Plug 'kana/vim-smartword'
nmap w <Plug>(smartword-w)
nmap b <Plug>(smartword-b)
nmap e <Plug>(smartword-e)

" yank and paste via system register
Plug 'christoomey/vim-system-copy'

" Indexing search word with match number
Plug 'google/vim-searchindex'

Plug 'terryma/vim-multiple-cursors'

Plug 'rafi/awesome-vim-colorschemes'
Plug 'itchyny/landscape.vim'
Plug 'Rigellute/rigel'

Plug 'itchyny/thumbnail.vim'

Plug 'matze/vim-move'
let g:move_key_modifier = 'C'

Plug 't9md/vim-quickhl'
xmap <Leader>mm <Plug>(quickhl-manual-this)
nmap <Leader>mm <Plug>(quickhl-manual-this)
nmap <Leader>mq <Plug>(quickhl-manual-reset)
xmap <Leader>mq <Plug>(quickhl-manual-reset)

Plug 'terryma/vim-expand-region'
map <Leader>re <Plug>(expand_region_expand)
map <Leader>rs <Plug>(expand_region_shrink)

Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

nnoremap <Leader>gb :Buffers<CR>
nnoremap <Leader>gf :Files<CR>

Plug 'brooth/far.vim'

Plug 'vim-utils/vim-man'

Plug 'lambdalisue/fern.vim'
nnoremap <Leader>; :Fern .<CR>

" Plug 'vim-scripts/a.vim'

" neosnippet {{{2
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

snoremap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#snippets_directory='~/dotfiles/neosnippet-snippets/snippets/'

" }}}

" ale {{{2
Plug 'dense-analysis/ale'
nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
" error display qucickfix
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_linters = {
	\'cpp': [''],
	\'asm': [''],
	\}

" }}}

" prettier {{{
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
" }}}

" syntax {{{2
if 0
	Plug 'scrooloose/syntastic'
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0
	nnoremap <C-C> :w<CR>:SyntasticCheck<CR>
	let g:syntastic_mode_map = {
	    \ 'mode': 'passive',
	    \ 'active_filetypes': ['']
	    \}

	let g:syntastic_javascript_checkers = ['lynt']
endif

" }}}

" }}}

" LSP_plugins {{{1

"other {{{2

" }}}

" vim-lsp {{{2

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
Plug 'Shougo/neco-syntax'

" Plug 'SirVer/ultisnips'
" let g:lsp_ultisnips_integration = 1

Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'

imap <c-space> <Plug>(asyncomplete_force_refresh)
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:lsp_text_edit_enabled = 1
let g:asyncomplete_popup_delay = 200
nnoremap <Leader>lf :LspDocumentFormatSync<CR>
nnoremap <Leader>lh :LspHover<CR>

" asyn__omni {{{3
Plug 'yami-beta/asyncomplete-omni.vim'
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
    \ 'name': 'omni',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#omni#completor'),
    \ }))
" }}}

" asyn__neosnippet{{{3
Plug 'prabirshrestha/asyncomplete-neosnippet.vim'
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
    \ 'name': 'neosnippet',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
    \ }))
" }}}

" aryn_neosyntax {{{3
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
    \ 'name': 'necosyntax',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
    \ }))
" }}}

" asyn_buffer {{{3
Plug 'prabirshrestha/asyncomplete-buffer.vim'
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))
" }}}

" asyn_file {{{3
Plug 'prabirshrestha/asyncomplete-file.vim'
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))
" }}}

" asyn__vim {{{3
Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
    \ 'name': 'necosyntax',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
    \ }))
" }}}

" vim-lsp map {{{3
nmap <silent> <Leader>ld :LspDefinition<CR>
nmap <silent> <Leader>lh :LspHover<CR>
nmap <silent> <Leader>lr :LspReferences<CR>
nmap <silent> <Leader>li :LspImplementation<CR>
nmap <silent> <Leader>ls :split \| :LspDefinition <CR>
nmap <silent> <Leader>lv :vsplit \| :LspDefinition <CR>
" }}}
"
" }}}

" vim-go {{{2

Plug 'fatih/vim-go'

augroup vimGo
	autocmd!
	au FileType go nnoremap <silent> <Leader>gc :GoDoc<CR>
augroup END

" auto format
let g:go_fmt_command = "goimports"

" error list
let g:go_list_type = "quickfix"

" let g:go_doc_popup_window = 1


" }}}

" rust {{{2
if 1
	Plug 'rust-lang/rust.vim'
	Plug 'racer-rust/vim-racer'
	let g:rustfmt_autosave = 1
	let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'
	set hidden
	let g:racer_cmd = '~/.cargo/bin/racer'
	let g:racer_experimental_completer = 1
	au FileType rust nmap gd <Plug>(rust-def)
	" au FileType rust nmap gs <Plug>(rust-def-split)
	au FileType rust nmap gx <Plug>(rust-def-vertical)
	au FileType rust nmap <leader>gd <Plug>(rust-doc)
endif

" }}}

" copl {{{2
Plug 'ymyzk/vim-copl'
" }}}

" fsharp {{{2
if 0
	Plug 'fsharp/vim-fsharp', {
		  \ 'for': 'fsharp',
		  \ 'do':  'make fsautocomplete',
		  \}
	Plug 'ionide/Ionide-vim', {
		  \ 'do':  'make fsautocomplete',
		  \}
endif
" }}}

" ocaml {{{2

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" }}}

" haskell{{{2
" augroup MyLsp
"   autocmd FileType haskell setlocal omnifunc=lsp#complete

  " if executable('hie')
  "     au User lsp_setup call lsp#register_server({
  "       \ 'name': 'hie',
  "       \ 'cmd': {server_info->['hie']},
  "       \ 'whitelist': ['haskell'],
  "       \ })
  " endif

  " au FileType haskell nmap <leader>R <plug>(lsp-rename)
  " au FileType haskell nmap <leader>D <plug>(lsp-definition)
  " au FileType haskell nmap <leader>r <plug>(lsp-references)
  " au FileType haskell nmap <leader>d <plug>(lsp-document-symbol)
  " au FileType haskell nmap <leader>w <plug>(lsp-workspace-symbol)
" augroup end
" }}}

call plug#end()
" }}}

" alias in commandline {{{1
command Gps Git push
" }}}

" vim: foldmethod=marker

 colorscheme rigel
