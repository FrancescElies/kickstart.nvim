local fn = require 'custom.fn'

-- :MasonInstall bacon bacon-ls

vim.pack.add {
  fn.gh 'Canop/nvim-bacon',
}
require('bacon').setup {
  quickfix = {
    enabled = true, -- populate the quickfix list with bacon errors
    event_trigger = true, -- triggers the QuickFixCmdPost event after populating the quickfix list
  },
}

vim.keymap.set('n', '<localleader>c', function()
  -- vim.lsp.buf.execute_command({ command = "bacon_ls.run" })
  -- TODO: repalce code below with a fixed version of:
  -- vim.lsp.get_clients({name = "bacon_ls"})[1]:exec_cmd {title = 'run', command= 'run'}
  local command_params = {
    command = 'bacon_ls.run',
    arguments = nil,
    workDoneToken = nil,
  }
  vim.lsp.buf_request(0, 'workspace/executeCommand', command_params)
end, { desc = 'bacon-ls: run check' })

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.rs', '*.toml' },
  group = vim.api.nvim_create_augroup('my-rust-bacon', { clear = true }),
  callback = function(event)
    local nkeymap = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'bacon: ' .. desc }) end
    nkeymap('!', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', 'next bacon issue')
    nkeymap(',,', ':BaconList<CR>', 'bacon load then show')
  end,
})
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

vim.keymap.set('n', '<leader>cu', unwraps_to_qf, { desc = 'Find unwrap() calls' })
vim.keymap.set('n', '<leader>cU', unwraps_in_project_to_qf, { desc = 'Find unwrap() calls' })

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
      local root = tree:root()

      for pattern, match, metadata in query:iter_matches(tree:root(), bufnr, 0, -1) do
        for id, nodes in pairs(match) do
          local name = query.captures[id]
          if name == 'name' then
            for _, node in ipairs(nodes) do
              -- `node` was captured by the `name` capture in the match
              local node_data = metadata[id] -- Node level metadata
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

vim.api.nvim_create_user_command('RustFunctionsAndReflectionCalls', function(opts)
  local qf = rust_functions_and_reflection_calls(opts.args)
  vim.fn.setqflist(qf, 'r')
  vim.cmd 'copen'
end, {
  nargs = '?',
})
