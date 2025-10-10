-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html
-- practical.li gitlinker blame.nvim tinygit
--

local tele = require 'telescope.builtin'

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

vim.keymap.set('n', '<leader>gB', tele.git_branches, { desc = '[g]it [b]ranches' })
vim.keymap.set('n', '<leader>glb', tele.git_bcommits, { desc = '[g]it [l]og [b]uffer' })
vim.keymap.set('n', '<leader>gll', tele.git_commits, { desc = '[g]it [l]og' })
--- Lists commits for a range of lines in the current buffer with diff preview
vim.keymap.set('v', '<leader>gll', tele.git_bcommits_range, { desc = '[g]it [l]og' })
-- stylua: ignore
vim.keymap.set('n', '<leader>gz', tele.git_stash, { desc = '[g]it zstash' })

vim.api.nvim_create_autocmd('BufEnter', {
  group = 'markdown',
  pattern = '*COMMIT*',
  callback = function(_)
    print 'gitcommit keymap leader i'
    vim.keymap.set('n', 'is', 'istoFya #$', { desc = '[i]nsert story' })
  end,
})

--
return {
  -- {
  --   'kdheepak/lazygit.nvim',
  --   lazy = true,
  --   cmd = {
  --     'LazyGit',
  --     'LazyGitConfig',
  --     'LazyGitCurrentFile',
  --     'LazyGitFilter',
  --     'LazyGitFilterCurrentFile',
  --   },
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   keys = {
  --     { '<leader>gs', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  --   },
  -- },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    keys = { { '<leader>gs', vim.cmd.Neogit, desc = '[g]it [s]status' } },
  },
  -- {
  --   'tpope/vim-fugitive',
  --   -- opts = {},
  --   cmd = {
  --     'G',
  --     'Git',
  --     'Gdiffsplit',
  --     'Gread',
  --     'Gwrite',
  --     'Ggrep',
  --     'GMove',
  --     'GDelete',
  --     'GBrowse',
  --     'GRemove',
  --     'GRename',
  --     'Glgrep',
  --     'Gedit',
  --   },
  --   ft = { 'fugitive' },
  --   keys = {
  --     { '<leader>gb', '<cmd>Git blame<cr>', desc = 'Git blame' },
  --     -- { '<leader>ga', '<cmd>Gwrite<cr>', desc = 'Git add current file' },
  --     -- { '<leader>gr', '<cmd>Gread<cr>', desc = 'Git restore current file' },
  --     { '<leader>gs', vim.cmd.Git, desc = '[g]it [s]tatus (fugitive)' },
  --     { '<leader>gf', '<cmd>Git fetch<cr>', desc = 'Git fetch' },
  --     { '<leader>gp', '<cmd>Git! push --force-with-lease -u origin <cr>', desc = '[g]it [p]ush force with lease' },
  --     { '<leader>gP', '<cmd>Git! pull --rebase <cr>', desc = '[g]it [p]ull rebase' },
  --     { '<leader>gc', '<cmd>Git commit<cr>', desc = '[g]it [c]ommit' },
  --     { '<leader>gu', '<cmd>Git reset HEAD~1', desc = '[g]it [u]ndo commit (reset HEAD~1)' },
  --   },
  -- },
  {
    'rhysd/git-messenger.vim',
    cmd = { 'GitMessenger' },
    keys = { { '<leader>gm', ':GitMessenger<CR>', desc = '[g]it [m]essenger' } },
  },
  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      -- :h diff-mode
      -- :h copy-diffs
      { '<leader>ghb', ':DiffviewFileHistory<cr>', desc = '[g]it diff [H]istory current [b]ranch' },
      { '<leader>ghf', '<cmd>DiffviewFileHistory %', desc = '[g]it diff [H]istory [f]ile' },
      { '<leader>gdw', '<cmd>DiffviewOpen<cr>', desc = '[g]it [d]iff working tree' },
      { '<leader>ghl', ':DiffviewFileHistory', desc = '[g]it diff [H]istory ([l]ine evolution)', mode = { 'v' } },

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
      { '<leader>g/', ':AdvancedGitSearch<CR>', desc = '[g]it [s]earch' },
      { '<leader>gdl', ':AdvancedGitSearch diff_commit_line<cr>', mode = { 'n', 'v' }, desc = '[g]it [d]iff [l]ine' },
      { '<leader>gr', ':AdvancedGitSearch checkout_reflog<cr>', desc = '[g]it [r]eflog' },
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
    },
  },
}
