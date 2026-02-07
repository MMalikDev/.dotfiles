-- Code outline sidebar to visualize and navigate code symbols
-- https://github.com/hedyhli/outline.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'hedyhli/outline.nvim',
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set('n', '<leader>to', '<cmd>Outline<CR>', { desc = 'Toggle Outline' })

      require('outline').setup {
        outline_window = {
          show_numbers = false,
          show_relative_numbers = false,
          position = 'left',
          auto_close = true,
          auto_jump = true,
          wrap = false,
        },
      }
    end,
  },
}
