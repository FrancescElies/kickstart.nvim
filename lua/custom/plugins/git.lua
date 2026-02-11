-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html
-- practical.li gitlinker blame.nvim tinygit
--

local tele = require 'telescope.builtin'

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

vim.keymap.set('n', '<leader>gB', tele.git_branches, { desc = '[g]it [b]ranches' })
vim.keymap.set('n', '<leader>gl', tele.git_bcommits, { desc = '[g]it [l]og buffer' })
vim.keymap.set('n', '<leader>gL', tele.git_commits, { desc = '[g]it [l]og (cwd)' })
--- Lists commits for a range of lines in the current buffer with diff preview
vim.keymap.set('v', '<leader>gl', tele.git_bcommits_range, { desc = '[g]it [l]og (sel. lines)' })
vim.keymap.set('n', '<leader>gz', tele.git_stash, { desc = '[g]it zstash' })

local commit_group = vim.api.nvim_create_augroup('my-git-commit', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = commit_group,
  pattern = '*COMMIT*',
  callback = function(_)
    -- vim.notify 'gitcommit n-keymap:\n  - [i]nsert [s]tory\n  - [i]nsert [t]ask'
    vim.keymap.set('n', 'is', 'istoFya #$', { desc = '[i]nsert [s]tory' })
    vim.keymap.set('n', 'it', 'itaskFka #$', { desc = '[i]nsert [t]ask' })
  end,
})

--
return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
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
        map('n', '<M-n>', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '<M-p>', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- stylua: ignore
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[h]unk [s]tage' })
        -- stylua: ignore
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[h]unk [r]eset' })

        -- normal mode
        map('n', '<leader>hB', gitsigns.blame, { desc = '[h]unk [b]lame [b]uffer' })
        map('n', '<leader>hl', gitsigns.blame_line, { desc = '[h]unk blame [l]ine' })
        map('n', '<leader>hq', gitsigns.setqflist, { desc = '[h]unk [q]uickfix ' })
        -- stylua: ignore
        map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = '[h]unk [q]uickfix Project' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[h]unk [s]tage' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[h]unk [S]tage buffer' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[h]unk [r]eset' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[h]unk [R]eset buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = '[h]unk [u]ndo stage' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[h]unk [p]review' })
        -- stylua: ignore
        map('n', '<leader>hdi', gitsigns.diffthis, { desc = '[h]unk [d]iff..index' })
        -- stylua: ignore
        map('n', '<leader>hdh', function() gitsigns.diffthis '@' end, { desc = '[h]unk [d]iff..HEAD' })

        map('n', '<leader>hb', gitsigns.toggle_current_line_blame, { desc = '[h]unk toggle [b]lame' })
        map('n', '<leader>hw', gitsigns.toggle_word_diff, { desc = '[h]unk toggle [w]ord diff' })

        -- [h]unk as a vim text object
        vim.keymap.set({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>')
      end,
    },
  },
  -- {
  --   'NeogitOrg/neogit',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim', -- required
  --     'sindrets/diffview.nvim', -- optional - Diff integration
  --     'nvim-telescope/telescope.nvim', -- optional
  --   },
  --   keys = { { '<leader>gs', vim.cmd.Neogit, desc = '[g]it [s]status' } },
  -- },
  {
    'tpope/vim-fugitive',
    -- opts = {},
    cmd = { 'G', 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse', 'GRemove', 'GRename', 'Glgrep', 'Gedit' },
    ft = { 'fugitive' },
    keys = {
      { '<leader>gb', ':Git blame<cr>', desc = 'Git blame' },
      { '<leader>gc', ':Git commit', desc = 'Git commit' },
      { '<leader>gp', ':Git push<cr>', desc = 'Git commit' },
      { '<leader>g.', ':Git status<cr>', desc = 'Git status' },

      { '<leader>fu', vim.cmd.Git, desc = 'fugitive' },
    },
  },

  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      -- :h diff-mode
      -- :h copy-diffs
      { '<leader>dhb', ':DiffviewFileHistory<cr>', desc = '[d]iff History [b]ranch' },
      { '<leader>dhf', ':DiffviewFileHistory %<cr>', desc = '[d]iff history [f]ile' },
      { '<leader>dhl', ':.DiffviewFileHistory', desc = '[d]iff history ([l]ine evolution)' },
      { '<leader>dhl', ':DiffviewFileHistory', desc = '[d]iff history ([l]ine evolution)', mode = { 'v' } },
      { '<leader>d.', ':DiffviewOpen<cr>', desc = '[d]iff (.) working tree' },
      { '<leader>dm', ':DiffviewOpen origin/main...HEAD', desc = '[d]iff with merge base' },
      { '<leader>dq', ':DiffviewClose<cr>', desc = '[d]iff [q]uit' },

      -- Examples:
      -- :DiffviewOpen
      -- :DiffviewOpen HEAD~2
      -- :DiffviewOpen HEAD~4..HEAD~2
      -- :DiffviewOpen d4a7b0d
      -- :DiffviewOpen d4a7b0d^!
      -- :DiffviewOpen d4a7b0d..519b30e
      -- :DiffviewOpen origin/main...HEAD
      --
      -- Tips:
      -- Hide untracked files: DiffviewOpen -uno
      -- Exclude certain paths: DiffviewOpen -- :!exclude/this :!and/this
      -- Run as if git was started in a specific directory: DiffviewOpen -C/foo/bar/baz
      -- Diff the index against a git rev: DiffviewOpen HEAD~2 --cached
      -- Q: How do I get the diagonal lines in place of deleted lines in diff-mode? (Lua): vim.opt.fillchars:append { diff = "╱" }
      -- Q: How do I jump between hunks in the diff? A: Use [c and ]c :h jumpto-diffs
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
