-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html

vim.keymap.set('n', '<leader>gz', require('telescope.builtin').git_stash, { desc = 'Git zstash' })

vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit <cr>')
vim.keymap.set('n', '<leader>gL', require('telescope.builtin').git_bcommits, { desc = 'Git List commits current buffer' })
vim.keymap.set('n', '<leader>gl', require('telescope.builtin').git_commits, { desc = 'Git List commits' })

vim.keymap.set('n', '<leader>gP', ':Git! push --force-with-lease -u origin <cr>')
vim.keymap.set('n', '<leader>gp', ':Git! pull --rebase <cr>')

vim.api.nvim_create_augroup('my_git_commands', { clear = true })
--
-- start git messages in insert mode
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'bufcheck',
--   pattern = { 'gitcommit', 'gitrebase' },
--   command = 'startinsert | 1',
-- })

local function insert_story()
  local buffnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffnr, 0, -1, false)
  -- vim.api.nvim_buf_set_lines(buffnr, 0, 0, false, { '', '' })
  local done = false
  for _, line in pairs(lines) do
    local story = string.match(line, '[sS]tory(%d+)')
    if story ~= nil then
      vim.api.nvim_buf_set_lines(buffnr, 2, 2, false, { 'story #' .. story })
      done = true
    end
    local task = string.match(line, '[Tt]ask(%d+)')
    if task ~= nil then
      vim.api.nvim_buf_set_lines(buffnr, 3, 3, false, { 'task #' .. task })
      done = true
    end
    if done then
      return
    end
  end
end

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'my_git_commands',
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set('n', '<leader>i', insert_story, opts)
  end,
})

vim.api.nvim_create_user_command('InsertStory', insert_story, {})

return {
  {
    'tpope/vim-fugitive',
    keys = { { '<leader>gs', vim.cmd.Git, desc = 'git status' } },
  },
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
    keys = { { '<leader>gS', ':AdvancedGitSearch<CR>', desc = 'git search' } },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
    },
  },
}
