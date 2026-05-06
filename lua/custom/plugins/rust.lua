-- vim.api.nvim_create_user_command("CargoTest", function()
--   vim.fn.setqflist({}, ' ', {
--     title = 'cargo test',
--     lines = vim.fn.systemlist('cargo test --message-format=short'),
--   })
--   vim.cmd('copen')
-- end, {})


vim.api.nvim_create_user_command("RustFnsNamedAndStringBasedCalls", function(opts)
  local target = opts.args
  if target == "" then
    print("Usage: :RustFnsNamed function_name")
    return
  end

  local qf = {}
  local files = vim.fn.systemlist("rg --files -g '*.rs'")

  local query = vim.treesitter.query.parse("rust", ([[
    (function_item
      name: (identifier) @name) @function

    ; ; (macro_definition
    ; ;   name: (identifier) @name) @macro
    ;
    (call_expression
    function: (identifier)
    arguments: (arguments (string_literal (string_content) @name))
                (#eq? @name "%s")) @expression
  ]]):format(target))

  for _, file in ipairs(files) do
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "rust")
    if ok and parser then
      local tree = parser:parse()[1]
      local root = tree:root()

      for _, match in query:iter_matches(root, bufnr, 0, -1) do
        local name_node = match[1]
        local item_node = match[2] or match[3]

        if type(name_node) == "table" then name_node = name_node[1] end
        if type(item_node) == "table" then item_node = item_node[1] end

        local name = vim.treesitter.get_node_text(name_node, bufnr)

        if name == target then
          local row, col = item_node:start()
          local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]

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

  vim.fn.setqflist(qf, "r")
  vim.cmd("copen")
end, {
  nargs = 1,
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
              checkOnSave = true,
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
            keymap('n', '<leader>ce', ':RustLsp explainError', '[e]xplain error')
            keymap('n', '<leader>cE', ':RustLsp expandMacro<cr>', '[e]xpand macros')
            keymap('n', 'K', '<cmd>RustLsp hover actions<cr>', '[h]over actions')
            keymap('n', 'J', '<cmd>RustLsp joinLines<cr>', 'join lines')
            keymap('n', '<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
            keymap('n', '<leader>co', ':RustLsp openCargo<cr>', '[o]pen cargo')
            keymap('n', '<leader>cp', ':RustLsp parentModule<cr>', '[p]arent module')
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
