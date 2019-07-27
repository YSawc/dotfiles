" initialize {{{

let s:MSWindows = has('win95') + has('win16') + has('win32') + has('win64')

if s:MSWindows
	let $VIMRC = expand($VIM . '/vimfiles')
else
	let $VIMRC = expand('~/.vimrc')
endif

" }}}

" editting dotfiles {{{

let $VIMRC = $HOME . '/.vimrc'
nnoremap <silent> <Space>ev :<C-u>edit $VIMRC<CR>

" }}}

" basic plugin {{{
call plug#begin('~/.vim/plugged')

" plug vpbuffer
Plug 'YSawc/vpbuffer'

" Plug 'w0rp/ale'                 " Dependency: linter
Plug 'itchyny/lightline.vim'    " Dependency: status line
Plug 'maximbaz/lightline-ale'

" 行末の半角スペースを可視化
Plug 'bronson/vim-trailing-whitespace'

" fzf for vim {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" " fzfでファイルを検索する
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

" nerdTree {{{

Plug 'scrooloose/nerdtree'
" nerdtreeを別タブで同期させる
Plug 'jistr/vim-nerdtree-tabs'
" file icons
" Plug 'ryanoasis/vim-devicons'
" nerdtree highlight
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" デフォルトでツリーを表示させる
" let g:nerdtree_tabs_open_on_console_startup=1
" ホワイトリストを作成する
" start up NERDTree
" autocmd vimenter * NERDTree
let g:extra_whitespace_ignored_filetypes = ['unite', 'vimfiler']
" 変更箇所をNERDTreeで同期できる
Plug 'Xuyuanp/nerdtree-git-plugin'
" コメントアウトを気軽に実行
Plug 'scrooloose/nerdcommenter'
filetype on
let g:NERDSpaceDelims=1 " コメントアウトの後にスペース挿入
let g:NERDDefaultAlign='left' " コメントアウトを左に揃える
let g:NerdCommenter_do_mapping = 0
" let g:NERDCreateDefaultMappings = 0
nnoremap <Space>// <Plug>NERDcommenterToggle

" nerdTree END }}}

" cursorWord
let g:loaded_matchparen = 1
Plug 'itchyny/vim-parenmatch'
" Plug 'itchyny/vim-cursorword' " TODO: トグル化

" カーソル移動をより快適にする
Plug 'Lokaltog/vim-easymotion'

" ファイルオープンを便利に
Plug 'Shougo/unite.vim'
" let g:better_whitespace_filetypes_blacklist = ['unite']

" Unite.vimで最近使ったファイルを表示できるようにする
Plug 'Shougo/neomru.vim'

" filerをvimfilerにデフォルト設定する
Plug 'Shougo/vimfiler.vim'
let g:vimfiler_enable_auto_cd = 1
" VimFilerをwhite_spaceの対象から外す
" let g:extra_whitespace_ignored_filetypes = ['vimfiler']

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_show_hidden=1

" コメントON/OFFを手軽に実行
" Plug 'tomtom/tcomment_vim'


" Ruby向けにendを自動挿入してくれる
Plug 'tpope/vim-endwise'

" 下のラインにステータスバーを表示する
" Plug 'vim-airline/vim-airline'

" 曖昧に検索できるツールプラグイン
Plug 'junegunn/fzf'

" nerdtree専用のファイルカラーテーマ
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" gitのコマンドをvimで操作できるプラグイン
Plug 'tpope/vim-fugitive'

" gitの更新状況を表示するプラグイン
Plug 'airblade/vim-gitgutter'

" Colorscheme
Plug 'jacoborus/tender.vim'

" agのvim用
Plug 'rking/ag.vim'

" vimを開いてる時にtagsを追加する TODO: 使わなそうなら削除 190707
" Plug 'szw/vim-tags'
" vim-tags追加コマンド: :TagsGenerate 編集中に定義の更新ができる
" au BufNewFile,BufRead *.php let g:vim_tags_project_tags_command = "ctags --languages=php -f ~/php.tags `pwd` 2>/dev/null &"

