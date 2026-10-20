local fn = require 'custom.fn'

-- :MasonInstall bacon bacon-ls

-- vim.pack.add {
--   fn.gh 'Canop/nvim-bacon',
-- }
-- require('bacon').setup {
--   quickfix = {
--     enabled = true, -- populate the quickfix list with bacon errors
--     event_trigger = true, -- triggers the QuickFixCmdPost event after populating the quickfix list
--   },
-- }

vim.api.nvim_create_user_command(
  'RustLspCheckOnSaveClippy',
  function() vim.cmd.RustAnalyzer { 'config', "{ checkOnSave = true, check = { command = 'clippy' }  }" } end,
  {}
)
vim.api.nvim_create_user_command(
  'RustLspCheckOnSaveCheck',
  function() vim.cmd.RustAnalyzer { 'config', "{ checkOnSave = true, check = { command = 'check' } }" } end,
  {}
)
vim.api.nvim_create_user_command('RustLspCheckOnSaveDisabled', function() vim.cmd.RustAnalyzer { 'config', '{ checkOnSave = false }' } end, {})

-- https://tree-sitter.github.io/tree-sitter/using-parsers/queries/1-syntax.html

-- vim.api.nvim_create_user_command("CargoTest", function()
--   vim.fn.setqflist({}, ' ', {
--     title = 'cargo test',
--     lines = vim.fn.systemlist('cargo test --message-format=short'),
--   })
--   vim.cmd('copen')
-- end, {})

---@param bufnr integer
local function find_unwraps(bufnr)
  local qf = {}
  bufnr = bufnr or 0
  local query = vim.treesitter.query.parse(
    'rust',
    [[
    ( field_expression field: (field_identifier) @name
      (#eq? @name "unwrap"))
   ]]
  )

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'rust')
  if ok and parser then
    local tree = parser:parse()[1]

    for _, node, _, _ in query:iter_captures(tree:root(), bufnr) do
      local row, col = node:range()
      local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
      local qf_entry = {
        filename = vim.api.nvim_buf_get_name(bufnr),
        lnum = row + 1,
        col = col + 1,
        text = line,
      }
      table.insert(qf, qf_entry)
    end
  end
  return qf
end

local function unwraps_to_qf()
  local qf = find_unwraps(0)
  vim.fn.setqflist(qf)
  vim.cmd 'copen'
end

local function unwraps_in_project_to_qf()
  local qf = {}
  for _, file in ipairs(vim.fn.systemlist 'fd -e rs') do
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)
    local partial_qf = find_unwraps(bufnr)
    for _, qf_entry in ipairs(partial_qf) do
      table.insert(qf, qf_entry)
    end
  end
  vim.fn.setqflist(qf)
  vim.cmd 'copen'
end

