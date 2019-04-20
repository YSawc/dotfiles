let g:vim_arryay = [
	\'.vimrc.plugins_setting',
	\'.vimrc.LSP_plugins_setting',
	\'.vimrc.basic',
	\'.vimrc.statusline',
	\'.vimrc.indent',
	\'.vimrc.apperance',
	\'.vimrc.completion',
	\'.vimrc.tags',
	\'.vimrc.search',
	\'.vimrc.moving',
	\'.vimrc.window',
	\'.vimrc.colors',
	\'.vimrc.editing',
	\'.vimrc.encoding',
	\'.vimrc.misc',
	\]

for vim in g:vim_arryay
	let $CALL_LOCATE = $HOME . '/dotfiles/vim/' . vim
	source $CALL_LOCATE
endfor


" プラグイン設定
" source ~/dotfiles/vim/.vimrc.plugins_setting

" プラグイン LSP
" source ~/dotfiles/vim/.vimrc.LSP_plugins_setting

" 基本設定
" source ~/dotfiles/vim/.vimrc.basic

" StatusLine設定
" source ~/dotfiles/vim/.vimrc.statusline

" インデント設定
" source ~/dotfiles/vim/.vimrc.indent

" 表示関連
" source ~/dotfiles/vim/.vimrc.apperance

" 補完関連
" source ~/dotfiles/vim/.vimrc.completion

" Tags関連
" source ~/dotfiles/vim/.vimrc.tags

" 検索関連
" source ~/dotfiles/vim/.vimrc.search

" 移動関連
" source ~/dotfiles/vim/.vimrc.moving

" ウィンドウ関連
" source ~/dotfiles/vim/.vimrc.window

" Color関連
" source ~/dotfiles/vim/.vimrc.colors

" 編集関連
" source ~/dotfiles/vim/.vimrc.editing

" エンコーディング関連
" source ~/dotfiles/vim/.vimrc.encoding

" その他
" source ~/dotfiles/vim/.vimrc.misc



" Vimでgitのログをきれいに表示する - derisの日記
"  http://deris.hatenablog.jp/entry/2013/05/10/003430
" source ~/dotfiles/.vimrc.gitlogviewer

