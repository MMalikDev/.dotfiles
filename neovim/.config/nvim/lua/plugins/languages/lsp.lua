-- Main LSP Configuration
-- https://github.com/neovim/nvim-lspconfig

---@module 'lazy'
---@type LazySpec
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        opts = {},
      },

      -- Maps LSP server names between nvim-lspconfig and Mason package names.
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP.
    },
    config = function()
      local autocmd = vim.api.nvim_create_autocmd
      autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          -- Function that lets us more easily define mappings specific for LSP related items.
          -- It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gn', vim.lsp.buf.rename, 'Rename')
          map('ga', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- -- -- This may be unwanted, since they displace some of your ode
          -- if client and client:supports_method('textDocument/inlayHint', event.buf) then
          --   map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle Inlay Hints')
          -- end
        end,
      })

      -- Enable the following language servers
      --  See `:help lsp-config` for information about keys and how to configure
      ---@type table<string, vim.lsp.Config>
      local servers = {
        rust_analyzer = {},
        tombi = {},

        pyright = {},
        ruff = {},
        ts_ls = {}, --    https://github.com/pmizio/typescript-tools.nvim
        biome = {},
        svelte = {},
        prettierd = {},
        tailwindcss = {},

        beautysh = {},
        docker_language_server = {},
        docker_compose_language_service = {},

        -- Special Lua Config, as recommended by neovim help docs
        stylua = {}, -- Used to format Lua code
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                --  See https://github.com/neovim/nvim-lspconfig/issues/3189
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- Debug Adapters
        'debugpy',
        'codelldb',
        'js-debug-adapter',

        -- -- Shell Script
        'bash-language-server',

        -- -- Docker
        'yaml-language-server',
        'dockerfile-language-server',

        -- -- Kubernetes
        -- 'sonarlint-language-server',
        -- 'kubescape',
        -- 'helm-ls',

        -- -- Ansible
        -- 'ansible-language-server',
        -- 'ansible-lint',

        -- -- Django
        -- 'django-language-server',
        -- 'django-template-lsp',
        -- 'djlint',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}
