local fn = require 'custom.fn'

vim.opt_local.foldlevel = 9999
vim.opt_local.wrap = false -- soft-wrap long lines on screen
vim.opt_local.linebreak = true -- break at word boundaries, not mid-word
vim.opt_local.breakindent = true -- wrapped lines keep the indent (lists, quotes)
vim.opt_local.showbreak = '↪ ' -- marker at the start of wrapped lines (optional)

local function file_contains(path, str)
  local ok, lines = pcall(io.lines, path)
  if not ok then return false end
  for line in lines do
    if line:find(str, 1, true) then return true end
  end
  return false
end

-- Switch with :MarkdownConverter makurust|comrak (or vim.g.markdown_converter)
-- makurust: `cargo install --locked --git https://github.com/fromgodd/makurust makurust` (writes <input>.html itself)
-- comrak:   `cargo binstall comrak` (bare fragment, so we prepend CSS to cap image width)
local converters = {
  makurust = {
    cmd = function(input, _) return { 'makurust', input } end,
  },
  comrak = {
    cmd = function(input, output)
      return { 'comrak', '--unsafe', '--syntax-highlighting', 'InspiredGitHub', '-e', 'table,tasklist,strikethrough,autolink', '-o', output, input }
    end,
    post = function(output)
      local f = assert(io.open(output, 'rb'))
      local html = f:read '*a'
      f:close()
      f = assert(io.open(output, 'wb'))
      local name = vim.fs.basename(output) .. '.stamp.js'
      -- polls a sibling stamp file (fetch is blocked on file://) and reloads when it changes
      local js = ('<script>var v;setInterval(function(){var e=document.createElement("script");e.src=%q+"?"+Date.now();e.onload=function(){if(v&&v!=window.__stamp)location.reload();v=window.__stamp;e.remove()};document.head.appendChild(e)},1000)</script>\n'):format(
        name
      )
      -- toc: fixed sidebar built client-side from h1-h3 (hidden on narrow screens)
      local toc =
        [[<script>addEventListener("DOMContentLoaded",function(){var h=document.querySelectorAll("h1,h2,h3");if(h.length<2)return;var n=document.createElement("nav");n.id="toc";h.forEach(function(x,i){x.id=x.id||"h"+i;var a=document.createElement("a");a.href="#"+x.id;a.textContent=x.textContent;a.className=x.tagName.toLowerCase();n.appendChild(a)});document.body.appendChild(n)})</script>
]]
      f:write(
        '<style>body{max-width:60em;margin:2em auto}img{width:100%;height:auto}pre{background:#f3f4f6!important;padding:.6em .8em;border-radius:4px;overflow-x:auto}table{border-collapse:collapse}th,td{border:1px solid #888;padding:.3em .6em}#toc{position:fixed;top:1em;right:1em;width:16em;max-height:90vh;overflow:auto;font-size:.8em;display:none}#toc a{display:block;padding:.1em 0;text-decoration:none}#toc .h2{padding-left:1em}#toc .h3{padding-left:2em}@media(min-width:90em){#toc{display:block}}</style>\n',
        js,
        toc,
        html
      )
      f:close()
      vim.fn.writefile({ 'window.__stamp=' .. vim.uv.hrtime() }, vim.fs.dirname(output) .. '/' .. name)
    end,
  },
}
-- last used converter is persisted across sessions; default comrak
local state_file = vim.fn.stdpath 'state' .. '/markdown_converter'
if not vim.g.markdown_converter then
  local ok, lines = pcall(vim.fn.readfile, state_file)
  local saved = ok and lines[1] or nil
  vim.g.markdown_converter = converters[saved] and saved or 'comrak'
end

local opened = {}

local function start_converter(opts)
  local name = vim.g.markdown_converter
  local conv = converters[name]
  local input = vim.fs.normalize(opts.input)
  local output = vim.fn.fnamemodify(input, ':r') .. '.html'
  local t0 = vim.uv.hrtime()
  vim.fn.jobstart(conv.cmd(input, output), {
    on_exit = function(_, code)
      if code == 0 then
        if conv.post then conv.post(output) end
        vim.notify(('%s: %s (%.1fs)'):format(name, output, (vim.uv.hrtime() - t0) / 1e9), vim.log.levels.INFO)
        -- shortcut: can't detect a real open tab; open once per file per nvim session, the page auto-reloads itself
        if not opened[output] then
          opened[output] = true
          fn.open_in_system_default_app(output)
        end
      else
        vim.notify(name .. ' failed ' .. input .. ' (exit ' .. code .. ')', vim.log.levels.ERROR)
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
        start_converter { input = output }
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
    start_converter { input = input }
  end
end

-- :MarkdownConverter <name> picks the converter and runs it; bare shows the current one
vim.api.nvim_create_user_command('MarkdownConverter', function(o)
  if o.args == '' then return vim.notify('markdown converter: ' .. vim.g.markdown_converter) end
  if not converters[o.args] then return vim.notify('unknown converter ' .. o.args, vim.log.levels.ERROR) end
  vim.g.markdown_converter = o.args
  vim.fn.writefile({ o.args }, state_file)
  md_to_html {}
end, {
  nargs = '?',
  complete = function() return vim.tbl_keys(converters) end,
  desc = 'Choose markdown->html converter and run it',
})
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
