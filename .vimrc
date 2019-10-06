"initialize {{{1

" TODO: call initialize from linux of manjaro

" let s:MSWindows = has('win95') + has('win16') + has('win32') + has('win64')
" let $VIM = expand('~/vim/vimdot')

" if s:MSWindows
"     let $VIMRC = expand($VIM . '/vim/vimfiles')
" else
	" let $VIMRC = $HOME . '/.vimrc'
" endif

if has("mac")
elseif has("unix")
	set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
end

" }}}

" basic {{{1

" encoding
set encoding=utf-8
" set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac
" set after setting for 'encoding'
scriptencoding utf-8

" light weight setting {{{2
set lazyredraw
set ttyfast
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

" netrw {{{2
" prewiew setting
let g:netrw_banner=0
let g:netrw_preview=1
" TreeView
let g:netrw_liststyle = 3
" date format
let g:netrw_timefmt='%Y/%m/%d(%a) %H:%M:%S'
" size format
let g:netrw_sizestyle="H"
" }}}

" moving wrap
set whichwrap=h,l,b,s,<,>,[,]

" fast scroll
set lazyredraw
set ttyfast

" cursor setting: always set cursor center
set scrolloff=100

" mouseScroll on
set mouse=a
set ttymouse=xterm2

" foftmethod setting
set foldmethod=marker

set ttimeoutlen=10

" synmaxcol setting
set synmaxcol=256

" setting save session
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal

" wrap
" set wrap
" set textwidth=80

set signcolumn=yes

" https://vim-jp.org/vimdoc-ja/change.html#fo-table
set formatoptions-=cro

set completeopt-=preview

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

" setting line_num
" set relativenumber
" set number

set cursorline

if has('vim_starting')
	let &t_SI .= "\e[5 q"
	let &t_EI .= "\e[2 q"
	let &t_SR .= "\e[1 q"
endif

" set for statusLine
set laststatus=2

" setting list
set list
set listchars+=tab:\¦\ ,eol:\ ,trail:\ 
" }}}

"  search in command_line {{{1

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

" }}}

" color lines {{{1

hi LineNr ctermbg=0 ctermfg=0
hi CursorLineNr ctermbg=4 ctermfg=0
" colorscheme gruvbox
" colorscheme skeletor
colorscheme shades_of_purple


" }}}

" map {{{1

" define usermap {{{2
let g:mapleader = "\<Space>"
" }}}

" editting dotfiles {{{2

let $VIMRC = $HOME . '/.vimrc'
nnoremap <silent> <Space>ev :<C-u>edit $VIMRC<CR>

let $ZSHRC = $HOME . '/.zshrc'
nnoremap <silent> <Space>ez :<C-u>edit $ZSHRC<CR>

" }}}

nnoremap <silent> <Space>en :<C-u>NeoSnippetEdit<CR>

" vpbuffer
nnoremap <silent> <Space>lb :<C-u>LoadBuffer<CR>

inoremap <silent> jj <ESC>

nnoremap ; :

nnoremap <silent> yY :<C-u>%y<CR>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q!<CR>

" TODO: reset
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" TODO: custom
noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
noremap <expr> <C-y> (line('w0') <= 1         ? 'k' : "\<C-y>")
noremap <expr> <C-e> (line('w$') >= line('$') ? 'j' : "\<C-e>")

" moving command line
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>

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
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap <Esc><Esc> :nohlsearch<CR>

nnoremap <Leader>bf :Buffers<CR>

" move in QuickFix
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

autocmd QuickFixCmdPost vimgrep cwindow
autocmd QuickFixCmdPost *grep* cwindow

nnoremap <Space>c :<C-u>Ag --hidden <cword><CR>
nnoremap <Space>r :Rg<Space>

" register map
nnoremap <Space>rcb :<C-u>let @* = expand('%')<CR>

