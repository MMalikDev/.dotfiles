-- A collection of QoL plugins for Neovim
-- https://github.com/folke/snacks.nvim
-- Docs -- https://github.com/folke/snacks.nvim/blob/main/docs/

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = false,
        preset = {
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files', { hidden = true })" },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep', { hidden = true })" },
            { icon = ' ', key = 'p', desc = 'Projects', action = ':lua Snacks.picker.projects()' },
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason' },
            { icon = '󱐥 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'startup' },
        },
      },
      explorer = {
        enabled = true,
        trash = true,
        hide_hidden = false,
        replace_netrw = true, -- Replace netrw with the snacks explorer
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = { enabled = true, hide_hidden = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = { notification = { wo = { wrap = true } } },
      lazygit = {
        -- Configure lazygit to use the current colorscheme
        configure = true,
      },
    },
  },
}
