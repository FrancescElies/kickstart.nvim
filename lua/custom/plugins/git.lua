vim.keymap.set('n', '<leader>gg', vim.cmd.Git, { desc = '[G]it (fugitive)' })

local cesc_fugitive = vim.api.nvim_create_augroup('cesc_fugitive', {})

vim.keymap.set('n', '<leader>gc', ':Git checkout ', { desc = '[G]it [C]heckout' })
vim.keymap.set('n', '<leader>gp', ':Git push  -u origin ', { desc = '[G]it [P]ush', buffer = bufnr, remap = false })
vim.keymap.set('n', '<leader>gP', ':Git pull --rebase ', { desc = '[G]it [P]ull rebase', buffer = bufnr, remap = false })

return {
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
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
        map('n', '<leader>gr', gs.reset_hunk, { desc = '[G]it Hunk [R]eset' })
        map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
          { desc = '[G]it Hunk Reset Selection' })

        map('n', '<leader>gs', gs.stage_hunk, { desc = '[G]it Hunk [S]tage' })
        map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
          { desc = '[G]it Hunk Stage Selection' })
        map('n', '<leader>gS', gs.stage_buffer, { desc = '[G]it [S]tage Buffer' })

        map('n', '<leader>gR', gs.reset_buffer, { desc = '[G]it [R]eset Buffer' })

        map('n', '<leader>gh', gs.preview_hunk, { desc = '[G]it [H]unk Preview' })

        map('n', '<leader>gB', function() gs.blame_line { full = true } end, { desc = '[G]it Hunk [B]lame' })
        map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = '[G]it [B]lame line' })

        map('n', '<leader>gd', gs.diffthis, { desc = '[G]it Hunk [D]iff' })
        map('n', '<leader>gD', function() gs.diffthis '~' end, { desc = '[G]it [D]iff' })

        map('n', '<leader>vd', gs.toggle_deleted, { desc = '[V]im toggle git [D]eleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
  {

    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',         -- required
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim',        -- optional
    },
    config = true,
    keys = {
      { '<leader>gG', ":lua require('neogit').open()<CR>", desc = 'Neo[G]it' },
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
