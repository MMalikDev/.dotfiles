-- Keymaps are automatically loaded on the VeryLazy event

function isModuleAvailable(name)
  if package.loaded[name] then return true end
  for _, searcher in ipairs(package.searchers or package.loaders) do
    local loader = searcher(name)
    if type(loader) == 'function' then return true end
  end
  return false
end

if not isModuleAvailable 'which-key' then return end
local keys = require 'which-key'
if not isModuleAvailable 'dap' then return end
local dap = require 'dap'
if not isModuleAvailable 'dapui' then return end
local dapUI = require 'dapui'
if not isModuleAvailable 'persistence' then return end
local sessions = require 'persistence'
if not isModuleAvailable 'snacks' then return end
local Snacks = require 'snacks'
if not isModuleAvailable 'grug-far' then return end
local find_replace = require 'grug-far'

-- Groups
---@type keys.Spec
keys.add {
  {

    mode = { 'n', 'v' },
    { 'g', group = 'LSP Actions' },
    { 'gc', group = 'Comments' },
    { 'z', group = 'Folds Action' },
    { 'y', group = 'Yank' },
    { 'd', group = 'Delete' },
    { 'c', group = 'Change' },
    { 'v', group = 'Visual' },

    { '<leader>s', group = 'Search' },
    { '<leader>c', group = 'Code' },
    { '<leader>g', group = 'Git' },
    { '<leader>b', group = 'Buffer' },
    { '<leader>w', group = 'Window' },
    { '<leader>t', group = 'Toggle' },
    { '<leader>a', group = 'AI' },
    { '<leader>q', group = 'Quit' },
  },
  {
    mode = { 'n' },

    { '<leader>f', group = 'Find' },
    { '<leader>d', group = 'Debug' },
    { '<leader>x', group = 'Quickfix' },

    -- { '<leader>r', group = 'Refactor' }, -- TODO: Refactor Pluging
    -- { '<leader>o', group = 'Overseer' }, -- TODO: Task Runner

    { '<Esc>', '<cmd>nohlsearch<CR>', desc = 'Remove Search Highlights' },

    { '<leader>tk', group = 'Keymaps' },
    { '<leader>tkg', function() keys.show { global = true } end, desc = 'Global Keymaps' },
    { '<leader>tkb', function() keys.show { global = false } end, desc = 'Buffer Local Keymaps' },
  },
  { { 'x' }, { '<', '<gv', desc = 'Indent Left' }, { '>', '>gv', desc = 'Indent Right' } },
}
-- -- better up/down
keys.add {
  {
    { mode = 'n', 'x' },
    { 'j', "v:count == 0 ? 'gj' : 'j'", desc = 'Down', expr = true, silent = true },
    { '<Down>', "v:count == 0 ? 'gj' : 'j'", desc = 'Down', expr = true, silent = true },
    { 'k', "v:count == 0 ? 'gk' : 'k'", desc = 'Up', expr = true, silent = true },
    { '<Up>', "v:count == 0 ? 'gk' : 'k'", desc = 'Up', expr = true, silent = true },
  },
}

