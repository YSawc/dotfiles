local set = vim.keymap.set

vim.g.mapleader = " "
set('n', 's', '<Nop>', { noremap = true })
set('n', 'sj', '<C-w>j', { noremap = true })
set('n', 'sk', '<C-w>k', { noremap = true })
set('n', 'sl', '<C-w>l', { noremap = true })
set('n', 'sh', '<C-w>h', { noremap = true })
set('n', 'sJ', '<C-w>J', { noremap = true })
set('n', 'sK', '<C-w>K', { noremap = true })
set('n', 'sL', '<C-w>L', { noremap = true })
set('n', 'sH', '<C-w>H', { noremap = true })
set('n', 'sn', 'gn', { noremap = true })
set('n', 'sp', 'gT', { noremap = true })
set('n', 'sr', '<C-w>r', { noremap = true })
set('n', 's=', '<C-w>=', { noremap = true })
set('n', 'sw', '<C-w>w', { noremap = true })
set('n', '<Tab>', '<C-w>w', { noremap = true })
set('n', '<S-Tab>', '<C-w>W', { noremap = true })
set('n', 's0', '<C-w>=', { noremap = true })
set('n', 'sT', '<C-w>T', { noremap = true })
set('n', 'so', '<C-w>_<C-w>|', { noremap = true })
set('n', 'sO', '<C-w>=', { noremap = true })
set('n', 'sN', ':<C-u>bn<CR>', { noremap = true })
set('n', 'sP', ':<C-u>bp<CR>', { noremap = true })
set('n', 'st', ':<C-u>tabnew<CR>', { noremap = true })
set('n', 'tl', ':tabnext<CR>', { noremap = true })
set('n', 'th', '::tabprevious<CR>', { noremap = true })
set('n', 'tH', ':-tabm<CR>', { noremap = true })
set('n', 'tL', ':+tabm<CR>', { noremap = true })
set('n', 'ss', ':<C-u>sp<CR>', { noremap = true })
set('n', 'sv', ':<C-u>vs<CR>', { noremap = true })
set('n', 'sq', ':<C-u>q<CR>', { noremap = true })
set('n', 'sQ', ':<C-u>bd<CR>', { noremap = true })
set('n', 'sb', ':<C-u>Unite buffer_tab -buffer-name=file<CR>', { noremap = true })
set('n', '<Space>L', ':luafile %<CR>', { noremap = true })
set('n', '<Space>or', ':set relativenumber!<CR>', { noremap = true })
set('n', '<Space>on', ':set number!<CR>', { noremap = true })
set('n', '<Space>ow', ':set wrap!<CR>', { noremap = true })

function _G.ReloadConfig()
  for name, _ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

vim.api.nvim_set_keymap('n', '<Space>vs', '<Cmd>lua ReloadConfig()<CR>', { silent = true, noremap = true })
vim.cmd('command! ReloadConfig lua ReloadConfig()')
