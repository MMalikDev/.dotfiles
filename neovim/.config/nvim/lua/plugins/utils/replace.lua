-- Find And Replace plugin for neovim
-- https://github.com/MagicDuck/grug-far.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'MagicDuck/grug-far.nvim',
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      local find_replace = require 'grug-far'
      find_replace.setup {}

      -- Launch with the current word under the cursor as the search string
      -- :lua find_replace.open({ prefills = { search = vim.fn.expand("<cword>") } })

      --  Launch, limiting search/replace to current file
      -- :lua find_replace.open({ prefills = { paths = vim.fn.expand("%") } })

      -- Open using astgrep
      -- :lua find_replace.open({ engine = 'astgrep', transient = true })
    end,
  },
}