---@return vim.quickfix.entry[]
local function rust_functions_and_reflection_calls(arg)
  local target = arg ~= '' and arg or vim.fn.expand '<cword>'
  if target == '' then error 'Usage: :RustFunctionsAndReflectionCalls function_name' end

  local qf = {}

  local scm = ([[
  ; fn TARGET(&self, ...) -> _ {}
  (function_item
      (visibility_modifier)?
      (function_modifiers
        (extern_modifier (_))?)?
      name: (identifier) @name
      (#match? @name "TARGET")) @function

  ; self._.TARGET(_);
  (call_expression
    function: (field_expression
      field: (field_identifier) @name)
    (#match? @name "TARGET")) @function

    ; a_function("TARGET")
    (call_expression
    function: (identifier)
    arguments: (arguments (string_literal (string_content) @name))
                (#match? @name "TARGET")) @expression
  ]]):gsub('TARGET', target)
  local query = vim.treesitter.query.parse('rust', scm)

  for _, file in ipairs(vim.fn.systemlist 'fd -e rs') do
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'rust')
    if ok and parser then
      local tree = parser:parse()[1]

      for _pattern, match, _metadata in query:iter_matches(tree:root(), bufnr, 0, -1) do
        for id, nodes in pairs(match) do
          local name = query.captures[id]
          if name == 'name' then
            for _, node in ipairs(nodes) do
              -- `node` was captured by the `name` capture in the match
              -- local node_data = metadata[id] -- Node level metadata
              local row, col = node:range()
              local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
              -- ... use the info here ...
              table.insert(qf, {
                filename = file,
                lnum = row + 1,
                col = col + 1,
                text = line,
              })
            end
          end
        end
      end
    end
  end

  return qf
end

local function rust_functions_and_reflection_calls_qf(opts)
  opts = opts or {}
  local qf = rust_functions_and_reflection_calls(opts.args)
  vim.fn.setqflist(qf, 'r')
  vim.cmd 'copen'
end
vim.api.nvim_create_user_command('RustFunctionsAndReflectionCalls', rust_functions_and_reflection_calls_qf, { nargs = '?' })
vim.keymap.set('n', '<localleader>R', rust_functions_and_reflection_calls_qf, { desc = '[r]efernces & [r]eflection calls' })

vim.api.nvim_create_user_command('RustStdDocs', function() vim.system { 'rustup', 'doc' } end, {})

local test_buf
local fail_ns = vim.api.nvim_create_namespace 'cargo-test-fail'
local function tests_to_qf(buf)
  local root = vim.fs.dirname(vim.fn.systemlist('cargo locate-project --workspace --message-format plain')[1] or '')
  local items = {}
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local hl = vim.api.nvim_get_hl(0, { name = 'DiagnosticError', link = false })
  hl.italic = true
  vim.api.nvim_set_hl(0, 'CargoTestFail', hl)
  for i, line in ipairs(lines) do
    -- panics: `panicked at src/x.rs:12:5:`; compile errors (--message-format=short): `src/x.rs:3:5: error...`
    local f, l, c = line:match 'panicked at ([^:]+):(%d+):(%d+)'
    local panic = f ~= nil
    local text = f and line
    local msg
    if panic then
      -- the panic message follows on the next lines, up to a blank line or `note:`
      local parts = {}
      for j = i + 1, #lines do
        if lines[j] == '' or lines[j]:match '^note:' then break end
        table.insert(parts, vim.trim(lines[j]))
      end
      msg = table.concat(parts, ' ')
      if msg ~= '' then text = line .. ': ' .. msg end
    end
    if not f then
      f, l, c, text = line:match '^(%S-):(%d+):(%d+): (error.*)'
    end
    if f then
      if not vim.uv.fs_stat(f) and root then f = vim.fs.joinpath(root, f) end
      table.insert(items, { filename = f, lnum = tonumber(l), col = tonumber(c), text = text })
      if panic then
        local b = vim.fn.bufadd(f)
        vim.fn.bufload(b)
        pcall(vim.api.nvim_buf_set_extmark, b, fail_ns, tonumber(l) - 1, 0, { virt_text = { { ' ❌ failed' .. (msg ~= '' and ': ' .. msg or ''), 'CargoTestFail' } } })
      end
    end
  end
  vim.fn.setqflist({}, 'r', { title = 'cargo test', items = items })
  vim.cmd 'cwindow'
end

local test_job
local function cargo_test(filter)
  if test_job then vim.fn.jobstop(test_job) end
  for _, b in ipairs(vim.api.nvim_list_bufs()) do vim.api.nvim_buf_clear_namespace(b, fail_ns, 0, -1) end
  if test_buf and vim.api.nvim_buf_is_valid(test_buf) then vim.api.nvim_buf_delete(test_buf, { force = true }) end
  vim.cmd 'botright 3new'
  local buf, win = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
  test_buf = buf
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].buflisted = false -- keep it out of sessions
  vim.bo[buf].bufhidden = 'hide'
  -- stream output into the buffer: chunk[1] continues the last line
  local function append(_, chunk)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    chunk = vim.tbl_map(function(l) return (l:gsub('\r', '')) end, chunk)
    local n = vim.api.nvim_buf_line_count(buf)
    local last = vim.api.nvim_buf_get_lines(buf, n - 1, n, false)[1]
    chunk[1] = last .. chunk[1]
    vim.api.nvim_buf_set_lines(buf, n - 1, n, false, chunk)
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 }) end
  end
  local cmd = { 'cargo', 'test', '--message-format=short' }
  if filter ~= '' then table.insert(cmd, filter) end
  vim.list_extend(cmd, { '--', '--nocapture' })
  test_job = vim.fn.jobstart(cmd, {
    on_stdout = append,
    on_stderr = append,
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end -- buffer stays, only the window closes
      if vim.api.nvim_buf_is_valid(buf) then tests_to_qf(buf) end
    end,
  })
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.rs', '*.toml' },
  group = vim.api.nvim_create_augroup('my-rust-bacon', { clear = true }),
  callback = function(event)
    local nkeymap = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc }) end
    -- nkeymap('!', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', 'bacon: next issue')
    -- nkeymap(',,', '<cmd>BaconList<cr>', 'bacon: load then show')
    -- nkeymap('<localleader>b', function()
    --   -- vim.lsp.buf.execute_command({ command = "bacon_ls.run" })
    --   -- TODO: repalce code below with a fixed version of:
    --   -- vim.lsp.get_clients({name = "bacon_ls"})[1]:exec_cmd {title = 'run', command= 'run'}
    --   local command_params = {
    --     command = 'bacon_ls.run',
    --     arguments = nil,
    --     workDoneToken = nil,
    --   }
    --   vim.lsp.buf_request(0, 'workspace/executeCommand', command_params)
    -- end, 'bacon-ls: run check')
    nkeymap('<localleader>u', unwraps_to_qf, 'Find unwrap() calls')
    nkeymap('<localleader>U', unwraps_in_project_to_qf, 'Find unwrap() calls')
    nkeymap('<localleader>rd', '<cmd>RustStdDocs<cr>', 'rust docs')
    nkeymap('<localleader>tt', function()
      local node = vim.treesitter.get_node()
      while node and node:type() ~= 'function_item' do
        node = node:parent()
      end
      local prev = node and node:prev_named_sibling()
      local is_test = prev and prev:type() == 'attribute_item' and vim.treesitter.get_node_text(prev, 0):find 'test'
      -- not on a #[test] fn: fall back to the file's tests
      cargo_test(is_test and vim.treesitter.get_node_text(node:field('name')[1], 0) or vim.fn.expand '%:t:r')
    end, 'rust: cargo test fn under cursor')
    nkeymap('<localleader>tf', function() cargo_test(vim.fn.expand '%:t:r') end, 'rust: cargo test file')
    nkeymap('<localleader>ta', function() cargo_test '' end, 'rust: cargo test all')
  end,
})
