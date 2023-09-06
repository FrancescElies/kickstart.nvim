vim.keymap.set('n', '<leader>g-', ':Git stash <cr>')
vim.keymap.set('n', '<leader>g=', ':Git stash pop <cr>')
vim.keymap.set('n', '<leader>gP', ':Git pull --rebase <cr>')
vim.keymap.set('n', '<leader>gR', ':GRemove ')
vim.keymap.set('n', '<leader>ga', ':Git add %:p ')
vim.keymap.set('n', '<leader>gb', ':Git branch ')
vim.keymap.set('n', '<leader>gB', ':Git blame <cr>')
vim.keymap.set('n', '<leader>gc', ':Git commit <cr>')
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit <cr>')
vim.keymap.set('n', '<leader>gg', vim.cmd.Git, { desc = '[G]it status' })
vim.keymap.set('n', '<leader>gl', ':Gclog <cr>')
vim.keymap.set('n', '<leader>gm', ':Gmove ')
vim.keymap.set('n', '<leader>gn', ':Git branch ')
vim.keymap.set('n', '<leader>go', ':Git checkout ')
vim.keymap.set('n', '<leader>gp', ':Git push <cr>')
vim.keymap.set('n', '<leader>gr', ':Gread <cr>')
vim.keymap.set('n', '<leader>gw', ':Gwrite <cr>')

return {
  { 'tpope/vim-fugitive' },
  -- GitHub extension for fugitive.vim
  { 'tpope/vim-rhubarb' },
  -- Azure DevOps extension for fugitive.vim
  { 'cedarbaum/fugitive-azure-devops.vim' },
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
        map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[H]unk [R]eset Selection' })

        map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[H]unk s[t]age Selection' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage Buffer' })

        map('n', '<leader>hr', gs.reset_buffer, { desc = '[H]unk [R]eset Buffer' })

        map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk Preview' })

        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = '[H]unk [B]lame' })

        map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff' })
        map('n', '<leader>hD', function() gs.diffthis '~' end, { desc = '[D]iff' })

        map('n', '<leader>vb', gs.toggle_current_line_blame, { desc = '[Vim] toggle git [B]lame line' })
        map('n', '<leader>vd', gs.toggle_deleted, { desc = '[V]im toggle git [D]eleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
  {

    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim', -- optional
    },
    config = true,
    keys = {
      { '<leader>gS', ":lua require('neogit').open()<CR>", desc = 'Neo[G]it [S]tatus' },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
