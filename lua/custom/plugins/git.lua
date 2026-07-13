-- https://ofirgall.github.io/learn-nvim/chapters/12-git.html
-- practical.li gitlinker blame.nvim tinygit
--

local tele = require 'telescope.builtin'

-- vimdiff
vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'get left diff' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'get right diff' })

vim.keymap.set('n', '<leader>gB', tele.git_branches, { desc = '[g]it [b]ranches' })
vim.keymap.set('n', '<leader>gL', tele.git_commits, { desc = '[g]it [l]og (cwd)' })
vim.keymap.set('n', '<leader>gl', tele.git_bcommits, { desc = '[g]it [l]og buffer' })
vim.keymap.set('n', '<leader>gs', tele.git_status, { desc = '[g]it [s]tatus' })
vim.keymap.set('n', '<leader>gz', tele.git_stash, { desc = '[g]it [z]stash' })
vim.keymap.set('n', '<leader>gu', '<cmd>Git pull<cr>', { desc = '[g]it [p]ull' })
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<cr>', { desc = '[g]it [p]ush' })
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<cr>', { desc = '[g]it [p]ush' })

--- Lists commits for a range of lines in the current buffer with diff preview
vim.keymap.set('v', '<leader>gl', tele.git_bcommits_range, { desc = '[g]it [l]og (sel. lines)' })

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

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
local gitsigns = require 'gitsigns'
gitsigns.setup {
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
    if vim.wo.diff then
      map('n', '<c-j>', function() vim.cmd.normal { ']c', bang = true } end, { desc = 'Jump to next hunk' })
      map('n', '<c-k>', function() vim.cmd.normal { '[c', bang = true } end, { desc = 'Jump to previous hunk' })
    else
      map('n', ']h', function() gitsigns.nav_hunk 'next' end, { desc = 'Jump to next [h]unk' })
      map('n', '[h', function() gitsigns.nav_hunk 'prev' end, { desc = 'Jump to previous [h]unk' })
      vim.keymap.set('n', '<c-h>', '<cmd>Gitsigns prev_hunk<cr>')
      vim.keymap.set('n', '<c-l>', '<cmd>Gitsigns next_hunk<cr>')
    end

    map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[h]unk [s]tage' })
    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[h]unk [r]eset' })

    map('n', '<leader>hb', gitsigns.blame, { desc = '[h]unk [b]lame [b]uffer' })
    map('n', '<leader>hi', gitsigns.toggle_current_line_blame, { desc = '[h]unk toggle [i]nline blame' })
    map('n', '<leader>hd', gitsigns.preview_hunk_inline, { desc = '[h]unk toggle [d]eleted' })
    map('n', '<leader>hdh', function() gitsigns.diffthis '@' end, { desc = '[h]unk [d]iff..HEAD' })
    map('n', '<leader>hdi', gitsigns.diffthis, { desc = '[h]unk [d]iff..index' })
    map('n', '<leader>hl', gitsigns.blame_line, { desc = '[h]unk blame [l]ine' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[h]unk [p]review' })
    map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = '[h]unk [q]uickfix Project' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = '[h]unk [q]uickfix ' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[h]unk [R]eset buffer' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[h]unk [r]eset' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[h]unk [S]tage buffer' })
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[h]unk [s]tage' })
    map('n', '<leader>hu', gitsigns.stage_hunk, { desc = '[h]unk [u]ndo stage' })
    map('n', '<leader>hw', gitsigns.toggle_word_diff, { desc = '[h]unk toggle [w]ord diff' })

    -- [h]unk as a vim text object
    vim.keymap.set({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>')
  end,
}
vim.pack.add { 'https://github.com/tpope/vim-fugitive' }
vim.keymap.set('n', ',g', '<cmd>tabnew|G<cr><c-w>o', { desc = 'git status' })

vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }
vim.keymap.set('n', '<leader>db', '<cmd>DiffviewFileHistory<cr>', { desc = '[d]iff history [b]ranch' })
vim.keymap.set('n', '<leader>df', '<cmd>DiffviewFileHistory %<cr>', { desc = '[d]iff history [f]ile' })
vim.keymap.set('n', '<leader>dl', '<cmd>.DiffviewFileHistory<cr>', { desc = '[d]iff history ([l]ine evolution)' })
vim.keymap.set('v', '<leader>dl', '<cmd>DiffviewFileHistory<cr>', { desc = '[d]iff history ([l]ine evolution)' })
vim.keymap.set('n', '<leader>dw', '<cmd>DiffviewOpen<cr>', { desc = '[d]iff [w]orking tree' })
vim.keymap.set('n', '<leader>dm', '<cmd>DiffviewOpen origin/main...HEAD', { desc = '[d]iff [m]erge-base' })
vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<cr>', { desc = '[d]iff [c]lose' })

-- Open current file+line in Azure DevOps (PR diff if PR exists, else file view)
local function open_in_azdo()
  local cwd = vim.fn.expand '%:p:h'
  local file = vim.fn.expand '%:p'
  local line = vim.fn.line '.'

  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { cwd = cwd, text = true }):wait().stdout)
  if not git_root or git_root == '' then
    vim.notify('Not inside a git repo', vim.log.levels.WARN)
    return
  end

  -- Normalise path and make relative
  local rel_path = '/' .. file:sub(#git_root + 2):gsub('\\', '/')

  local org = os.getenv 'ORG'
  local project = os.getenv 'PROJECT'
  local repo = os.getenv 'REPO'
  if org == nil or project == nil or repo == nil then
    vim.notify('cwd=' .. vim.fn.getcwd() ' org=' .. org or '<nil>' .. ' project=' .. project or '<nil>' .. ' repo=' .. repo or '<nil>', vim.log.levels.ERROR)
    return
  end

  -- strip trailing .git if present
  repo = repo:gsub('%.git$', ''):gsub('%s+$', '')

  -- find open PR for this branch
  local branch = vim.trim(vim.system({ 'git', 'branch', '--show-current' }, { cwd = cwd, text = true }):wait().stdout)
  local pr_id = vim.trim(vim.system({ 'az', 'repos', 'pr', 'list', '--source-branch', branch, '--query', '[0].pullRequestId', '-o', 'tsv' }):wait().stdout)

  local url
  if pr_id and pr_id:match '^%d+$' then
    url = string.format('https://dev.azure.com/%s/%s/_git/%s/pullrequest/%s?_a=files&path=%s', org, project, repo, pr_id, rel_path)
  else
  vim.notify('No PR found ', vim.log.levels.WARN)
    url = string.format(
      'https://dev.azure.com/%s/%s/_git/%s?path=%s&version=GB%s&line=%d&lineEnd=%d&lineStartColumn=1&_a=contents',
      org,
      project,
      repo,
      rel_path,
      branch,
      line,
      line
    )
  end

  if vim.fn.has 'win32' == 1 then url = url:gsub('&', '^&') end
  vim.ui.open(url)
  vim.notify('Opened in browser: ' .. url)
end
vim.keymap.set('n', '<leader>go', open_in_azdo, { desc = '[g]it [o]pen in browser (az devops)' })

local function diff_orig() vim.cmd [[vert new | set buftype=nofile | read ++edit # | 0d_  | diffthis | wincmd p | diffthis]] end
vim.keymap.set('n', '<leader>do', diff_orig, { desc = '[d]iff [o]riginal (disk-file)' })
vim.api.nvim_create_user_command('DiffOrig', diff_orig, {})

-- return {
--
--   {
--     'aaronhallaert/advanced-git-search.nvim',
--     diff_plugin = 'diffview',
--     config = function()
--       -- NOTE: optionally setup telescope before loading the extension, don't do here see docs
--       require('telescope').load_extension 'advanced_git_search'
--     end,
--     keys = {
--       { '<leader>g//', ':AdvancedGitSearch<CR>', desc = '[g]it [s]earch' },
--       { '<leader>g/l', ':AdvancedGitSearch diff_commit_line<cr>', mode = { 'n', 'v' }, desc = '[g]it [d]iff [l]ine' },
--       { '<leader>g/r', ':AdvancedGitSearch checkout_reflog<cr>', desc = '[g]it [r]eflog' },
--     },
--   },
--   {
--     'folke/snacks.nvim',
--     ---@type snacks.Config
--     opts = {
--       gitbrowse = {},
--     },
--     keys = {
--       { '<leader>gwr', function() Snacks.gitbrowse() end, desc = 'opens current file in browser', mode = { 'n', 'v' } },
--       { '<leader>gwo', function() Snacks.gitbrowse.open() end, desc = 'opens url in nvim (switches to branch/commit)', mode = { 'n', 'v' } },
--     },
--   },
-- }
