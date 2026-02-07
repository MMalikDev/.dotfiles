-- Linting

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    -- Disable the default linters by setting their filetypes to nil:
    lint.linters_by_ft = {
      python = { 'ruff' },
      toml = { 'tombi' },

      json = { 'biomejs' },
      jsonc = { 'biomejs' },
      javascript = { 'biomejs' },
      typescript = { 'biomejs' },
      javascriptreact = { 'biomejs' },
      typescriptreact = { 'biomejs' },
    }

    -- Create autocommand which carries out the actual linting
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        if vim.bo.modifiable then lint.try_lint() end
      end,
    })
  end,
}
