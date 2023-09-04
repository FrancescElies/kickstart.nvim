-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'

local nu = { number = true, relativenumber = true }

local function toggle_number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
  end
end

vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

-- Move to next and previous buffer with ease
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- quickfix
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>', { desc = '[Q]uickfix previous' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = '[Q]uickfix next' })
vim.keymap.set('n', '[Q', '<cmd>cfirst<cr>', { desc = '[Q]uickfix [F]irst]' })
vim.keymap.set('n', ']Q', '<cmd>clast<cr>', { desc = '[Q]uickfix [L]ast' })

-- Keep things vertically centered during searches
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Move lines in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- Reload configuration
vim.keymap.set('n', '<leader>vf', ':FormatToggle<CR>', { desc = '[V]im toggle [F]ormat' })
vim.keymap.set('n', '<leader>vn', toggle_number, { desc = '[V]im toggle [N]umber' })

return {
  -- navigate panes
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      local ss = require 'smart-splits'
      vim.keymap.set('n', '<A-h>', ss.resize_left)
      vim.keymap.set('n', '<A-j>', ss.resize_down)
      vim.keymap.set('n', '<A-k>', ss.resize_up)
      vim.keymap.set('n', '<A-l>', ss.resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', ss.move_cursor_left)
      vim.keymap.set('n', '<C-j>', ss.move_cursor_down)
      vim.keymap.set('n', '<C-k>', ss.move_cursor_up)
      vim.keymap.set('n', '<C-l>', ss.move_cursor_right)
    end,
  },
  -- use your text editor in the browser
  { 'subnut/nvim-ghost.nvim' },
  -- automatically follow symlinks
  { 'aymericbeaumet/vim-symlink', requires = { 'moll/vim-bbye' } },
  -- markdown preview
  { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
  -- You find yourself frequenting a small set of files and you are tired of using a fuzzy finder,
  -- :bnext & :bprev are getting too repetitive, alternate file doesn't quite cut it, etc etc.
  {
    'ThePrimeagen/harpoon',
    config = function()
      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'

      vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = '[H]arpoon [A]dd file' })
      vim.keymap.set('n', '<leader>ht', ui.toggle_quick_menu, { desc = '[H]arpoon [T]oggle quick menu' })
      vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)
      vim.keymap.set('n', '<leader>hn', ui.nav_next, { desc = '[H]arpoon nav [N]ext' })
      vim.keymap.set('n', '<leader>hp', ui.nav_prev, { desc = '[H]arpoon nav [P]revious' })
      vim.keymap.set('n', '<leader>h1', function() ui.nav_file(1) end, { desc = '[H]arpoon goto file [1]' })
      vim.keymap.set('n', '<leader>h2', function() ui.nav_file(2) end, { desc = '[H]arpoon goto file [2]' })
      vim.keymap.set('n', '<leader>h3', function() ui.nav_file(3) end, { desc = '[H]arpoon goto file [3]' })
      vim.keymap.set('n', '<leader>h4', function() ui.nav_file(4) end, { desc = '[H]arpoon goto file [4]' })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
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
        { opts.mappings.add, desc = 'Add surrounding', mode = { 'n', 'v' } },
        { opts.mappings.delete, desc = 'Delete surrounding' },
        { opts.mappings.find, desc = 'Find right surrounding' },
        { opts.mappings.find_left, desc = 'Find left surrounding' },
        { opts.mappings.highlight, desc = 'Highlight surrounding' },
        { opts.mappings.replace, desc = 'Replace surrounding' },
        { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = 'gza', -- Add surrounding in Normal and Visual modes
        delete = 'gzd', -- Delete surrounding
        find = 'gzf', -- Find surrounding (to the right)
        find_left = 'gzF', -- Find surrounding (to the left)
        highlight = 'gzh', -- Highlight surrounding
        replace = 'gzr', -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`
      },
    },
  },
  -- search/replace in multiple files
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    opts = { open_cmd = 'noswapfile vnew' },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
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
    on_attach = function() vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true }) end,
  },
  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'mason.nvim' },
    opts = function()
      local nls = require 'null-ls'
      return {
        root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.rome,
          -- nls.builtins.formatting.spell,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.black,
          nls.builtins.formatting.ruff,
          nls.builtins.diagnostics.ruff,
          -- nls.builtins.diagnostics.flake8,
        },
      }
    end,
  },
}
