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
        tools = {
          test_executor = 'background',
        },
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
                  adt = { enable = true }, -- structs/enums/unions
                  enumVariant = { enable = true },
                  method = { enable = true }, -- method-level specifically
                  trait = { enable = true },
                },
                updateTest = { enable = true },
                implementations = { enable = true },
                run = { enable = true }, --  ▶ Run button
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
          local rust_keymap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'rust: ' .. desc })
          end

          if vim.bo.filetype == 'rust' then
            rust_keymap('<leader>cC', function()
              vim.cmd.RustAnalyzer { 'config', "{ checkOnSave = { command = 'clippy', enable = true } }" }
            end, '[c]lippy on save')
            rust_keymap('<leader>cc', function()
              vim.cmd.RustAnalyzer { 'config', '{ checkOnSave = true }' }
            end, '[c]heck on save')
            rust_keymap('<leader>ca', function()
              vim.cmd.RustLsp 'codeAction' -- supports rust-analyzer's grouping
              -- or vim.lsp.buf.codeAction() if you don't want grouping.
            end, 'code [a]ction')
            rust_keymap('<leader>ce', ':RustLsp explainError', '[e]xplain error')
            rust_keymap('<leader>cE', ':RustLsp expandMacro<cr>', '[e]xpand macros')
            rust_keymap('K', '<cmd>RustLsp hover actions<cr>', '[h]over actions')
            rust_keymap('J', '<cmd>RustLsp joinLines<cr>', 'join lines')
            rust_keymap('<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
            rust_keymap('<leader>co', ':RustLsp openCargo<cr>', '[o]pen cargo')
            rust_keymap('<leader>cp', ':RustLsp parentModule<cr>', '[p]arent module')
            rust_keymap('<leader>c.', ':RustLsp! testables<cr>', 'run previous [t]ests')
            rust_keymap('<leader>ct', ':RustLsp testables<cr>', 'run [t]ests')
            -- rust_keymap('<leader>cw', ':RustLsp workspaceSymbol allSymbols ', '[w]orkspace symbol')
            -- :RustLsp crateGraph {backend {output}}
            -- :RustLsp syntaxTree
            -- :Rustc unpretty {hir|mir|...}
          end
        end,
      })
    end,
  },
}