" easymotion keymap
let g:EasyMotion_do_mapping = 0
map <Space>f <plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Space>j <Plug>(easymotion-j)
map <Space>k <Plug>(easymotion-k)
let g:EasyMotion_startofline = 0

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
nnoremap <silent> <Space>or :<C-u>setlocal relativenumber! relativenumber?<CR>
nnoremap <silent> <Space>on :<C-u>setlocal number! number?<CR>
nnoremap <silent> <Space>ow :<C-u>setlocal wrap! wrap?<CR>

" print current buffer path
nnoremap <silent> <Space>pp :<C-u>echo expand('%')<CR>

" }}}

" misc {{{1

" yank with copy
set clipboard+=unnamed

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
	autocmd BufRead,BufNewFile *.make setlocal tabstop=4 shiftwidth=4 softtabstop=4
	autocmd BufRead,BufNewFile *.go setlocal tabstop=2 shiftwidth=2 softtabstop=2
	autocmd BufRead,BufNewFile *.rs setlocal tabstop=4 softtabstop=4 shiftwidth=4
	autocmd BufRead,BufNewFile *.copl setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.rb setlocal tabstop=2 shiftwidth=2 softtabstop=2
	autocmd BufRead,BufNewFile *.c setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.md setlocal tabstop=2 shiftwidth=2 softtabstop=2
	autocmd BufRead,BufNewFile *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.ts setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.tsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.json setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.asm setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.fs setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
" }}}

" SyntaxSettings {{{2
" augroup SyntaxSettings
"     autocmd!
"     " autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
" augroup END
" }}}

" }}}

" for optimization {{{1

" file reading profile
" function! ProfileCursorMove() abort
"   let profile_file = expand('~/log/vim-profile.log')
"   if filereadable(profile_file)
"     call delete(profile_file)
"   endif

"   normal! gg
"   normal! zR

"   execute 'profile start ' . profile_file
"   profile func *
"   profile file *

"   augroup ProfileCursorMove
"     autocmd!
"     autocmd CursorHold <buffer> profile pause | q
"   augroup END

"   for i in range(100)
"     call feedkeys('j')
"   endfor
" endfunction

" syntax report time
" https://stackoverflow.com/questions/19030290/syntax-highlighting-causes-terrible-lag-in-vim
" set syntime=on
" syntime report

" }}}

" basic plugin {{{1
call plug#begin('~/.vim/plugged')

" plug vpbuffer
Plug 'YSawc/vpbuffer'

Plug 'itchyny/lightline.vim'    " Dependency: status line
" Plug 'maximbaz/lightline-ale'

Plug 'bronson/vim-trailing-whitespace'

" fzf for vim {{{2
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

nnoremap <Space><C-p> :FZFFileList<CR>
command! FZFFileList call fzf#run({
			\ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
			\ 'sink': 'e',
			\ 'down': '30%',
			\ })
" TODO: call with row hight and back back in the buffer
nnoremap <Space><C-b> :FZFFileListInBuffer<CR>
command! FZFFileListInBuffer call fzf#run({
			\ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
			\ 'sink': 'e',
			\ 'window': 'enew',
			\ })

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" }}}

" nerdTree {{{2

Plug 'scrooloose/nerdtree'
let g:NERDTreeWinPos = "right"
" jnerdtree sync other tabs
Plug 'jistr/vim-nerdtree-tabs'
let g:extra_whitespace_ignored_filetypes = ['unite', 'vimfiler']
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
filetype on
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'
let g:NerdCommenter_do_mapping = 0

nnoremap s; :<C-u>NERDTreeTabsToggle<CR>

" }}}

" light cursorWord
let g:loaded_matchparen = 1
Plug 'itchyny/vim-parenmatch'

Plug 'Lokaltog/vim-easymotion'

Plug 'Shougo/unite.vim'
" unite_vim {{{2

nnoremap <Space>uf :<C-u>Unite file<CR>

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

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_show_hidden=1

Plug 'lambdalisue/gina.vim'

Plug 'airblade/vim-gitgutter'