" 目印行を常に表示する
if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" winersizer.vim ウィンドウサイズを簡単に変更できる
Plug 'simeji/winresizer'
let g:winresizer_start_key = '<Space><C-T>'
let g:winresizer_vert_resize = 5

" markdownプラグイン
Plug 'tpope/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'

" vimrc.LSP_plugins_settingの読み込みに続く為、plug#endはコメントアウトしておく
" call plug#end()

" translate.vim
Plug 'skanehira/translate.vim'

" lintの現在行の物をpopup表示するプラグイン
" Plug 'tyru/qfpopup.vim'

" カーソルの構造体をポップアップ表示する
" Plug 'rbtnn/vim-popup_signature'

" OrgMode
Plug 'jceb/vim-orgmode'

" 対応する括弧を自動補完するプラグイン
Plug 'cohama/lexima.vim'

" テキストオブジェクト編集拡張プラグイン
Plug 'tpope/vim-surround'

" session切り替え方法を追加するプラグイン
Plug 'skanehira/vsession'

" mattn_webapi
Plug 'mattn/webapi-vim'
" gist_vim
Plug 'mattn/gist-vim'

" sskk
Plug 'tyru/eskk.vim'

" quickrun
Plug 'thinca/vim-quickrun'

" universal_ctags
Plug 'majutsushi/tagbar'
set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis
" }}}

" LSP_plugins {{{

"other {{{

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

" other END }}}

" coc END {{{

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
" Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nnoremap <silent> [c <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nnoremap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nnoremap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nnoremap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nnoremap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nnoremap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }



" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"coc END }}}

" vista {{{

" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'liuchengxu/vista.vim'

" vista END }}}

" vim-go {{{

" vim-go
" Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'fatih/vim-go'

" スニペット
Plug 'SirVer/ultisnips'

" vim-go settings
" ファイル保存時go importを実行する
let g:go_fmt_command = "goimports"

" ファイル保存時、linterを実行する
let g:go_metalinter_autosave = 1

" linter実行時、go vetのみを実行する
let g:go_metalinter_autosave_enabled = ['vet']


" GoRunやGoTest時の画面分割方法変更
let g:go_term_mode = 'split'

" vim-go END }}}

" ale {{{

" Plug 'w0rp/ale'
" let g:ale_sign_column_always = 1
" " シンボルの変更
" let g:ale_sign_error = '!!'
" let g:ale_sign_warning = '=='

" " highlight clear ALEErrorSign
" " highlight clear ALEWarningSignk
" " let g:ale_sign_error = "◉"
" " g:ale_sign_warning = "◉"
" " highlight ALEErrorSign ctermfg=9 ctermbg=15 guifg=#C30500 guibg=#000000
" " highlight ALEWarningSign ctermfg=11 ctermbg=15 guifg=#ED6237 guibg=#000000

" " 保存時にだけチェック
" let g:ale_lint_on_save = 1
" let g:ale_lint_on_text_changed = 0

" " ファイルオープン時にチェックしたくない場合
" let g:ale_lint_on_enter = 1
" " quickfixで開く
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1
" let g:ale_open_list = 1
" " エラーと警告がなくなっても開いたままにする
" let g:ale_keep_list_window_open = 1

" ale END }}}

" prabirshrestha {{{

" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/asyncomplete-neosnippet.vim'

" 非同期補完設定
" let g:lsp_async_completion = 1

" エラー時、ファイルに出力
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')

" エラー出力をオフにする
" let g:lsp_diagnostics_enabled = 0  " 警告やエラーの表示をALEに任せるなら0
" エラー時の行出力
" let g:lsp_signs_error = {'text': '✗'}
" let g:lsp_signs_warning = {'text': '‼'}
" エラー時出力　TODO: いらなければ削除
" let g:lsp_signs_warning = {'text': '‼', 'icon': '/path/to/some/icon'} " icons require GUI
" let g:lsp_signs_hint = {'icon': '/path/to/some/other/icon'} " icons require GUI
" 出力するサインの設定
" let g:lsp_signs_enabled = 1         " enable signs
" let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
" let g:asyncomplete_completion_delay=10

