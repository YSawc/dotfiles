local opt = vim.opt           -- Set options (global/buffer/windows-scoped)

opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
opt.swapfile = false          -- Don't use swapfile
opt.expandtab = true
opt.foldmethod = 'indent'
opt.autoindent = true
opt.smartindent = true
opt.scrolloff = 10
opt.cursorline = true
opt.whichwrap = "b,s,h,l,[,],<,>,~"
