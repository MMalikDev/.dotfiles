-- https://codeberg.org/mfussenegger/nvim-dap
--
-- https://codeberg.org/mfussenegger/nvim-dap-python
-- https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
-- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
-- https://codeberg.org/mfussenegger/nvim-dap-python

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui', -- Creates a beautiful debugger UI
    'nvim-neotest/nvim-nio', -- Required dependency for nvim-dap-ui
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local mason = vim.fn.stdpath 'data' .. '/mason/'

    -- Dap UI setup -> see :help nvim-dap-ui
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local nerd_icons = {
      Breakpoint = '',
      BreakpointCondition = '',
      BreakpointRejected = '',
      LogPoint = '',
      Stopped = '',
    }
    local fallback_icons = {
      Breakpoint = '●',
      BreakpointCondition = '⊜',
      BreakpointRejected = '⊘',
      LogPoint = '◆',
      Stopped = '⭔',
    }
    local breakpoint_icons = vim.g.have_nerd_font and nerd_icons or fallback_icons
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Rust
    local codelldb = mason .. 'bin/codelldb'
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = codelldb, -- if not in $PATH: "/absolute/path/to/codelldb"
        args = { '--port', '${port}' },
        -- detached = false, -- On windows you may have to uncomment this:
      },
    }
    local dap_configurations = {
      {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function() return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file') end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap_configurations
    dap.configurations.cpp = dap_configurations
    dap.configurations.rust = dap_configurations

    -- Python
    local python = mason .. 'packages/debugpy/venv/bin/python'
    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        cb {
          type = 'server',
          host = host,
          port = assert(port, '`connect.port` is required for a python `attach` configuration'),
          options = { source_filetype = 'python' },
        }
      else
        cb {
          type = 'executable',
          command = python, -- if not in $PATH: "path/to/virtualenvs/with/debugpy"
          args = { '-m', 'debugpy.adapter' },
          options = { source_filetype = 'python' },
        }
      end
    end
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        -- Options below are for debugpy,
        -- see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then return cwd .. '/.venv/bin/python' end
          return '/usr/bin/python'
        end,
      },
    }

    -- Javascript
    for _, adapterType in ipairs { 'node', 'chrome', 'msedge' } do
      local pwaType = 'pwa-' .. adapterType

      if not dap.adapters[pwaType] then
        dap.adapters[pwaType] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'js-debug-adapter',
            args = { '${port}' },
          },
        }
      end

      -- Define adapters without the "pwa-" prefix for VSCode compatibility
      if not dap.adapters[adapterType] then
        dap.adapters[adapterType] = function(cb, config)
          local nativeAdapter = dap.adapters[pwaType]
          config.type = pwaType
          if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end
    end

    local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'svelte' }
    local vscode = require 'dap.ext.vscode'
    vscode.type_to_filetypes['node'] = js_filetypes
    vscode.type_to_filetypes['pwa-node'] = js_filetypes

    for _, language in ipairs(js_filetypes) do
      if not dap.configurations[language] then
        local runtimeExecutable = nil
        if language:find 'typescript' then runtimeExecutable = vim.fn.executable 'tsx' == 1 and 'tsx' or 'ts-node' end
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            runtimeExecutable = runtimeExecutable,
            skipFiles = {
              '<node_internals>/**',
              'node_modules/**',
            },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            runtimeExecutable = runtimeExecutable,
            skipFiles = {
              '<node_internals>/**',
              'node_modules/**',
            },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
        }
      end
    end
  end,
}
