-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[G]it [s]tatus' })

vim.keymap.set('n', '<leader>g-', ':Git stash <cr>')
vim.keymap.set('n', '<leader>g=', ':Git stash pop <cr>')

vim.keymap.set('n', '<leader>ga', ':Git add %:p ')
vim.keymap.set('n', '<leader>gB', ':Git branch ')
-- vim.keymap.set('n', '<leader>gB', ':Git blame <cr>')
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit <cr>')
vim.keymap.set('n', '<leader>gl', ':G log <cr>')
vim.keymap.set('n', '<leader>go', ':Git checkout ')

vim.keymap.set('n', '<leader>gp', ':Git push --force-with-lease <cr>')
vim.keymap.set('n', '<leader>gu', ':Git push -u origin<cr>')
vim.keymap.set('n', '<leader>gP', ':Git pull --rebase <cr>')

vim.api.nvim_create_augroup('my_commands', { clear = true })

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'my_commands',
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set('n', '<leader>i', function() vim.cmd.InsertStory() end, opts)
  end,
})

vim.api.nvim_create_user_command('InsertStory', function()
  local buffnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffnr, 0, -1, false)
  for _, line in pairs(lines) do
    local story = string.match(line, '[sS]tory(%d+)')
    if story ~= nil then
      vim.api.nvim_buf_set_lines(buffnr, 2, 2, false, { 'story #' .. story })
    end
    local task = string.match(line, '[Tt]ask(%d+)')
    if task ~= nil then
      vim.api.nvim_buf_set_lines(buffnr, 3, 3, false, { 'task #' .. task })
    end
  end
end, {})

return {
  { 'tpope/vim-fugitive' },
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
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'Next Hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'Previous Hunk' })

        -- Actions
        map('n', '<leader>gr', gs.reset_hunk, { desc = '[g]it [r]eset hunk' })
        map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
          { desc = '[g]it hunk [r]eset selection' })
        map('n', '<leader>gR', gs.reset_buffer, { desc = '[g]it [R]eset Buffer' })

        map('n', '<leader>gt', gs.stage_hunk, { desc = '[g]it s[t]age hunk' })
        map('v', '<leader>gt', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
          { desc = '[g]it s[t]age selection' })
        map('n', '<leader>gT', gs.stage_buffer, { desc = '[g]it hunk s[t]age buffer' })

        map('n', '<leader>gp', gs.preview_hunk, { desc = '[g]it [p]review hunk' })

        map('n', '<leader>gb', function() gs.blame_line { full = true } end, { desc = '[g]it [b]lame line' })

        -- map('n', '<leader>gd', gs.diffthis, { desc = '[g]it [d]iff this' })

        -- Controlling Vim Git global behaviour
        map('n', '<leader>vb', gs.toggle_current_line_blame, { desc = '[G]it toggle git [B]lame line' })
        map('n', '<leader>vd', gs.toggle_deleted, { desc = '[G]it  toggle git [D]eleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'sindrets/diffview.nvim' },
    config = true,
    keys = { { '<leader>gN', ":lua require('neogit').open()<CR>", desc = '[g]it [s]tatus' } },
  },
  {
    'rhysd/git-messenger.vim',
    keys = { { '<leader>gm', ':GitMessenger<CR>', desc = '[g]it [m]essenger' } },
  },
  { 'sindrets/diffview.nvim' },
  {
    'ThePrimeagen/git-worktree.nvim',
    callback = function()
      require('telescope').load_extension 'git_worktree'
      local Worktree = require 'git-worktree'

      -- op = Operations.Switch, Operations.Create, Operations.Delete
      -- metadata = table of useful values (structure dependent on op)
      --      Switch
      --          path = path you switched to
      --          prev_path = previous worktree path
      --      Create
      --          path = path where worktree created
      --          branch = branch name
      --          upstream = upstream remote name
      --      Delete
      --          path = path where worktree deleted

      Worktree.on_tree_change(function(op, metadata)
        if op == Worktree.Operations.Switch then
          print('Switched from ' .. metadata.prev_path .. ' to ' .. metadata.path)
        end
      end)
    end,
    keys = {
      {
        '<leader>gws',
        ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
        desc = '[g]it [w]orkspace [s]earch',
      },
      -- <Enter> - switches to that worktree
      -- <c-d> - deletes that worktree
      -- <c-f> - toggles forcing of the next deletion
      {
        '<leader>gwc',
        ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
        desc = '[g]it [w]orkspace [c]reate',
      },
    },
  },
}
