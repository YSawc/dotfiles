local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'williamboman/nvim-lsp-installer',
    'neovim/nvim-lspconfig',
    config = function()
    end
  },
  {
    'williamboman/mason.nvim',
    'nvimtools/none-ls.nvim',
    'jay-babu/mason-null-ls.nvim',
    config = function()
      require("mason").setup()
      require("mason-null-ls").setup({
        automatic_installation = false,
        automatic_setup = true, -- Recommended, but optional
      })

      require("none-ls").setup({
        sources = {
          -- Anything not supported by mason.
        }
      })

      require 'mason-null-ls'.setup_handlers()
    end
  },

  'MunifTanjim/prettier.nvim',
  'williamboman/mason-lspconfig.nvim',

  'tpope/vim-fugitive',
  'airblade/vim-gitgutter',
  'ibhagwan/fzf-lua',

  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          -- { name = 'buffer' },
          -- { name = 'path' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-k>'] = cmp.mapping.scroll_docs(-4),
          ['<C-j>'] = cmp.mapping.scroll_docs(4),
        }),
        experimental = {
          ghost_text = true,
        },
      })
    end
  },
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/vim-vsnip',

  'junegunn/fzf',
  'junegunn/fzf.vim',

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require("neo-tree").setup({
        vim.keymap.set('n', '<Space>;', ':Neotree toggle<CR>'),
        filesystem = {
          window = {
            mappings = {
              ["s"] = "noop",
              ["/"] = "noop"
            }
          }
        }
      })
    end
  },

  {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.g.better_whitespace_filetypes_blacklist =
      { "diff", "git", "gitcommit", "unite", "qf", "help", "fugitive", "toggleterm" }
      -- vim.cmd([[autocmd FileType terminal DisableWhitespace]])
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Space>ff', builtin.find_files, {})
      -- vim.keymap.set('n', '<Space>fg', builtin.live_grep, {})
      vim.keymap.set("n", "<Space>fg",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
      vim.keymap.set('n', '<Space>fb', builtin.buffers, {})
      vim.keymap.set('n', '<Space>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<Space>fq', builtin.quickfix, {})
      vim.keymap.set('n', '<Space>tt', '<cmd>Telescope<cr>')


      require("telescope").load_extension("live_grep_args")

      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup {
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {
              -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          }
        }
      }
      vim.api.nvim_create_autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })
    end
  },

  {
    'nvim-telescope/telescope-file-browser.nvim',
    config = function()
      require('telescope').load_extension 'file_browser'

      vim.keymap.set('n', '<Space>tf', ':Telescope file_browser<cr>')
    end
  },

  'jremmen/vim-ripgrep',

  {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup {} end
  },

  {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('trouble').setup {
        vim.keymap.set('n', '<Space>xx', '<cmd>TroubleToggle<cr>',
          { silent = true, noremap = true }
        )
      }
    end
  },

  {
    'onsails/lspkind.nvim',
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local lspkind = require('lspkind')
      local cmp = require('cmp')
      cmp.setup {
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',  -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            -- before = function(entry, vim_item)
            --   -- ...
            --   return vim_item
            -- end
          })
        }
      }
    end
  },

  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },

  'RRethy/vim-illuminate',

  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  'unblevable/quick-scope',

  {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup {} end
  },

  {
    'andymass/vim-matchup',
  },

  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require 'octo'.setup()
    end
  },

  {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  },

  'simeji/winresizer',

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          globalstatus = true,
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          }
        }
      })
    end
  },

  {
    'norcalli/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    config = function()
      require('colorizer').setup()
    end,
  },

  'ryanoasis/vim-devicons',

  -- use({
  --   'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  --   config = function()
  --     require('lsp_lines').setup()
  --   end,
  -- })

  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
      local kopts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', 'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', 'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end
  },

  {
    'anuvyklack/pretty-fold.nvim',
    config = function()
      require('pretty-fold').setup()
      require('pretty-fold').ft_setup('lua', {
        matchup_patterns = {
          { '^%s*do$',       'end' }, -- do ... end blocks
          { '^%s*if',        'end' }, -- if ... end
          { '^%s*for',       'end' }, -- for
          { 'function%s*%(', 'end' }, -- 'function( or 'function (''
          { '{',             '}' },
          { '%(',            ')' },   -- % to escape lua pattern char
          { '%[',            ']' },   -- % to escape lua pattern char
        },
      })
    end
  },

  { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

  { 'stevearc/dressing.nvim' },

  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require 'lsp_signature'.setup()
    end
  },

  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  },

  { 'kevinhwang91/nvim-bqf',           ft = 'qf' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  {
    "b0o/incline.nvim",
    event = { "FocusLost", "CursorHold" },
    config = function()
      require("incline").setup {}
    end,
  },

  {
    'petertriho/nvim-scrollbar',
    event = {
      "BufWinEnter",
      "CmdwinLeave",
      "TabEnter",
      "TermEnter",
      "TextChanged",
      "VimResized",
      "WinEnter",
      "WinScrolled",
    },
    config = function()
      require("scrollbar").setup {}
    end,
  },

  'mizlan/iswap.nvim',

  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({})
      vim.keymap.set("n", ",s", "<cmd>lua require('substitute.range').operator()<cr>",
        { noremap = true })
      vim.keymap.set("x", ",s", "<cmd>lua require('substitute.range').visual()<cr>", { noremap = true })
      vim.keymap.set("n", ",ss", "<cmd>lua require('substitute.range').word()<cr>", { noremap = true })
    end
  },

  'ellisonleao/glow.nvim',

  {
    'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup({
        size = 40,
        open_mapping = [[<C-\>]]
      })
    end
  },

  {
    'xiyaowong/nvim-transparent',
    config = function()
      require("transparent").setup({
        extra_groups = { -- table/string: additional groups that should be cleared
          -- In particular, when you set it to 'all', that means all available groups
          -- example of akinsho/nvim-bufferline.lua
          "BufferLineTabClose",
          "BufferlineBufferSelected",
          "BufferLineFill",
          "BufferLineBackground",
          "BufferLineSeparator",
          "BufferLineIndicatorSelected",
        },
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLineNr', 'EndOfBuffer',
        },
        group = {},
      })
    end
  },

  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup()
    end
  },

  'dalance/veryl.vim',

  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" }
    }
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  {
    'gelguy/wilder.nvim',
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':', '/', '?' } })
      wilder.set_option('renderer', wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { ' ', wilder.popupmenu_devicons() },
        right = { ' ', wilder.popupmenu_scrollbar() },
      }))
    end,
  },

  {
    'onsails/diaglist.nvim',
    config = function()
      require("diaglist").init({
        -- optional settings
        -- below are defaults
        debug = false,
        -- increase for noisy servers
        debounce_ms = 150,
      })
    end
  },

  'voldikss/vim-floaterm',

  'LunarVim/bigfile.nvim',

  {
    'lambdalisue/fern.vim',
    dependencies = {
      'lambdalisue/fern-git-status.vim',
      'lambdalisue/nerdfont.vim',
      'lambdalisue/fern-renderer-nerdfont.vim',
    },
    config = function()
      vim.g['fern#renderer'] = "nerdfont"
    end
  },

  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      -- require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      local hop = require 'hop'
      hop.setup { keys = 'asdfghjkl;qwertyuiopzxcvbnm,./' }
      vim.keymap.set('', '<Space>ef', function()
        hop.hint_char2()
      end, { remap = true })
    end
  },

  {
    'simrat39/symbols-outline.nvim',
    config = function()
      require("symbols-outline").setup()
    end
  },

  {
    'https://codeberg.org/esensar/nvim-dev-container',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require("devcontainer").setup {}
    end
  }
})

