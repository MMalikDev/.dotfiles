---@diagnostic disable: missing-fields
-- Adds git related signs to the gutter, as well as utilities for managing changes
-- https://github.com/lewis6991/gitsigns.nvim

---@module 'lazy'
---@type LazySpec
return {
  'lewis6991/gitsigns.nvim',
  ---@module 'gitsigns'
  ---@type Gitsigns.Config
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git change' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git change' })

      map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Git Stage Hunk' })
      map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Git Stage Hunk' })
      map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'Git Stage Buffer' })
      map('n', '<leader>ghu', gitsigns.stage_hunk, { desc = 'Git Undo Stage Hunk' })

      map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Git Reset Hunk' })
      map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Git Reset Hunk' })
      map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'Git Reset Buffer' })

      map('n', '<leader>ghb', gitsigns.toggle_current_line_blame, { desc = 'Current Line Git Blame' })
      map('n', '<leader>ghB', gitsigns.blame_line, { desc = 'Git Blame Line' })

      map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Git Preview Hunk' })
      map('n', '<leader>ghP', gitsigns.preview_hunk_inline, { desc = 'Git Preview Line' })

      map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Git Diff Against Index' })
      map('n', '<leader>ghD', function() gitsigns.diffthis '@' end, { desc = 'Git Diff Against Last Commit' })
    end,
  },
}
