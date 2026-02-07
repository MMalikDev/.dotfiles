-- Color preview for hex like values
-- https://github.com/norcalli/nvim-colorizer.lua

---@module 'lazy'
---@type LazySpec
return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({
      '*', -- Apply to all filetypes
    }, {
      mode = 'background', -- Highlight background; use "foreground" to colorize text
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = true, -- Color names like "red", "blue"
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features (overrides individual settings)
    })
  end,
}
