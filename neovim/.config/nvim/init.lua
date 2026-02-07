-- Basic settings
vim.o.number = true -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers
vim.o.tabstop = 4 -- Number of spaces a tab represents
vim.o.shiftwidth = 4 -- Number of spaces for each indentation
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.smartindent = true -- Automatically indent new lines
vim.o.wrap = false -- Disable line wrapping
vim.o.cursorline = true -- Highlight the current line
vim.o.termguicolors = true -- Enable 24-bit RGB colors

-- Syntax highlighting and filetype plugins
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

-- Leader key
vim.g.mapleader = ' ' -- Space as the leader key
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })

-- Initialize core settings first
require('options')
require('keymaps')

-- Load plugin manager
require('plugins')

-- Set up plugins with dependencies
require('treesitter') -- Set up before LSP for better highlighting
require('lsp')  -- Depends on language servers being available
require('completion') -- Depends on LSP configuration
require('telescope') -- Often integrates with LSP

-- Configure UI components last
require('theme')
require('statusline')