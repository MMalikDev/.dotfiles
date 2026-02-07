-- Useful plugin to show you pending keybinds.
-- https://github.com/folke/which-key.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      icons = { mappings = vim.g.have_nerd_font },

      ---@type false | "classic" | "modern" | "helix"
      preset = 'helix',

      -- Delay before showing the popup.
      ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
      delay = 0,
    },

    ---@type (string|wk.Sorter)[]
    --- Mappings are sorted using configured sorters and natural sort of the keys
    --- Available sorters:
    --- * local: buffer-local mappings first
    --- * order: order of the items (Used by plugins like marks / registers)
    --- * group: groups last
    --- * alphanum: alpha-numerical first
    --- * mod: special modifier keys last
    --- * manual: the order the mappings were added
    --- * case: lower-case first
    sort = { 'manual', 'local', 'order', 'group', 'alphanum', 'mod' },
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true, -- adds help for operators like d, y, ...
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    layout = {
      width = { min = 20 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
    },
    keys = {
      scroll_down = '<c-d>', -- binding to scroll down inside the popup
      scroll_up = '<c-u>', -- binding to scroll up inside the popup
    },
  },
}
