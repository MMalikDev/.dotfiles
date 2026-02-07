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
        typescript = { 'biome', 'prettierd', stop_after_first = true },
        javascript = { 'biome', 'prettierd', stop_after_first = true },
        typescriptreact = { 'biome', 'prettierd', stop_after_first = true },
        javacriptreact = { 'biome', 'prettierd', stop_after_first = true },
        jsonc = { 'biome', 'prettierd', stop_after_first = true },
        json = { 'biome', 'prettierd', stop_after_first = true },
        jsx = { 'biome', 'prettierd', stop_after_first = true },
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
