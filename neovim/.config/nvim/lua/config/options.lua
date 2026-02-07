-- [[ Setting options ]]
-- See `:help vim.o`
--  For more options, you can see `:help option-list`

-- -- Snacks animations
-- -- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

-- -- Show the current document symbols location from Trouble in lualine
-- -- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

-- Auto format on Save
vim.g.autoformat = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- -- only set clipboard if not in ssh, to make sure the OSC 52
-- -- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and '' or 'unnamedplus' -- Sync with system clipboard
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '/',
  eob = ' ',
  horiz = '─',
  vert = '│',
}
-- opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]
-- opt.formatexpr = "v:lua.LazyVim.format.formatexpr()"
-- opt.formatoptions = 'jcroqlnt' -- tcqj
opt.foldtext = ''
opt.foldlevel = 99
opt.foldmethod = 'indent'

opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Ignore case UNLESS \C or capital letters in the search term
opt.smartindent = true -- Insert indents automatically
opt.breakindent = true -- Enable break indent

opt.linebreak = true -- Wrap lines at convenient points
opt.inccommand = 'split' -- preview incremental substitute
opt.jumpoptions = 'view'

opt.showmode = false -- Dont show mode since we have a statusline
opt.laststatus = 3 -- global statusline

opt.wrap = true -- Disable line wrap
opt.mouse = 'a' -- Enable mouse mode
opt.spelllang = { 'en' }
opt.smoothscroll = true
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

opt.ruler = false -- Disable the default ruler
opt.relativenumber = true -- Relative line numbers
opt.number = true -- Print line number
opt.scrolloff = 10 -- Lines of context

opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup

opt.termguicolors = true -- True color support
opt.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
  'help',
  'globals',
  'skiprtp',
  'folds',
}

opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time

-- Configure how new splits should be opened
opt.splitkeep = 'screen'
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current

opt.tabstop = 4 -- Number of spaces tabs count for

-- Enable undo/redo changes even after closing and reopening a file
opt.undofile = true
opt.undolevels = 10000

opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key

opt.winminwidth = 5 -- Minimum window width
opt.wildmode = 'longest:full,full' -- Command-line completion mode

-- Sets how neovim will display certain whitespace characters in the editor.
-- :help 'list'
-- :help 'listchars'
-- :help lua-options
-- :help lua-guide-options
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- -- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- -- Hide deprecation warnings
-- vim.g.deprecation_warnings = false
