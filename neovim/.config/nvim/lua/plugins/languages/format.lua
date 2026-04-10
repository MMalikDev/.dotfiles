-- Autoformat
-- https://github.com/stevearc/conform.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },

    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local current_filetype = vim.bo[bufnr].filetype
        if disable_filetypes[current_filetype] then return nil end
        return { timeout_ms = 1000, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        python = { 'ruff_format' },
        rust = { 'rust-analyzer' },
        toml = { 'tombi' },
        bash = { 'beautysh' },
        sh = { 'beautysh' },
        typescript = { 'biome', 'biome-organize-imports' },
        javascript = { 'biome', 'biome-organize-imports' },
        typescriptreact = { 'biome', 'biome-organize-imports' },
        javacriptreact = { 'biome', 'biome-organize-imports' },
        jsonc = { 'biome', 'biome-organize-imports' },
        json = { 'biome', 'biome-organize-imports' },
        jsx = { 'biome', 'biome-organize-imports' },
        markdown = { 'prettierd' },
        svelte = { 'prettierd' },
        yaml = { 'prettierd' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        lua = { 'stylua' },
      },
    },
  },
}
