-- Collection of various small independent plugins/modules
-- https://github.com/nvim-mini/mini.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- Examples:
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple statusline & tabline.
      -- require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }
      require('mini.tabline').setup { use_icons = vim.g.have_nerd_font }

      require('mini.icons').setup {

        {
          -- Icon style: 'glyph' or 'ascii'
          style = 'glyph',

          -- -- Customize per category. See `:h MiniIcons.config` for details.
          -- default = {},
          -- directory = {},
          -- extension = {},
          -- filetype = {},
          -- lsp = {},
          -- os = {},
          --
          file = {
            ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
            ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
            ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
            ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
            ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
            ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
            ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
            ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
            ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
          },
        },
      }

      require('mini.jump2d').setup {
        labels = 'abcdefghijklmnopqrstuvwxyz',
        view = {
          dim = true,
          n_steps_ahead = 1,
        },
        allowed_lines = {
          blank = true, -- Blank line (not sent to spotter even if `true`)
          cursor_before = true, -- Lines before cursor line
          cursor_at = true, -- Cursor line
          cursor_after = true, -- Lines after cursor line
          fold = true, -- Start of fold (not sent to spotter even if `true`)
        },
        allowed_windows = {
          current = true,
          not_current = true,
        },
        mappings = {
          start_jumping = '<CR>',
        },
      }
    end,
  },
}
