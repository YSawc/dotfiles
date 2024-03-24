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
    'williamboman/mason.nvim',
    'nvimtools/none-ls.nvim',
    'jay-babu/mason-null-ls.nvim',
    config = function()
      require("mason").setup()
      require("mason-null-ls").setup({
        automatic_installation = false,
        automatic_setup = true, -- Recommended, but optional
      })

      local null_ls = require("null-ls")
      local eslint = require("eslint")
      require("none-ls").setup({
        sources = {
          eslint.with({
            prefer_local = "node_modules/.bin",
          }),
          null_ls.builtins.formatting.prettier,
        },
        debug = false,

      })

      require 'mason-null-ls'.setup_handlers()
    end
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
  },
  'MunifTanjim/prettier.nvim',
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
      'jay-babu/mason-null-ls.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/vim-vsnip',
      'neovim/nvim-lspconfig',
    },
    config = function()
      vim.keymap.set('n', ',e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local set = vim.keymap.set
          local bufopts = { noremap = true, silent = true, buffer = ev.buf }
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
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
        end,
      });
      local on_attach = function(client, bufnr)
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
          local capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
          require("lspconfig")[server_name].setup {
            on_attach    = on_attach,
            capabilities = capabilities,
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
        ["rust_analyzer"] = function() end,
      })
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
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
          { name = 'buffer' },
          { name = 'path' },
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
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  'junegunn/fzf',
  'junegunn/fzf.vim',
  'ibhagwan/fzf-lua',
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      'xiyaowong/transparent.nvim'
    },
    config = function()
      require('transparent').clear_prefix('NeoTree')
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
      vim.keymap.set('n', '<Space>ff', function()
        builtin.find_files({
          -- layout_strategy = 'vertical',
          use_regex = true,
          file_ignore_patterns = { ".git" },
        })
      end, {})
      vim.keymap.set('n', '<Space>fF', function()
        builtin.find_files({
          use_regex = true,
          hidden = true,
          file_ignore_patterns = { ".git" },
        })
      end, {})
      -- vim.keymap.set('n', '<Space>fg', builtin.live_grep, {})
      vim.keymap.set("n", "<Space>fg",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
      vim.keymap.set('n', '<Space>fG', function()
        builtin.live_grep({
          use_regex = true,
          additional_args = { '-u' },
          file_ignore_patterns = { ".git" },
        })
      end, {})

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
    'j-hui/fidget.nvim',
    tag = "v1.0.0",
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
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end
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
  -- 'unblevable/quick-scope',
  {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup {} end
  },
  -- {
  --   'andymass/vim-matchup',
  -- },
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
  {
    'simeji/winresizer',
    config = function()
      vim.g.winresizer_vert_resize = 1
      vim.g.winresizer_horiz_resize = 1
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'xiyaowong/transparent.nvim'
    },
    config = function()
      require('transparent').clear_prefix('lualine')
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
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim'
  },
  'stevearc/dressing.nvim',
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
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  {
    'nvim-treesitter/nvim-treesitter',
    tag = 'v0.9.2',
    build = ':TSUpdate',
  },
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
    'nvim-pack/nvim-spectre',
    config = function()
      vim.keymap.set('n', ',S', '<cmd>lua require("spectre").toggle()<CR>', {
        desc = "Toggle Spectre"
      })
      vim.keymap.set('n', ',sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "Search current word"
      })
      vim.keymap.set('v', ',sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = "Search current word"
      })
      vim.keymap.set('n', ',sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        desc = "Search on current file"
      })
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
    'xiyaowong/transparent.nvim',
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
    "nvimdev/lspsaga.nvim",
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
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        overridePalette = function(_filter)
          return {
            background = "#000000",
            text = "#caccc0",
            accent1 = "#c42632",
            -- accent1 = "#c42652",
            accent3 = "#b3b42b",
            accenf4 = "#86b42b",
            accent5 = "#56adbc",
          }
        end
        -- classic default
        -- return {
        --   dark2 = "#161613",
        --   dark1 = "#1d1e19",
        --   background = "#272822",
        --   text = "#fdfff1",
        --   accent1 = "#f92672",
        --   accent2 = "#fd971f",
        --   accent3 = "#e6db74",
        --   accent4 = "#a6e22e",
        --   accent5 = "#66d9ef",
        --   accent6 = "#ae81ff",
        --   dimmed1 = "#c0c1b5",
        --   dimmed2 = "#919288",
        --   dimmed3 = "#6e7066",
        --   dimmed4 = "#57584f",
        --   dimmed5 = "#3b3c35",
        -- }
      })
      vim.cmd([[ colorscheme monokai-pro-classic]])
    end
  },
  {
    'Wansmer/sibling-swap.nvim',
    requires = { 'nvim-treesitter' },
    config = function()
      require('sibling-swap').setup {
        keymaps = {
          ['swh'] = 'swap_with_left',
          ['swl'] = 'swap_with_right',
        }
      }
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      -- Option 2: nvim lsp as LSP client
      -- Tell the server the capability of foldingRange,
      -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup({
          capabilities = capabilities
          -- you can add other fields for setting up lsp server in this table
        })
      end

      -- Option 3: treesitter as a main provider instead
      -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
      -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end
  },
  {
    'hrsh7th/nvim-pasta',
    config = function()
      vim.keymap.set({ 'n', 'x' }, 'p', require('pasta.mapping').p)
      vim.keymap.set({ 'n', 'x' }, 'P', require('pasta.mapping').P)
    end
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },
  {
    "dnlhc/glance.nvim",
    config = function()
      require('glance').setup({
        -- your configuration
      })
      vim.keymap.set('n', 'gd', '<CMD>Glance definitions<CR>')
      vim.keymap.set('n', 'gr', '<CMD>Glance references<CR>')
      vim.keymap.set('n', 'gt', '<CMD>Glance type_definitions<CR>')
      vim.keymap.set('n', 'gi', '<CMD>Glance implementations<CR>')
    end,
  },
  { "folke/neodev.nvim",     opts = {} },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
    config = function()
      require("NeoComposer").setup()
    end
  },
  {
    'alvarosevilla95/luatab.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('luatab').setup {}
    end
  }
})