" Tab completion
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" Force refresh completion
" imap <c-space> <Plug>(asyncomplete_force_refresh)

" for asyncomplete.vim log
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')
"

" GO
" augroup LspGo
" if executable('golsp')
"   augroup LspGo
"     au!
"     autocmd User lsp_setup call lsp#register_server({
"         \ 'name': 'go-lang',
"         \ 'cmd': {server_info->['golsp', '-mode', 'stdio']},
"         \ 'whitelist': ['go'],
"         \ })
"     autocmd FileType go setlocal omnifunc=lsp#complete
"   augroup END
" endif
" augroup END
" Go END

" GO

" if executable('gopls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'gopls',
"         \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
"         \ 'whitelist': ['go'],
"         \ })
"     autocmd BufWritePre *.go LspDocumentFormatSync
" endif

" if executable('go-langserver')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'go-langserver',
"         \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
"         \ 'whitelist': ['go'],
"         \ })
"     autocmd BufWritePre *.go LspDocumentFormatSync
" endif

" augroup LspGo
" if executable('bingo')
"   augroup LspGo
"     au!
"     autocmd User lsp_setup call lsp#register_server({
"         \ 'name': 'go-lang',
"         \ 'cmd': {server_info->['bingo', '-mode', 'stdio']},
"         \ 'whitelist': ['go'],
"         \ })
"     autocmd FileType go setlocal omnifunc=lsp#complete
"   augroup END
" endif
" augroup END
" Go END

" c cpp
" if executable('clangd')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'clangd',
"         \ 'cmd': {server_info->['clangd', '-background-index']},
"         \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
"         \ })
" endif
" c cpp END


" ruby
" if executable('solargraph')
"     " gem install solargraph
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'solargraph',
"         \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
"         \ 'initialization_options': {"diagnostics": "true"},
"         \ 'whitelist': ['ruby'],
"         \ })
" endif
" ruby END

" python
" if executable('pyls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pyls',
"         \ 'cmd': {server_info->['pyls']},
"         \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Pipfile'))},
"         \ 'whitelist': ['python'],
"         \ })
" endif

" bash-lang
" if executable('bash-language-server')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'bash-language-server',
"         \ 'cmd': {server_info->['bash-language-server', 'start']},
"         \ 'whitelist': ['sh'],
"         \ })
" endif

" " rust
" if executable('rls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'rls',
"         \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
"         \ 'whitelist': ['rust'],
"         \ })
" endif

" LSP用にマッピング
"   nnoremap <buffer> <C-]> :<C-u>LspDefinition<CR>
"   nnoremap <buffer> gd :<C-u>LspDefinition<CR>
"   nnoremap <buffer> gD :<C-u>LspReferences<CR>
"   nnoremap <buffer> gs :<C-u>LspDocumentSymbol<CR>
"   nnoremap <buffer> gS :<C-u>LspWorkspaceSymbol<CR>
"   nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
"   vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
"   nnoremap <buffer> K :<C-u>LspHover<CR>
"   nnoremap <buffer> <F1> :<C-u>LspImplementation<CR>
" "   nnoremap <buffer> <F2> :<C-u>LspRename<CR>
" endfunction

" autocmd FileType typescript setlocal omnifunc=lsp#complete

" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" prabirshrestha END }}}

" deoplete {{{

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#auto_completion_start_length = 1

" deoplete END }}}

" neosnippet {{{
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
snoremap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#snippets_directory='~/dotfiles/neosnippet-snippets/snippets/'

" neosnippet }}}

call plug#end()
" }}}

" basic {{{

" light weight setting {{{
set lazyredraw
set ttyfast
" }}}

