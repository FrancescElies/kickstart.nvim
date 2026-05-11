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
  local query = vim.treesitter.query.parse("rust", [[
    ( field_expression field: (field_identifier) @name
      (#eq? @name "unwrap"))
   ]])

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "rust")
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
  vim.cmd("copen")
end

local function unwraps_in_project_to_qf()
  local qf = {}
  for _, file in ipairs(vim.fn.systemlist("fd -e rs")) do
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)
    local partial_qf = find_unwraps(bufnr)
    for _, qf_entry in ipairs(partial_qf) do
      table.insert(qf, qf_entry)
    end
  end
  vim.fn.setqflist(qf)
  vim.cmd "copen"
end

vim.keymap.set("n", "<leader>cu", unwraps_to_qf, { desc = "Find unwrap() calls" })
vim.keymap.set("n", "<leader>cU", unwraps_in_project_to_qf, { desc = "Find unwrap() calls" })

---@return vim.quickfix.entry[]
local function rust_functions_and_reflection_calls(arg)
  local target = arg ~= "" and arg or vim.fn.expand("<cword>")
  if target == "" then
    error("Usage: :RustFunctionsAndReflectionCalls function_name")
  end

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
  ]]):gsub("TARGET", target)
  local query = vim.treesitter.query.parse("rust", scm)

  for _, file in ipairs(vim.fn.systemlist("fd -e rs")) do
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "rust")
    if ok and parser then
      local tree = parser:parse()[1]
      local root = tree:root()

      for pattern, match, metadata in query:iter_matches(tree:root(), bufnr, 0, -1) do
        for id, nodes in pairs(match) do
          local name = query.captures[id]
          if name == "name" then
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

vim.api.nvim_create_user_command("RustFunctionsAndReflectionCalls", function(opts)
  local qf = rust_functions_and_reflection_calls(opts.args)
  vim.fn.setqflist(qf, "r")
  vim.cmd("copen")
end, {
  nargs = "?",
})


return {
  {
    'Canop/nvim-bacon',
    config = function()
      vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
        pattern = { '*.rs', '*.toml' },
        group = vim.api.nvim_create_augroup('my-rust-bacon', { clear = true }),
        callback = function(event)
          local nkeymap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'bacon: ' .. desc })
          end
          nkeymap('!', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', 'next bacon issue')
          nkeymap(',,', ':BaconList<CR>', 'bacon list')
        end,
      })
    end,
  },
  {
    --   disable rust-analyzer in lsp-init.lua if this plugin enabled
    'mrcjkb/rustaceanvim',
    version = '^9',
    lazy = false, -- This plugin is already lazy

    config = function()
      -- You only need to specify the keys that you want to be changed, because defaults are applied for keys that are not provided.
      vim.g.rustaceanvim = {
        -- Plugin configuration
        -- tools = {},
        -- LSP configuration
        server = {
          -- on_attach = function(client, bufnr)
          --   -- you can also put keymaps in here
          -- end,
          default_settings = {
            -- https://rust-analyzer.github.io/manual.html
            -- rust-analyzer --print-config-schema
            -- https://rust-analyzer.github.io/book/configuration.html
            -- https://github.com/BurntSushi/dotfiles/blob/a6c516e6c4c7f7afae4f3171be4c5404d367ffbe/.config/ag/nvim/default#L16
            -- see `lsp-init.lua` too
            ['rust-analyzer'] = {
              check = {
                allTargets = true,
                -- features = 'all'
                loadOutDirsFromCheck = true,
              },
              diagnostics = {
                enable = true,
                disabled = {
                  'inactive-code',
                  'incorrect-ident-case',
                  'unlinked-file',
                  'unresolved-macro-call',
                  'unresolved-proc-macro',
                },
                styleLints = { enable = true },
                experimental = { enable = true },
              },
              checkOnSave = false,
              assist = {
                importGranularity = 'module',
                importPrefix = 'by_self',
              },
              inlayHints = {
                enabled = true,
                chainingHints = { enable = false },
                closingBraceHints = { enable = false },
                bindingModeHints = { enable = true },
                closureCaptureHints = { enable = true },
                closureReturnTypeHints = { enable = 'always' },
                expressionAdjustmentHints = { enable = 'always' },
                lifetimeElisionHints = { enable = 'always', useParameterNames = true },
                reborrowHints = { enable = 'always' },
                typeHints = {
                  hideClosureInitialization = true,
                  hideNamedConstructor = true,
                },
              },
              lens = {
                enable = true,
                references = {
                  adt = { enable = true },    -- structs/enums/unions
                  enumVariant = { enable = true },
                  method = { enable = true }, -- method-level specifically
                  trait = { enable = true },
                },
                updateTest = { enable = true },
                implementations = { enable = true },
                run = { enable = true },   --  ▶ Run button
                debug = { enable = true }, -- ▶ Debug button
              },
            },
          },
        },
        -- DAP configuration
        -- dap = {},
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my-rustaceanvim-lsp-attach', { clear = true }),
        callback = function(event)
          local keymap = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'rust: ' .. desc })
          end

          if vim.bo.filetype == 'rust' then
            keymap('n', '<leader>cC', function()
              vim.cmd.RustAnalyzer { 'config', "{ checkOnSave = { command = 'clippy', enable = true } }" }
            end, '[c]lippy on save')
            keymap('n', '<leader>cc', function()
              vim.cmd.RustAnalyzer { 'config', '{ checkOnSave = true }' }
            end, '[c]heck on save')
            keymap('n', '<leader>cf', '<cmd>RustLsp flyCheck run<cr>', '[f]lycheck (check/clippy)')
            keymap('n', '<leader>ce', ':RustLsp explainError', '[e]xplain error')
            keymap('n', '<leader>cE', '<cmd>RustLsp expandMacro<cr>', '[e]xpand macros')
            keymap('n', 'K', '<cmd>RustLsp hover actions<cr>', '[h]over actions')
            keymap('n', 'J', '<cmd>RustLsp joinLines<cr>', 'join lines')
            keymap('n', '<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
            keymap('n', '<leader>co', '<cmd>RustLsp openCargo<cr>', '[o]pen cargo')
            keymap('n', '<leader>cp', '<cmd>RustLsp parentModule<cr>', '[p]arent module')
            -- keymap('n','<leader>c.', ':RustLsp! testables<cr>', 'run previous [t]ests')
            -- keymap('n','<leader>ct', ':RustLsp testables<cr>', 'run [t]ests')
            -- rust_keymap('n','<leader>cw', ':RustLsp workspaceSymbol allSymbols ', '[w]orkspace symbol')
            keymap('n', '<leader>cg', ':RustLsp crateGraph', 'crate [g]raph')
            -- :RustLsp syntaxTree
            -- :Rustc unpretty {hir|mir|...}
          end
        end,
      })
    end,
  },
}
