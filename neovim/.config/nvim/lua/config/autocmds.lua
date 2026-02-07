-- Autocmds are automatically loaded on the VeryLazy event
-- Add  autocmds here with `vim.api.nvim_create_autocmd`

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name) return vim.api.nvim_create_augroup('nvim_' .. name, { clear = true }) end

autocmd('User', {
  desc = 'Setup some globals for debugging ',
  group = augroup 'snack-debug',
  pattern = 'VeryLazy',
  callback = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    _G.dd = function(...) Snacks.debug.inspect(...) end
    ---@diagnostic disable-next-line: duplicate-set-field
    _G.bt = function() Snacks.debug.backtrace() end
    -- Override print to use snacks for `:=` command
    if vim.fn.has 'nvim-0.11' == 1 then
      ---@diagnostic disable-next-line: duplicate-set-field
      vim._print = function(_, ...) _G.dd(...) end
    else
      vim.print = _G.dd
    end
  end,
})

autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  desc = 'Notify when recording a macro',
  group = augroup 'macro-notify',
  callback = function(ev)
    local msg
    if ev.event == 'RecordingEnter' then
      msg = 'Recording to register @'
    else
      msg = 'Recorded to register @'
    end
    vim.notify(msg .. vim.fn.reg_recording(), vim.log.levels.INFO, { title = 'Macro', timeout = 5000, hide_from_history = false })
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = augroup 'highlight_yank', -- { clear = true }),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

autocmd({ 'BufWritePre' }, {
  desc = 'Auto create parent directories when saving a file if they do not exist',
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- TODO: Add a this autcmd
-- autocmd({ 'BufWritePre', {
--   desc = 'Recursively unfold when cursor is move within a fold',
--   group = augroup 'unfold_focus',
--   -- callback = function(event) end,
-- })

autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'Check if we need to reload the file when it changed',
  group = augroup 'checktime',
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd 'checktime' end
  end,
})

autocmd({ 'VimResized' }, {
  desc = 'Resize splits if window got resized',
  group = augroup 'resize_splits',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

autocmd('FileType', {
  desc = 'Close some filetypes with <q>',
  group = augroup 'close_with_q',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dap-float',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

autocmd('FileType', {
  desc = 'Close man-files when opened inline',
  group = augroup 'man_unlisted',
  pattern = { 'man' },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

autocmd('FileType', {
  desc = 'Wrap and check for spell in text filetypes',
  group = augroup 'wrap_spell',
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd({ 'FileType' }, {
  desc = 'Fix conceallevel for json files',
  group = augroup 'json_conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

autocmd('BufReadPost', {
  desc = 'Go to last loc when opening a buffer',
  group = augroup 'last_loc',
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then return end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})
