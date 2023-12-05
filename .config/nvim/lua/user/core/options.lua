local opt = vim.opt           -- Set options (global/buffer/windows-scoped)

opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
opt.swapfile = false          -- Don't use swapfile
opt.expandtab = true

local set = vim.opt
-- https://neovim.io/doc/user/api.html#nvim_create_autocmd()
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    set.tabstop = 2
    set.shiftwidth = 2
    set.softtabstop = 2
  end
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'veryl' },
  callback = function()
    set.tabstop = 4
    set.shiftwidth = 4
    set.softtabstop = 4
  end
})

opt.foldmethod = 'indent'
