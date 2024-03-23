local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.use_ime = true
config.color_scheme = 'Dracula (base16)'
config.font =
    wezterm.font('JetBrainsMono', { weight = 'Bold', italic = false });
config.hide_tab_bar_if_only_one_tab = true
config.background = {
  {
    source = {
      Color = '#000000',
    },
    width = "100%",
    height = "100%",
    opacity = 1.00
  },
  {
    source = {
      File = os.getenv("HOME") .. '/path/to/img',
    },
    hsb = { brightness = 0.05 },
    width = "100%",
    height = "100%",
    horizontal_offset = 0,
    vertical_offset = 20,
    opacity = 0.40,
  },
}
config.disable_default_key_bindings = true
-- config.leader = { key = 'g', mods = 'CTRL', timeout_milliseconds = 1000 };
local act = wezterm.action
config.keys = {
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  -- { key = 'UpArrow',   mods = 'SHIFT', action = act.ScrollByLine(-1) },
  -- { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
  --   {
  --     key = 't',
  --     mods = 'LEADER',
  --     action = act.ActivateKeyTable {
  --       name = 'activate_tab',
  --       timeout_milliseconds = 1000,
  --     },
  --   },
  --   {
  --     key = 'p',
  --     mods = 'LEADER',
  --     action = act.ActivateKeyTable {
  --       name = 'activate_pane',
  --       timeout_milliseconds = 1000,
  --       one_shot = false,
  --     },
  --   },
  --   {
  --     key = 'P',
  --     mods = 'LEADER',
  --     action = act.ActivateKeyTable {
  --       name = 'resize_pane',
  --     },
  --   },
  --   {
  --     key = 'r',
  --     mods = 'LEADER',
  --     action = wezterm.action.ReloadConfiguration,
  --   },
  -- }
  --
  -- config.key_tables = {
  --   activate_tab = {
  --     {
  --       key = 'n',
  --       action = act.SpawnTab 'CurrentPaneDomain',
  --     },
  --     {
  --       key = 'x',
  --       action = wezterm.action.CloseCurrentTab { confirm = false },
  --     },
  --
  --   },
  --   resize_pane = {
  --     { key = 'h',      action = act.ActivatePaneDirection 'Left' },
  --     { key = 'l',      action = act.ActivatePaneDirection 'Right' },
  --     { key = 'k',      action = act.ActivatePaneDirection 'Up' },
  --     { key = 'j',      action = act.ActivatePaneDirection 'Down' },
  --     { key = 'H',      action = act.AdjustPaneSize { 'Left', 1 } },
  --     { key = 'L',      action = act.AdjustPaneSize { 'Right', 1 } },
  --     { key = 'K',      action = act.AdjustPaneSize { 'Up', 1 } },
  --     { key = 'J',      action = act.AdjustPaneSize { 'Down', 1 } },
  --     { key = 'Escape', action = 'PopKeyTable' },
  --   },
  --   activate_pane = {
  --     { key = 'h', action = act.ActivatePaneDirection 'Left' },
  --     { key = 'l', action = act.ActivatePaneDirection 'Right' },
  --     { key = 'k', action = act.ActivatePaneDirection 'Up' },
  --     { key = 'j', action = act.ActivatePaneDirection 'Down' },
  --     {
  --       key = 'r',
  --       action = wezterm.action.SplitPane {
  --         direction = 'Right',
  --         -- Leftcommand = { args = { 'top' } },
  --         size = { Percent = 50 },
  --       },
  --     },
  --     {
  --       key = 'd',
  --       action = wezterm.action.SplitPane {
  --         direction = 'Down',
  --         -- Leftcommand = { args = { 'top' } },
  --         size = { Percent = 50 },
  --       },
  --     },
  --     {
  --       key = 'x',
  --       action = wezterm.action.CloseCurrentPane { confirm = false },
  --     },
  --   }
}
return config
