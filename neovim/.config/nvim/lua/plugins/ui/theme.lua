-- Neovim theme
-- https://github.com/folke/tokyonight.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    lazy = false,
    opts = {},
    config = function()
      require('tokyonight').setup {}
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