" ag for vim
Plug 'rking/ag.vim'

" resize
Plug 'simeji/winresizer'
let g:winresizer_start_key = '<Space><C-T>'
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

" reset
" Plug 'tyru/eskk.vim'

" quickrun
Plug 'thinca/vim-quickrun'

" universal_ctags
Plug 'majutsushi/tagbar'

" sandwitch vital_import
Plug 'machakann/vim-sandwich'

" textObj
Plug 'machakann/vim-swap'

Plug 'mbbill/undotree'

" TODO: select snippets usefull
" Plug 'SirVer/ultisnips'

Plug 'junegunn/vim-emoji'

Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

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

" }}}

" LSP_plugins {{{1

"other {{{2

" }}}

" vim-lsp {{{2

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
Plug 'Shougo/neco-syntax'
imap <c-space> <Plug>(asyncomplete_force_refresh)

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

let g:lsp_diagnostics_enabled = v:false
" Plug 'natebosch/vim-lsc'
let g:lsp_async_completion = 1
" let g:lsc_auto_map = v:true

" let g:lsp_diagnostics_enabled = 0
" " debug
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')

let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_signs_error = {'text': 'E'}
let g:lsp_signs_warning = {'text': 'w'}

" Plug 'ryanolsonx/vim-lsp-javascript'
" if executable('typescript-language-server')
"     au User lsp_setup call lsp#register_server({
"       \ 'name': 'javascript support using typescript-language-server',
"       \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
"       \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
"       \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact']
"       \ })
" endif

Plug 'ryanolsonx/vim-lsp-typescript'
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx'],
        \ })
endif

" if executable('rls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'rls',
"         \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
"         \ 'whitelist': ['rust'],
"         \ })
" endif

" if executable('gopls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'gopls',
"         \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
"         \ 'whitelist': ['go'],
"         \ })
"     autocmd BufWritePre *.go LspDocumentFormatSync
" endif

if executable('ocaml-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'ocaml-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'ocaml-language-server --stdio']},
        \ 'whitelist': ['reason', 'ocaml'],
        \ })
endif

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

" auto linter in save
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet']

" setting how to split
let g:go_term_mode = 'split'

" error list
let g:go_list_type = "quickfix"

let g:go_doc_popup_window = 1

" }}}

" rust {{{2
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'
" let g:syntastic_rust_checkers = ['cargo']

Plug 'racer-rust/vim-racer'
set hidden
let g:racer_cmd = '~/.cargo/bin/racer'
let g:racer_experimental_completer = 1

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" }}}

" copl {{{2
Plug 'ymyzk/vim-copl'
" }}}

" js{{{2

Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'

Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
" jsx change to tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" }}}

" fsharp {{{2
" Plug 'fsharp/vim-fsharp', {
"       \ 'for': 'fsharp',
"       \ 'do':  'make fsautocomplete',
"       \}

" Plug 'ionide/Ionide-vim', {
"       \ 'do':  'make fsautocomplete',
"       \}
" }}}

" ocaml {{{2

" merlin
let g:syntastic_ocaml_checkers = ['merlin']
if executable('ocamlmerlin') && has('python')
  let s:ocamlmerlin = substitute(system('opam config var share'), '\n$', '', '''') . "/merlin"
  execute "set rtp+=".s:ocamlmerlin."/vim"
  execute "set rtp+=".s:ocamlmerlin."/vimbufsync"
endif

" opam
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" syntax
Plug 'scrooloose/syntastic'

" OCP-INDENT
function! s:ocaml_format()
	let now_line = line('.')
	exec ':%! ocp-indent'
	exec ':' . now_line
endfunction

augroup ocaml_format
	autocmd!
	autocmd BufWrite,FileWritePre,FileAppendPre *.mli\= call s:ocaml_format()
augroup END

" }}}

call plug#end()
" }}}

" alias in commandline {{{1
command Gps Git push
" }}}

" vim: foldmethod=marker
