local wo = vim.wo
wo.number = true

vim.opt.list = true
vim.opt.listchars = {
  space = "⋅",
  eol = "↴",
  tab = "»-",
}

-- make custom group with regux, then it enable to custom highlight
-- :match SpaceGroup / /
-- :hi SpaceGroup    ctermbg=None ctermfg=59 guibg=NONE guifg=None

vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
-- vim.api.nvim_set_hl(
--   0,
--   "NonText",
--   { fg = "#181818" }
-- )

vim.diagnostic.config({ severity_sort = true })

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end
})

vim.keymap.set('n', '<Space>i', function()
  -- If we find a floating window, close it.
  local found_float = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, true)
      found_float = true
    end
  end

  if found_float then
    return
  end

  vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
end, { desc = 'Toggle Diagnostics' })
