local opts = { noremap = false, silent = false }

return {
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
        map('n', '<leader>gr', gs.reset_hunk, { desc = '[G]it Hunk [R]eset' })
        map('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[G]it Hunk Reset Selection' })
        map('n', '<leader>gs', gs.stage_hunk, { desc = '[G]it Hunk [S]tage' })
        map('v', '<leader>gs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[G]it Hunk Stage Selection' })

        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'Hunk Diff' })

        map('n', '<leader>gS', gs.stage_buffer, { desc = '[G]it [S]tage Buffer' })
        map('n', '<leader>gu', gs.undo_stage_hunk, { desc = '[G]it Hunk [U]ndo Stage' })
        map('n', '<leader>gR', gs.reset_buffer, { desc = '[G]it [R]eset Buffer' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = '[G]it Hunk Preview' })
        map('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'Hunk blame' })
        map('n', '<leader>gd', gs.diffthis, { desc = '[G]it Hunk [D]iff' })

        map('n', '<leader>vb', gs.toggle_current_line_blame, { desc = '[V]im toggle git [B]lame' })
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