" スワップファイルを作成しない
set noswapfile

" 文字コード指定
set encoding=UTF-8

" mute seting {{{
set t_vb=
set visualbell
set noerrorbells
" }}}

" delete using backspace & ctrl+h {{{
set backspace=2
" }}}

" コマンドライン補完設定 {{{
set wildmenu
set wildmode=longest:full,full
" コマンドライン補完設定 }}}

" モードラインを有効にする {{{
set modeline
" 3行目までをモードラインとして検索する
set modelines=3
" }}}

" hilight in visual mode {{{
hi Visual cterm=reverse ctermbg=NONE
" }}}

" selector of short form {{{
set virtualedit+=block
" }}}

" netrw {{{
" prewiew setting
let g:netrw_preview=1
" TreeView
let g:netrw_liststyle = 3
" date format
let g:netrw_timefmt='%Y/%m/%d(%a) %H:%M:%S'
" size format
let g:netrw_sizestyle="H"
" }}}

"左右のカーソル移動で行間移動可能にする。
set whichwrap=h,l,b,s,<,>,[,]

" fast scroll {{{
set lazyredraw
set ttyfast
" }}}

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1

" バックスペースでの削除をいつでも有効にする
set backspace=indent,eol,start

" スペルチェックを有効にする {{{
" set spell
"日本語を除外
" set spelllang=en,cjk
" }}}

" cursor setting: always set cursor center {{{
set scrolloff=100
" }}}

" mouseScroll on
set mouse=a
set ttymouse=xterm2

" foftmethod setting {{{
set foldmethod=marker
" manual: 手動で折畳を定義する
" indent: インデントの数を折畳のレベル(深さ)とする
" expr:   折畳を定義する式を指定する
" syntax: 構文強調により折畳を定義する
" diff:   変更されていないテキストを折畳対象とする
" marker: テキスト中の印で折畳を定義する
" }}}

set ttimeoutlen=10

" synmaxcol setting {{{
" 'synmaxcol' 'smc'	number	(default 3000)
set synmaxcol=256
" }}}

" setting save session
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal
" }}}

" grep {{{

" Rgコマンドで、ファイルをfzf検索 {{{
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)
" Rg }}}

" }}}

" apperance {{{

" 行番号設定 {{{
set relativenumber
set number
" set nonumber
" }}}

" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
" set cursorcolumn
" cursorlineの色をクリア
" hi clear CursorLi

" insertモードの時にカーソルの見た目を縦棒に変更する
if has('vim_starting')
" 挿入モード時に非点滅の縦棒タイプのカーソル
	let &t_SI .= "\e[6 q"
" ノーマルモード時に非点滅のブロックタイプのカーソル
	let &t_EI .= "\e[2 q"
" 置換モード時に非点滅の下線タイプのカーソル
	let &t_SR .= "\e[4 q"
endif

" 分割ラインのカラー変更
" highlight VertSplit gui=reverse guifg=bg

" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2

" setting list {{{
set list
set listchars+=tab:\¦\ ,trail:-,eol:↲
" }}}

" 画面分割の見た目変更
" set fillchars+=vert:\│
" set fillchars=vert:\|,fold:\  eventignore= helplang=en viewoptions=options,cursor virtualedit=
" hi LineNr guibg=bg
" hi foldcolumn guibg=bg
" hi VertSplit guibg=bg guifg=bg
" hi VertSplit ctermfg=Black ctermbg=DarkGray
" hi VertSplit ctermfg=bg
" highlight VertSplit gui=reverse guifg=Red

" airlineの設定
" タブバーをかっこよく

" let g:airline#extensions#tabline#enabled = 1

