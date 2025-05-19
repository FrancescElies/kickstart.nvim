-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html

local telebin = require 'telescope.builtin'

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

vim.keymap.set('n', '<leader>gb', telebin.git_branches, { desc = '[G]it [B]ranches' })
vim.keymap.set('n', '<leader>gL', telebin.git_bcommits, { desc = '[G]it [L]og this [B]uffer' })
vim.keymap.set('n', '<leader>gl', telebin.git_commits, { desc = '[G]it [L]og' })
vim.keymap.set('n', '<leader>gf', telebin.git_files, { desc = '[G]it [F]iles' })
vim.keymap.set('n', '<leader>gs', telebin.git_status, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gz', telebin.git_stash, { desc = '[G]it zstash' })

vim.api.nvim_create_augroup('my_git_commands', { clear = true })

return {
  -- {
  --   'NeogitOrg/neogit',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim', -- required
  --     'sindrets/diffview.nvim', -- optional - Diff integration
  --     'nvim-telescope/telescope.nvim', -- optional
  --   },
  --   keys = { { '<leader>gn', vim.cmd.Neogit, desc = '[G]it [N]eogit' } },
  -- },
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gS', vim.cmd.Git, desc = 'git status' },
      { '<leader>gP', ':Git! push --force-with-lease -u origin <cr>', desc = '[G]it [P]ush force with lease' },
      { '<leader>gp', ':Git! pull --rebase <cr>', desc = '[G]it [P]ull rebase' },
    },
    config = function()
      local MyFugitive = vim.api.nvim_create_augroup('MyFugitive', {})

      local autocmd = vim.api.nvim_create_autocmd
      autocmd('BufWinEnter', {
        group = MyFugitive,
        pattern = '*',
        callback = function()
          if vim.bo.ft ~= 'fugitive' then
            return
          end

          local opts = { buffer = vim.api.nvim_get_current_buf(), remap = false }

          vim.keymap.set('n', '<leader>P', ':Git! push --force-with-lease -u origin <cr>', opts)
          vim.keymap.set('n', '<leader>p', ':Git! pull --rebase <cr>', opts)
        end,
      })
    end,
  },
  -- {
  --   'rhysd/git-messenger.vim',
  --   keys = { { '<leader>gm', ':GitMessenger<CR>', desc = '[G]it [Mqq shessenger' } },
  -- },
  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      { '<leader>gdf', ':DiffviewFileHistory %<cr>', desc = '[G]it [D]iff [F]ile history' },
      { '<leader>gdd', ':DiffviewFileHistory', desc = '[G]it [D]iff history' },
      { '<leader>gdb', ':DiffviewOpen', desc = '[G]it [D]iff [O]pen (merge conflicts)' },
      { '<leader>gdb', ':DiffviewOpen origin/main...HEAD', desc = '[G]it [D]iff merge [B]ase' },
      { '<leader>gdt', ":'<,'>DiffviewOpen origin/main...HEAD", desc = '[G]it [D]iff [T]race line evolution' },
      -- :DiffviewClose: Close the current diffview. You can also use :tabclose.
      -- :DiffviewToggleFiles: Toggle the file panel.
      -- :DiffviewFocusFiles: Bring focus to the file panel.
      -- :DiffviewRefresh: Update stats and entries in the file list of the current Diffview.
    },
  },
  {
    'aaronhallaert/advanced-git-search.nvim',
    diff_plugin = 'diffview',
    config = function()
      -- NOTE: optionally setup telescope before loading the extension, don't do here see docs
      require('telescope').load_extension 'advanced_git_search'
    end,
    keys = {
      { '<leader>g/', ':AdvancedGitSearch<CR>', desc = '[G]it [S]earch' },
      { '<leader>gdl', ':AdvancedGitSearch diff_commit_line<cr>', mode = { 'n', 'v' }, desc = '[G]it [D]iff [L]ine' },
      { '<leader>gr', ':AdvancedGitSearch checkout_reflog<cr>', desc = '[G]it [R]eflog' },
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
    },
  },
}
