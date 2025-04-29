-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html

vim.keymap.set('n', '<leader>gz', require('telescope.builtin').git_stash, { desc = 'Git zstash' })

vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit <cr>')
vim.keymap.set('n', '<leader>gL', require('telescope.builtin').git_bcommits, { desc = 'Git List commits current buffer' })
vim.keymap.set('n', '<leader>gl', require('telescope.builtin').git_commits, { desc = 'Git List commits' })

vim.api.nvim_create_augroup('my_git_commands', { clear = true })

return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    keys = { { '<leader>gs', vim.cmd.Neogit, desc = 'git status' } },
  },
  -- {
  --   'tpope/vim-fugitive',
  --   keys = {
  --     { '<leader>gs', vim.cmd.Git, desc = 'git status' }
  --     { '<leader>gP', ':Git! push --force-with-lease -u origin <cr>', desc = 'git push force with lease' }
  --     { '<leader>gp', ':Git! pull --rebase <cr>', desc = 'git pull rebase' }
  --   },
  -- },
  {
    'rhysd/git-messenger.vim',
    keys = { { '<leader>gm', ':GitMessenger<CR>', desc = 'git messenger' } },
  },
  {
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>df', ':DiffviewFileHistory %<cr>', desc = '[d]iff [f]ile history' },
      { '<leader>db', ':DiffviewFileHistory <cr>', desc = '[d]iff current [b]ranch' },
      { '<leader>do', ':DiffviewOpen origin/main...HEAD -- ./ <cr>', desc = '[d]iff current [b]ranch' },
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
      -- optional: setup telescope before loading the extension
      require('telescope').setup {
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            -- See Config
          },
        },
      }

      require('telescope').load_extension 'advanced_git_search'
    end,
    keys = {
      { '<leader>gS', ':AdvancedGitSearch<CR>', desc = 'git search' },
      { '<leader>g/', ':AdvancedGitSearch<CR>', desc = 'git search' },
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
    },
  },
}
