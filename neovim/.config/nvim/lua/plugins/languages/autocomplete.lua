-- Autocompletion
-- https://github.com/saghen/blink.cmp

-- https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks
-- https://github.com/rafamadriz/friendly-snippets/blob/main/package.json

---@module 'lazy'
---@type LazySpec
return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- https://github.com/rafamadriz/friendly-snippets
          -- Contains a variety of premade snippets.
          {
            'rafamadriz/friendly-snippets',
            config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
          },
        },
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'enter' },
      signature = { enabled = true },
      appearance = { nerd_font_variant = 'mono' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 100 } },
      cmdline = {
        keymap = {
          ['<Tab>'] = { 'accept' },
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        completion = { menu = { auto_show = true } },
      },

      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
        },
        providers = {
          snippets = {
            opts = {
              friendly_snippets = true,
            },
          },
        },
        -- snippets = { preset = 'luasnip' },
      },
    },
  },
}
