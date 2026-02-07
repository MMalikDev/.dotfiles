-- Simple session management for Neovim
-- https://github.com//folke/persistence.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      dir = vim.fn.stdpath 'state' .. '/sessions/', -- directory where session files are saved
      -- minimum number of file buffers that need to be open to save
      -- Set to 0 to always save
      need = 1,
      bra,
    },
  },
}