-- automatically run `:PackerCompile` whenever `plugins.lua` is updated
-- vim.api.nvim_create_autocmd('BufWritePost', {
-- 	pattern = 'plugins.lua',
-- 	command = 'source <afile> | PackerCompile',
-- 	group = vim.api.nvim_create_augroup('PackerUserConfig', { clear = true }),
-- 	desc = 'automatically run `:PackerCompile` whenever `user.plugins.lua` is updated',
-- })

--- lsp
local on_attach = function(client, bufnr)
  local _ = client;
  local set = vim.keymap.set
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  set('n', ',gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
  set('n', ',gd', '<cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
  set('n', ',K', '<cmd>lua vim.lsp.buf.hover()<CR>', bufopts)
  set('n', ',gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
  set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', bufopts)
  set('n', ',D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
  set('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', bufopts)
  set('n', ',ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', bufopts)
  set('n', ',gr', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)
  set('n', ',e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', bufopts)
  set('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', bufopts)
  set('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', bufopts)
  set('n', ',q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', bufopts)
  vim.keymap.set('n', ',f', function()
    vim.lsp.buf.format { async = true }
  end, bufopts)
  set('n', ',wa', vim.lsp.buf.add_workspace_folder, bufopts)
  set('n', ',wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  set('n', ',wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
end

local lspconfig = require 'lspconfig'

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach
    }
  end,
  ['lua_ls'] = function()
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }
  end,
})
