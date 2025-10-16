-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html
-- practical.li gitlinker blame.nvim tinygit
--

local tele = require 'telescope.builtin'

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

vim.keymap.set('n', '<leader>gb', tele.git_branches, { desc = '[g]it [b]ranches' })
vim.keymap.set('n', '<leader>gl', tele.git_bcommits, { desc = '[g]it [l]og buffer' })
vim.keymap.set('n', '<leader>gL', tele.git_commits, { desc = '[g]it [l]og (cwd)' })
--- Lists commits for a range of lines in the current buffer with diff preview
vim.keymap.set('v', '<leader>gl', tele.git_bcommits_range, { desc = '[g]it [l]og (sel. lines)' })
-- stylua: ignore
vim.keymap.set('n', '<leader>gz', tele.git_stash, { desc = '[g]it zstash' })

vim.api.nvim_create_autocmd('BufEnter', {
  group = 'markdown',
  pattern = '*COMMIT*',
  callback = function(_)
    print 'gitcommit n-keymap [i]nsert [s]tory: is'
    vim.keymap.set('n', 'is', 'istoFya #$', { desc = '[i]nsert [s]tory' })
  end,
})

--
return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[h]unk [s]tage' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[h]unk [r]eset' })

        -- normal mode
        map('n', '<leader>hb', gitsigns.blame, { desc = '[h]unk [b]lame [b]uffer' })
        map('n', '<leader>hl', gitsigns.blame_line, { desc = '[h]unk blame [l]ine' })
        map('n', '<leader>hq', function()
          gitsigns.setqflist 'all'
        end, { desc = '[h]unk [q]uickfix ' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[h]unk [s]tage' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[h]unk [S]tage buffer' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[h]unk [r]eset' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[h]unk [R]eset buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = '[h]unk [u]ndo stage' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[h]unk [p]review' })
        map('n', '<leader>hdi', gitsigns.diffthis, { desc = '[h]unk [d]iff against index' })
        map('n', '<leader>hdh', function()
          gitsigns.diffthis '@'
        end, { desc = '[h]unk [d]iff with [H]EAD' })

        -- [h]unk as a vim text object
        vim.keymap.set({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>')
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    keys = { { '<leader>gs', vim.cmd.Neogit, desc = '[g]it [s]status' } },
  },
  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      -- :h diff-mode
      -- :h copy-diffs
      { '<leader>db', ':DiffviewFileHistory<cr>', desc = '[d]iff History [b]ranch' },
      { '<leader>df', '<cmd>DiffviewFileHistory %', desc = '[d]iff history [f]ile' },
      { '<leader>d.', '<cmd>DiffviewOpen<cr>', desc = '[d]iff (.) working tree' },
      { '<leader>dl', ':DiffviewFileHistory', desc = '[d]iff history ([l]ine evolution)', mode = { 'v' } },

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
      { '<leader>g//', ':AdvancedGitSearch<CR>', desc = '[g]it [s]earch' },
      { '<leader>g/l', ':AdvancedGitSearch diff_commit_line<cr>', mode = { 'n', 'v' }, desc = '[g]it [d]iff [l]ine' },
      { '<leader>g/r', ':AdvancedGitSearch checkout_reflog<cr>', desc = '[g]it [r]eflog' },
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'sindrets/diffview.nvim',
    },
  },
}
