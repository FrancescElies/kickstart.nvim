-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html

local tele = require 'telescope.builtin'

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

vim.keymap.set('n', '<leader>gB', tele.git_branches, { desc = '[G]it [B]ranches' })
vim.keymap.set('n', '<leader>gL', tele.git_bcommits, { desc = '[G]it [L]og this [B]uffer' })
vim.keymap.set('n', '<leader>gl', tele.git_commits, { desc = '[G]it [L]og' })
vim.keymap.set('v', '<leader>gl', tele.git_bcommits_range, { desc = '[G]it [L]og' }) --- Lists commits for a range of lines in the current buffer with diff preview
-- stylua: ignore
vim.keymap.set('n', '<leader>gf', function() tele.git_files { use_file_path = true } end, { desc = '[G]it [F]iles' })
vim.keymap.set('n', '<leader>g.', tele.git_status, { desc = '[G]o [G]it' })
vim.keymap.set('n', '<leader>gz', tele.git_stash, { desc = '[G]it zstash' })

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
    -- opts = {},
    cmd = {
      'G',
      'Git',
      'Gdiffsplit',
      'Gread',
      'Gwrite',
      'Ggrep',
      'GMove',
      'GDelete',
      'GBrowse',
      'GRemove',
      'GRename',
      'Glgrep',
      'Gedit',
    },
    ft = { 'fugitive' },
    keys = {
      { '<leader>gb', '<cmd>Git blame<cr>', desc = 'Git blame' },
      { '<leader>ga', '<cmd>Gwrite<cr>', desc = 'Git add current file' },
      { '<leader>gr', '<cmd>Gread<cr>', desc = 'Git restore current file' },
      { '<leader>gs', vim.cmd.Git, desc = '[g]it [s]tatus (fugitive)' },
      { '<leader>gf', '<cmd>Git fetch<cr>', desc = 'Git fetch' },
      { '<leader>gp', '<cmd>Git! push --force-with-lease -u origin <cr>', desc = '[G]it [P]ush force with lease' },
      { '<leader>gP', '<cmd>Git! pull --rebase <cr>', desc = '[G]it [P]ull rebase' },
      { '<leader>gc', '<cmd>Git commit<cr>', desc = '[G]it [c]ommit' },
      { '<leader>gu', '<cmd>Git reset HEAD~1<cr>', desc = '[G]it [u]ndo last commit' },
    },
  },
  {
    'rhysd/git-messenger.vim',
    keys = { { '<leader>gm', ':GitMessenger<CR>', desc = '[G]it [M]essenger' } },
  },
  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      { '<leader>gdf', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it [D]iff [F]ile history (this file)' },
      { '<leader>gdl', ':DiffviewFileHistory', desc = '[G]it [D]iff History ([l]ine evolution)', mode = { 'n', 'v' } },
      { '<leader>gdb', ':DiffviewFileHistory', desc = '[G]it [D]iff History (this [b]ranch)' },

      { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff [O]pen (merge conflicts)' },
      { '<leader>gdB', '<cmd>DiffviewOpen origin/main...HEAD', desc = '[G]it [D]iff merge [B]ase' },
      { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = '[G]it [D]iff [C]lose' },
      -- { '<leader>gdl', ':AdvancedGitSearch diff_commit_line<cr>', mode = { 'n', 'v' }, desc = '[G]it [D]iff [L]ine' },
      -- Examples
      -- :DiffviewOpen
      -- :DiffviewOpen HEAD~2
      -- :DiffviewOpen HEAD~4..HEAD~2
      -- :DiffviewOpen d4a7b0d
      -- :DiffviewOpen d4a7b0d^!
      -- :DiffviewOpen d4a7b0d..519b30e
      -- :DiffviewOpen origin/main...HEAD
      --
      -- Additional commands for convenience
      -- :DiffviewClose: Close the current diffview. You can also use :tabclose.
      -- :DiffviewToggleFiles: Toggle the file panel.
      -- :DiffviewFocusFiles: Bring focus to the file panel.
      -- :DiffviewRefresh: Update stats and entries in the file list of the current Diffview.
      --
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
      { '<leader>gR', ':AdvancedGitSearch checkout_reflog<cr>', desc = '[G]it [R]eflog' },
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
    },
  },
}
