local fn = require 'custom.fn'

local function file_contains(path, str)
  local ok, lines = pcall(io.lines, path)
  if not ok then return false end
  for line in lines do
    if line:find(str, 1, true) then return true end
  end
  return false
end

-- NOTE: needs `cargo install --locked --git https://github.com/fromgodd/makurust makurust`
-- Alternatives:
--   cargo install comrak
--   uv tool install umarkdown[cli]
--   uv tool install grip
local function start_makurust(opts)
  local input = vim.fs.normalize(opts.input)
  vim.fn.jobstart({ 'makurust', input }, {
    on_exit = function(_, code)
      if code == 0 then
        local output = vim.fn.fnamemodify(input, ':r') .. '.html'
        vim.notify('makurust: ' .. output, vim.log.levels.INFO)
        fn.open_in_system_default_app(output)
      else
        vim.notify('makurust failed ' .. input .. ' (exit ' .. code .. ')', vim.log.levels.ERROR)
      end
    end,
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data and #data > 1 then vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR) end
    end,
  })
end

-- NOTE: needs `npm install -g @mermaid-js/mermaid-cli`
local function start_mermaid_cli(opts)
  local input = vim.fs.normalize(opts.input)
  local output = vim.fs.normalize(opts.output)

  vim.fn.jobstart({ 'mmdc', '-i', input, '-o', output }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('mmdc: ' .. output, vim.log.levels.INFO)
        start_makurust { input = output }
      else
        vim.notify('mmdc failed ' .. input .. ' (exit ' .. code .. ')', vim.log.levels.ERROR)
      end
    end,
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data and #data > 1 then vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR) end
    end,
  })
end

local md_to_html = function(opts)
  local input = opts.input or vim.fn.expand '%:p'
  vim.cmd 'write'
  if file_contains(input, 'mermaid') then
    local dir = vim.fn.expand '%:p:h'
    local stem = vim.fn.expand '%:t:r'
    local ext = vim.fn.expand '%:e'
    local output = dir .. '/' .. stem .. '-mmd.' .. ext

    start_mermaid_cli { input = input, output = output }
  else
    start_makurust { input = input }
  end
end

vim.api.nvim_create_user_command('MarkdownToHtml', md_to_html, { desc = 'Compile markdown to html' })
vim.keymap.set('n', '<localleader><localleader>', '<cmd>MarkdownToHtml<cr>', { buffer = 0, desc = 'Compile markdown to html' })

--
-- Azure DevOps
--
do
  -- Open current file+line in Azure DevOps (PR diff if PR exists, else file view)
  local function open_line_in_ado()
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
  vim.api.nvim_create_user_command('OpenLineInAzureDevops', open_line_in_ado, {})
  vim.keymap.set('n', '<localleader>oa', open_line_in_ado, { desc = '[o]pen  [a]zure devops' })
end
