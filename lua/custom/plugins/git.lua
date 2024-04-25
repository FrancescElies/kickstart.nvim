-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html

vim.keymap.set('n', '<leader>gz', require('telescope.builtin').git_stash, { desc = 'Git zstash' })

vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit <cr>')
vim.keymap.set('n', '<leader>gL', require('telescope.builtin').git_bcommits, { desc = 'Git List commits current buffer' })
vim.keymap.set('n', '<leader>gl', require('telescope.builtin').git_commits, { desc = 'Git List commits' })

vim.keymap.set('n', '<leader>gp', ':Git push --force-with-lease <cr>')
vim.keymap.set('n', '<leader>gu', ':Git push -u origin<cr>')
vim.keymap.set('n', '<leader>gP', ':Git pull --rebase <cr>')

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
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Next Hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Previous Hunk' })

        -- Actions
        map('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git hunk reset selection' })
        map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset Buffer' })

        map('n', '<leader>ga', gs.stage_hunk, { desc = 'git stage hunk' })
        map('v', '<leader>gt', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git stage selection' })
        map('n', '<leader>gT', gs.stage_buffer, { desc = 'git hunk stage buffer' })

        map('n', '<leader>gp', gs.preview_hunk, { desc = 'git preview hunk' })

        map('n', '<leader>gB', function()
          gs.blame_line { full = true }
        end, { desc = 'git blame line' })

        -- map('n', '<leader>gd', gs.diffthis, { desc = 'git diff this' })

        -- Controlling Vim Git global behaviour
        map('n', '<leader>vb', gs.toggle_current_line_blame, { desc = 'Git toggle git Blame line' })
        map('n', '<leader>vd', gs.toggle_deleted, { desc = 'Git  toggle git Deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
  {
    'rhysd/git-messenger.vim',
    keys = { { '<leader>gm', ':GitMessenger<CR>', desc = 'git messenger' } },
  },
  { 'sindrets/diffview.nvim' },
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
    keys = { { '<leader>gS', ':AdvancedGitSearch<CR>', desc = 'git messenger' } },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
    },
  },
}