-- Undo break-points
keys.add {
  {
    mode = { 'i' },
    { ',', '<c-g>u,', desc = 'Undo break-points' },
    { '.', '<c-g>u.', desc = 'Undo break-points' },
    { ':', '<c-g>u:', desc = 'Undo break-points' },
    { ';', '<c-g>u;', desc = 'Undo break-points' },
  },
}
-- Move Lines
keys.add {
  {
    mode = { 'n' },
    { '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", desc = 'Move Down' },
    { '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", desc = 'Move Up' },
  },
  {
    mode = { 'i' },
    { '<A-j>', '<esc><cmd>m .+1<cr>==gi', desc = 'Move Down' },
    { '<A-k>', '<esc><cmd>m .-2<cr>==gi', desc = 'Move Up' },
  },
  {
    mode = { 'v' },
    { '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", desc = 'Move Down' },
    { '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", desc = 'Move Up' },
  },
}
-- -- -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keys.add {
  {
    { 'n' },
    { 'n', "'Nn'[v:searchforward].'zv'", expr = true, desc = 'Next Search Result' },
    { 'N', "'nN'[v:searchforward].'zv'", expr = true, desc = 'Prev Search Result' },
  },
  {
    { 'x', 'o' },
    { 'n', "'Nn'[v:searchforward]", expr = true, desc = 'Next Search Result' },
    { 'N', "'nN'[v:searchforward]", expr = true, desc = 'Prev Search Result' },
  },
}

-- Shortcut
keys.add {
  {
    mode = { 'i', 'x', 'n', 's' },
    { '<C-s>', '<cmd>w<cr><esc>', desc = 'Save File' },
    { '<C-S-s>', '<cmd>w<cr><esc>', desc = 'Save File' },
  },
  {
    mode = { 'n', 'v', 't' },
    { '<C-`>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
  },
  {
    mode = { 'n', 'v' },
    { '<leader>/', function() Snacks.picker.grep { hidden = true } end, desc = 'Search Text' },
    { '<leader><space>', function() Snacks.picker.buffers() end, desc = 'Select Buffer' },
    { '\\', function() Snacks.explorer { hidden = true } end, desc = 'File Explorer ' },
  },
}

-- Code
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    async = false,
    lsp_format = 'never',
  }
end
--
keys.add {
  {
    mode = { 'n', 'v' },
    -- { 'g`', '', desc = 'Goto Mark' },
    -- { 'gv', '', desc = 'Goto Insert' },
    -- { 'gi', '', desc = 'Goto Visual Select' },

    -- { 'gU', '', desc = 'Uppercase' },
    -- { 'gu', '', desc = 'Lowercase' },

    -- { 'gn', '', desc = 'Rename' },
    -- { 'ga', '', desc = 'Code Action' },

    -- -- { 'gcc', ' ', desc = 'Toggle Comment' },
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
    { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
    { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto Type Definition' },
    { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'Goto References' },

    { 'gc', group = 'LSP Calls' },
    { 'gci', function() Snacks.picker.lsp_incoming_calls() end, desc = 'Calls Incoming' },
    { 'gco', function() Snacks.picker.lsp_outgoing_calls() end, desc = 'Calls Outgoing' },

    { '<leader>cf', lsp_formatting, desc = 'Format code' },
    { '<leader>cd', vim.diagnostic.open_float, desc = 'Line Diagnostics' },
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename buffer file' },
    { '<leader>cr', function() vim.lsp.buf.rename() end, desc = 'Rename variables' },

    { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols' },
    { '<leader>cS', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions/References ' },

    { '<leader>ci', vim.show_pos, desc = 'Inspect Pos' },
    {
      '<leader>cI',
      function()
        vim.treesitter.inspect_tree()
        vim.api.nvim_input 'I'
      end,
      desc = 'Inspect Tree',
    },

    -- { '<leader>cS', function()  end, desc = 'Symbols Overview (Tree)' }, -- TODO: Add
    -- { '<leader>ch', function() end, desc = 'Signature Help -> On cursor hover' }, -- TODO: Add
    -- { '<leader>cv', function()  end, desc = 'Sort Imports -> Select VirtualEnv (Python)' }, TODO: Add
  },
}

-- Folds
keys.add {
  -- mode = { 'n', 'v' },
  -- { 'zi', '', desc = 'Toggle folding' },
  -- { 'za', '', desc = 'Toggle fold under cursor' },
  -- { 'zA', '', desc = 'Toggle all folds under cursor' },
  -- { 'zc', '', desc = 'Close fold under cursor' },
  -- { 'zC', '', desc = 'Close all folds under cursor' },
  -- { 'zo', '', desc = 'Open fold under cursor' },
  -- { 'zO', '', desc = 'Open all folds under cursor' },
  -- { 'zd', '', desc = 'Delete fold under cursor' },
  -- { 'zD', '', desc = 'Delete all folds under cursor' },
  -- { 'zR', '', desc = 'Open all fold' },
  -- { 'zr', '', desc = 'Reduces folds' },
  -- { 'zM', '', desc = 'Close all folds' },
  -- { 'zm', '', desc = 'More folds' },
  -- { 'z=', '', desc = 'Show spell Suggestions' },
  -- { 'zg', '', desc = 'Add word to spell list' },
  -- { 'zw', '', desc = 'Mark word as misspelled' },
  -- { 'zt', '', desc = 'Top' },
  -- { 'zz', '', desc = 'Center' },
  -- { 'zb', '', desc = 'Bottom' },
}

-- Search
keys.add {
  {
    mode = { 'n', 'v' },
    { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },

    { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' },

    { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
    { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },

    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
    { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },

    { '<leader>sg', function() Snacks.picker.git_grep() end, desc = 'Search Git Files' },
    { '<leader>sr', function() Snacks.picker.grep() end, desc = 'Regex Search' },
    { '<leader>sR', function() find_replace.open { prefills = { paths = vim.fn.expand '%' } } end, desc = 'Search & Replace in Buffer' }, -- F&R

    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Search Buffer Lines' },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Search Open Buffers' },

    { '<leader>sv', function() Snacks.picker.grep_word() end, desc = 'Visual Selection Search' },
    { '<leader>sw', function() find_replace.open { prefills = { search = vim.fn.expand '<cword>' } } end, desc = 'Replace Word under cursor' }, -- F&R

    { '<leader>st', function() Snacks.picker.todo_comments { keywords = { 'NOTE', 'TODO', 'FIX' } } end, desc = 'Task Comments' },
    { '<leader>sT', function() Snacks.picker.colorschemes() end, desc = 'Theme' },

    { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' }, -- Debug ?
    { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' }, -- Debug ?

    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },

    { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' }, -- Debug ?
    { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' }, -- Debug ?
    { '<leader>sL', function() Snacks.picker.resume() end, desc = 'Resume Last Search' },

    { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
    { '<leader>s.', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
    { '<leader>sn', function() Snacks.picker.notifications() end, desc = 'Search Notification' },
  },
}

-- Find
keys.add {
  mode = { 'n', 'v' },
  { '<leader>ff', function() Snacks.picker.files { hidden = true } end, desc = 'Find Files' },
  { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
  { '<leader>sr', function() find_replace.open() end, desc = 'Search & Replace' },
  { '<leader>fR', function() Snacks.picker.recent() end, desc = 'Recent' },
  { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
  { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config', hidden = true } end, desc = 'Find Config File' },
  { '<leader>fn', ':e untitled<CR>', desc = 'New File' },
}

-- Git
keys.add {
  mode = { 'n' },
  { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
  { '<leader>gD', function() Snacks.picker.git_diff { base = 'origin', group = true } end, desc = 'Git Diff (origin)' },
  { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
  { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
  { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },

  { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
  { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },

  { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
  { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
  { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse' },
}
-- Git Hunks
keys.add {
  mode = { 'n' },
  { '<leader>gh', group = 'Git Hunks' },
  { '<leader>tg', group = 'Git' },
}
-- Github
keys.add {
  mode = { 'n' },
  { '<leader>gb', group = 'GitHub' },
  { '<leader>gbi', function() Snacks.picker.gh_issue() end, desc = 'GitHub Issues (open)' },
  { '<leader>gbI', function() Snacks.picker.gh_issue { state = 'all' } end, desc = 'GitHub Issues (all)' },
  { '<leader>gbp', function() Snacks.picker.gh_pr() end, desc = 'GitHub Pull Requests (open)' },
  { '<leader>gbP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'GitHub Pull Requests (all)' },
}

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = true,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump {
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    }
  end
end

-- Brackets Motion
keys.add {
  {
    mode = { 'n', 'v' },
    { ']q', vim.cmd.cnext, desc = 'Next Quickfix' },
    { '[q', vim.cmd.cprev, desc = 'Previous Quickfix' },
    { ']d', diagnostic_goto(true), desc = 'Next Diagnostic' },
    { '[d', diagnostic_goto(false), desc = 'Prev Diagnostic' },
    { ']e', diagnostic_goto(true, 'ERROR'), desc = 'Next Error' },
    { '[e', diagnostic_goto(false, 'ERROR'), desc = 'Prev Error' },
    { ']w', diagnostic_goto(true, 'WARN'), desc = 'Next Warning' },
    { '[w', diagnostic_goto(false, 'WARN'), desc = 'Prev Warning' },
  },
  {
    mode = { 'n', 't' },
    { ']r', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference' },
    { '[r', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference' },
  },
  {
    -- mode = { 'n', 'v' },
    -- { ']]', function() end, desc = 'Repeat next last action' }, -- TODO: Add next repeat
    -- { '[[', function() end, desc = 'Repeat prev last action' },-- TODO: Add prev repeat
  },
}

-- Quickfix
keys.add {
  mode = { 'n' },
  { '<leader>xx', vim.diagnostic.setloclist, desc = 'Quickfix' },
  { '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
  { '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },

  { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
  { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
  {
    '<leader>xq',
    function()
      local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
      if not success and err then vim.notify(err, vim.log.levels.ERROR) end
    end,
    desc = 'Quickfix List',
  },
  {
    '<leader>xl',
    function()
      local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
      if not success and err then vim.notify(err, vim.log.levels.ERROR) end
    end,
    desc = 'Location List',
  },
}

-- Debug
keys.add {
  {
    mode = { 'n' },
    { '<F1>', function() dap.step_into() end, desc = 'Debug: Step Into' },
    { '<F2>', function() dap.step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() dap.step_out() end, desc = 'Debug: Step Out' },
    { '<F5>', function() dap.continue() end, desc = 'Debug: Start/Continue' },
    { '<F7>', function() dapUI.toggle() end, desc = 'Debug: See last session result.' },

    { '<leader>dp', group = 'Profiler' },
    { '<leader>dn', function() dap.new() end, desc = 'New' },

    { '<leader>dd', group = 'Debug' },
    { '<leader>ddp', function() dap.continue() end, desc = 'Play' },
    { '<leader>ddP', function() dap.pause() end, desc = 'Pause' },
    { '<leader>ddi', function() dap.step_into() end, desc = 'Step into' },
    { '<leader>ddo', function() dap.step_over() end, desc = 'Step over' },
    { '<leader>ddO', function() dap.step_out() end, desc = 'Step out' },
    { '<leader>ddb', function() dap.step_back() end, desc = 'Step back' },
    { '<leader>ddr', function() dap.run_last() end, desc = 'Run last' },
    { '<leader>ddR', function() dap.reverse_continue() end, desc = 'Reverse' },
    { '<leader>ddt', function() dap.terminate() end, desc = 'Terminate' },
    { '<leader>ddd', function() dap.disconnect() end, desc = 'Disconnect' },

    { '<leader>du', function() dapUI.toggle() end, desc = 'Toggle DAP UI' },
    { '<leader>ds', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' },
    { '<leader>db', function() dap.toggle_breakpoint() end, desc = 'Toggle Debug Breakpoint' },
    { '<leader>dB', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Set Conditional Breakpoint' },
  },
}
Snacks.toggle.profiler():map '<leader>dpp'
Snacks.toggle.profiler_highlights():map '<leader>dph'

-- Buffer
keys.add {
  mode = { 'n', 'v' },
  { '<S-tab>', '<cmd>bprevious<cr>', desc = 'Prev Buffer' },
  { '<tab>', '<cmd>bnext<cr>', desc = 'Next Buffer' },
  { '<leader>bb', '<cmd>e #<cr>', desc = 'Switch to Other Buffer' },
  { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
  { '<leader>bD', '<cmd>:bd<cr>', desc = 'Delete Buffer and Window' },
  { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
  -- { '<leader>bl', function() Snacks.bfdelete.left() end, desc = 'Delete Buffers to the Left' },
  -- { '<leader>br', function() Snacks.bufdelete.right() end, desc = 'Delete Buffers to the Right' },
  -- { '<leader>bp', function() Snacks.toggle.pinned() end, desc = 'Toggle Pin' }, -- Harpoon.nvim ?
  -- { '<leader>bP', function() Snacks.bufdelete..other(pinned=false) end, desc = 'Delete Non-Pinned' },
}

-- Window
keys.add {
  {
    mode = { 'n', 'v' },
    { '<leader>ww', '<C-W>w', desc = 'Switch window' },
    { '<leader>wr', '<C-W>v', desc = 'Split window right', remap = true },
    { '<leader>wb', '<C-W>s', desc = 'Split window below', remap = true },
    { '<leader>wd', '<C-W>c', desc = 'Delete window', remap = true },
    { '<leader>wo', '<C-W>o', desc = 'Delete other window' },

    { '<leader>wh', '<C-w>h', desc = 'Go to left window' },
    { '<leader>wj', '<C-w>j', desc = 'Go to window below' },
    { '<leader>wk', '<C-w>k', desc = 'Go to above window' },
    { '<leader>wl', '<C-w>l', desc = 'Go to right window' },
    { '<C-h>', '<C-w>h', desc = 'Go to left window', remap = true },
    { '<C-j>', '<C-w>j', desc = 'Go to window below', remap = true },
    { '<C-k>', '<C-w>k', desc = 'Go to window above ', remap = true },
    { '<C-l>', '<C-w>l', desc = 'Go to right window', remap = true },

    { '<leader>wJ', '<C-w>J', desc = 'Move window to bottom', remap = true },
    { '<leader>wH', '<C-w>H', desc = 'Move window to left', remap = true },
    { '<leader>wK', '<C-w>K', desc = 'Move window to top', remap = true },
    { '<leader>wL', '<C-w>L', desc = 'Move window to right', remap = true },

    { '<leader>w+', '<cmd>resize +2<cr>', desc = 'Increase Height' },
    { '<leader>w-', '<cmd>resize -2<cr>', desc = 'Decrease Height' },
    { '<C-Up>', '<cmd>resize +2<cr>', desc = 'Increase Window Height' },
    { '<C-Down>', '<cmd>resize -2<cr>', desc = 'Decrease Window Height' },

    { '<leader>w>', '<cmd>vertical resize +2<cr>', desc = 'Increase Width' },
    { '<leader>w<', '<cmd>vertical resize -2<cr>', desc = 'Decrease Width' },
    { '<C-Right>', '<cmd>vertical resize +2<cr>', desc = 'Increase Window Width' },
    { '<C-Left>', '<cmd>vertical resize -2<cr>', desc = 'Decrease Window Width' },

    { '<leader>w-', '<C-W>_', desc = 'Max out Height' },
    { '<leader>w|', '<C-W>|', desc = 'Max out Width' },
    { '<leader>w=', '<C-W>=', desc = 'Equal Height & Width' },
  },
}

-- Toggle
local hidden_tab_opt = { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }
Snacks.toggle.option('showtabline', hidden_tab_opt):map '<leader>ta'
Snacks.toggle.animate():map '<leader>tA'

Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>tb'
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tc'

Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
Snacks.toggle.scroll():map '<leader>tS'

Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tl'
Snacks.toggle.line_number():map '<leader>tL'
Snacks.toggle.treesitter():map '<leader>tT'

Snacks.toggle.indent():map '<leader>tG'

Snacks.toggle.inlay_hints():map '<leader>th'
Snacks.toggle.diagnostics():map '<leader>td'

Snacks.toggle.dim():map '<leader>tD'
Snacks.toggle.zen():map '<leader>tz'
Snacks.toggle.zoom():map '<leader>tZ'

keys.add {
  {
    { 'n' },
    -- { '<leader>tg', '', 'Git Signs' }, -- TODO: Add
    -- { '<leader>tp', '', 'Mini Pairs' }, -- TODO: Add
    -- { '<leader>tf', '', 'Autoformat buffer' }, -- TODO: Add
    -- { '<leader>tF', '', 'Autoformat global' }, -- TODO: Add
    { '<leader>t.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<leader>tr', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', desc = 'Redraw / Clear hlsearch / Diff Update' },
  },
}
keys.add {
  mode = { 'n' },
  { '<leader>tn', group = 'Notification' },
  { '<leader>tnn', function() Snacks.notifier.show_history() end, desc = 'Notifications History' },
  { '<leader>tnd', function() Snacks.notifier.hide() end, desc = 'Dismiss All' },
  {
    '<leader>tnN',
    desc = 'Neovim News',
    function()
      Snacks.win {
        file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
          spell = false,
          wrap = false,
          signcolumn = 'yes',
          statuscolumn = ' ',
          conceallevel = 3,
        },
      }
    end,
  },
}

-- Quit & Sessions
keys.add {
  {
    mode = { 'n', 'v' },
    { '<leader>qe', '<cmd>q!<cr>', desc = 'Exit without saving' },
    { '<leader>qw', '<cmd>wq<cr>', desc = 'Write and Exit' },
    { '<leader>qs', '<cmd>w<cr>', desc = 'Save Changes' },
    { '<leader>qq', '<cmd>q<cr>', desc = 'Quit All' },
    { '<leader>qr', function() sessions.load { last = true } end, desc = 'Restore last session' },
    { '<leader>qd', function() sessions.stop() end, desc = "Don't save session on exit" },
    { '<leader>qp', function() sessions.select() end, desc = 'Select project session ' },
  },
}
