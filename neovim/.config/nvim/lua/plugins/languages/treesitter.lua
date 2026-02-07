-- - Highlight, edit, and navigate code
-- https://github.com/nvim-treesitter/nvim-treesitter

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      local parsers = {
        'bash',
        -- 'robot-txt',
        -- 'powershell',
        'c',
        'cpp',
        'css',
        'csv',
        'diff',
        'dockerfile',
        'gitattributes',
        'git_rebase',
        'git_config',
        'gitcommit',
        'gitignore',
        'html',
        -- 'htmldjango',
        'javascript',
        -- 'jinja',
        'json',
        -- 'json5',
        -- 'llvm',
        'lua',
        'luadoc',
        'markdown_inline',
        'markdown',
        'nginx',
        'python',
        'query',
        'regex',
        'requirements',
        'rust',
        -- 'scss',
        'ssh_config',
        'svelte',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
        'zsh',
        -- 'make',
        -- 'printf',
      }

      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then return end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'

          -- enables treesitter based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