" TODO: introduce TabsideBar
" sideBar {{{
" set showtabsidebar=2
" set tabsidebarcolumns=20
" set tabsidebarwrap
" set tabsidebar=%!TabSideBar()
" function! TabSideBar() abort
"     try
"         let lines = [printf('TabPage:%d', g:actual_curtabpage)]
"         for x in getwininfo()
"             if x.tabnr == g:actual_curtabpage
"                 let s = '[No Name]'
"                 if x.terminal
"                     let s = '[Terminal]'
"                 elseif x.quickfix
"                     let s = '[QuickFix]'
"                 elseif x.loclist
"                     let s = '[LocList]'
"                 else
"                     let s = fnamemodify(bufname(x.bufnr), ':t')
"                 endif
"                 let lines += [printf('  %s', s)]
"             endif
"         endfor
"     catch
"         return string(v:exception)
"     endtry
"     return join(lines, "\n")
" endfunction
" }}}

" }}}

" search {{{

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト表示
set hlsearch

" ESC二回でハイライト解除
nnoremap <Esc><Esc> :nohlsearch<CR>

" file reading profile {{{
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
" }}}

" }}}

" colors {{{

" 行番号の色を設定 {{{
hi LineNr ctermbg=0 ctermfg=0
hi CursorLineNr ctermbg=4 ctermfg=0
" set cursorline
" hi clear CursorLine
" 行番号の色設定 }}}

 " カラースキーム
" colorscheme koehler
" colorscheme molokai
colorscheme gruvbox
" ダーク系のカラースキーム設定
" set background=dark
" ホワイト系のカラースキーム設定
" set background=light

" 行番号の色を設定する
" autocmd ColorScheme * highlight LineNr ctermfg=239
 " highlight LineNr ctermfg=239

" カラープラグイン tenderplus {{{
" if (has("termguicolors"))
"  set termguicolors
" endif
"
" syntax enable
" colorscheme tender
" tenderplus }}}

" カラープラグイン molokai {{{
" if (has("molokai"))
" 	colorscheme molokai
" endif
"
" set t_Co=256
" syntax enable
" mololkai}}}

" }}}

" editing {{{

" https://vim-jp.org/vimdoc-ja/map.html#mapleader
" Leaderキーをスペースに設定 {{{
let g:mapleader = "\<Space>"
" }}}


" vpbuffer
nnoremap <silent> <Space>lb :<C-u>LoadBuffer<CR>

inoremap <silent> jk <ESC>
inoremap <silent> kj <ESC>

" コロン、セミコロン入れ替え
nnoremap ; :

" ファイル保存と終了 {{{
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q!<CR>
" }}}

" numberとrelativenumberのトグル切り替え
nnoremap <silent> <Leader>rn :set relativenumber!<CR>
nnoremap <silent> <Leader>run :set nonumber!<CR>

" 括弧を自動で閉じるように設定
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" スクロール系の挙動を微調整する
noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
noremap <expr> <C-y> (line('w0') <= 1         ? 'k' : "\<C-y>")
noremap <expr> <C-e> (line('w$') >= line('$') ? 'j' : "\<C-e>")

" neartreeのトグル
nnoremap s; :<C-u>NERDTreeTabsToggle<CR>

" VimFilerのトグル
" nnoremap <silent> s; :VimFilerExplore<CR>

" moving command line {{{
cnoremap <c-b> <S-Left>
cnoremap <c-f> <S-Right>
cnoremap <c-a> <Home>
" }}}

" tmux {{{
nnoremap s <Nop> " プレフィックスキーの変更
nnoremap sj <C-w>j " カレントウィンドウの移動
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
nnoremap sN :<C-u>bn<CR>  " バッファ移動
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap th :-tabm<CR>
nnoremap tl :+tabm<CR>
" nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
" tmux end }}}

" --- unite_vim --- {{{
" insert modeで開始
let g:unite_enable_start_insert = 1


" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
let g:unite_source_grep_recursive_opt = ''
endif

" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" grep検索
" nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
" nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

" grep検索結果の再呼出
" nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

" --- unite--- }}}

