-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'
vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.splitright = true
vim.opt.splitbelow = true

return {
  -- use your text editor in the browser
  -- { 'subnut/nvim-ghost.nvim' },

  -- automatically follow symlinks
  { 'aymericbeaumet/vim-symlink', dependencies = { 'moll/vim-bbye' } },

  -- markdown preview
  {
    'ellisonleao/glow.nvim',
    config = true,
    cmd = 'Glow'
  },

  -- Navigate and manipulate file system
  {
    'echasnovski/mini.files',
    version = false,
    keys = {
      {
        '<leader>fm',
        function() require('mini.files').open() end,
        desc = '[M]ini [Files]',
      },
    },
  },

  -- tree like view for document symbols
  {
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
    keys = { { '<leader>do', '<cmd>SymbolsOutline<cr>', desc = '[D]ocument symbols [O]utline' } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = 'right',
    },
  },
  -- buffer remove which saves window layout
  {
    'echasnovski/mini.bufremove',
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
    },
  },
  -- surround actions
  {
    'echasnovski/mini.surround',
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require('lazy.core.config').spec.plugins['mini.surround']
      local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
      local mappings = {
        { opts.mappings.add,            desc = 'Add surrounding',                     mode = { 'n', 'v' } },
        { opts.mappings.delete,         desc = 'Delete surrounding' },
        { opts.mappings.find,           desc = 'Find right surrounding' },
        { opts.mappings.find_left,      desc = 'Find left surrounding' },
        { opts.mappings.highlight,      desc = 'Highlight surrounding' },
        { opts.mappings.replace,        desc = 'Replace surrounding' },
        { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = 'gza',            -- Add surrounding in Normal and Visual modes
        delete = 'gzd',         -- Delete surrounding
        find = 'gzf',           -- Find surrounding (to the right)
        find_left = 'gzF',      -- Find surrounding (to the left)
        highlight = 'gzh',      -- Highlight surrounding
        replace = 'gzr',        -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`
      },
    },
  },

  -- autopoirs
  {
    'windwp/nvim-autopairs',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'LhKipp/nvim-nu',
    config = function() require('nu').setup() end,
    callback = function() vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true }) end,
  }
}
