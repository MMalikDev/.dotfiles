-- Display a character as the colorcolumn to provide characters per line guide
-- https://github.com/lukas-reineke/virt-column.nvim

---@module 'lazy'
---@type LazySpec
return {
  { 'lukas-reineke/virt-column.nvim', opts = {
    char = '┃',
    virtcolumn = '74,80,100,120,160',
  } },
}
