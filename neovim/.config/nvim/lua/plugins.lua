-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.

return {
  -- Plugins can be added via a link or github org/name. To run setup automatically, use `opts = {}`

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/plugins/*.lua` to get going.
  { import = 'plugins' },
  { import = 'plugins/ui' },
  { import = 'plugins/views' },
  { import = 'plugins/utils' },
  { import = 'plugins/languages' },

  -- NOTE:  You can also manually import using the following syntax
  --   require 'plugins.',
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}