" 行を移動
nnoremap <C-Up> "zdd<Up>"zP
nnoremap <C-Down> "zdd"zp
" 複数行を移動
vnoremap <C-Up> "zx<Up>"zP`[V`]
vnoremap <C-Down> "zx"zp`[V`]

" インサートモードでカーソル移動
inoremap <C-f> <Right>
inoremap <C-b> <Left>

" カーソル下の単語をハイライトする
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>

" ハイライト消去と再描写
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>


nnoremap <Leader>bf :Buffers<CR>

" tagsジャンプの時に複数ある時は一覧表示
" nnoremap <C-]> g<C-]>

" vimgrepによる移動のキーマップ
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ

" QuickFix系の設定
autocmd QuickFixCmdPost vimgrep cwindow
" 下記のとおりにすると:grepや:Ggrepでも自動的にquickfix-windowを開くようになる。
autocmd QuickFixCmdPost *grep* cwindow

" カーソル位置の単語をgrep検索
" nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>


" TODO: change ag to rg
" カーソル上の単語をsilver-search検索
nnoremap <Space>c :<C-u>Ag --hidden <cword><CR>
nnoremap <Space>r :Rg<Space>
" nnoremap ,c :Rg .shellescape(<cword>)

" easymotion keymap {{{
" デフォルトのキーマップはオフに
let g:EasyMotion_do_mapping = 0
" f + 2文字 で画面全体を検索してジャンプ
map <Space>f <plug>(easymotion-overwin-f2)
" 検索時、大文字小文字を区別しない
let g:EasyMotion_smartcase = 1

" =======================================
" Line Motions
" =======================================
" `JK` Motions: Extend line motions
map <Space>j <Plug>(easymotion-j)
map <Space>k <Plug>(easymotion-k)
" keep cursor column with `JK` motions
let g:EasyMotion_startofline = 0

" easymotionのキーマップ END }}}

" vim slash(/) マッチ数の出力 {{{
nnoremap <expr> / _(":%s/<Cursor>/&/gn")

function! s:move_cursor_pos_mapping(str, ...)
    let left = get(a:, 1, "<Left>")
    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
    return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
    return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction
" vim slash(/) マッチ数の出力 END }}}

" 上下の空白に移動
nnoremap <C-j> }
nnoremap <C-k> {

" vimrcを気軽に編集
nnoremap <Leader>. :new ~/.vimrc<CR>
nnoremap <Leader>s :source ~/.vimrc<CR>

" universal_tags
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" window mode with number {{{
let i = 1
while i <= 9
    " execute 'nnoremap <Space>' . i . ' :' . i . 'wincmd w<CR>'
    execute 'nnoremap <Space>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile
" }}}

" }}}

" misc {{{

" yankした文字をクリップボードにも反映する
set clipboard+=unnamed

" 改行時のコメントを自動で付けない設定
au FileType * setlocal formatoptions-=ro

" TODO 要らなければ削除
" nerdTreeが最後のバッファの場合、自動で削除する
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ターミナルを画面下部に表示
" set splitbelow
" set termwinsize=14x0

" }}}

" cursorline {{{

" カーソルラインの表示に制限をかけ、軽量化する機構 {{{
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

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

" each_lang {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
" set expandtab
set autoindent
set smartindent

augroup fileTypeIndent
	autocmd!
	" autocmd BufRead,BufNewFile *.py
	autocmd BufRead,BufNewFile *.go setlocal tabstop=2 shiftwidth=2 softtabstop=2
	autocmd BufRead,BufNewFile *.rb setlocal tabstop=2 shiftwidth=2 softtabstop=2
	" autocmd BufRead,BufNewFile *.vim setlocal tabstop=4 shiftwidth=4 softtabstop=4
	autocmd BufNewFile,BufRead *.c setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufNewFile *.md setlocal tabstop=2 shiftwidth=2 softtabstop=2
	autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufNewFile,BufRead *.json setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufNewFile,BufRead *.vim setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" }}}

" vim: foldmethod=marker
