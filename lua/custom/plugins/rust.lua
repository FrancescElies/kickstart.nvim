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
          local keymap = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'rust: ' .. desc })
          end

          if vim.bo.filetype == 'rust' then
            keymap('n','<leader>cC', function()
              vim.cmd.RustAnalyzer { 'config', "{ checkOnSave = { command = 'clippy', enable = true } }" }
            end, '[c]lippy on save')
            keymap('n','<leader>cc', function()
              vim.cmd.RustAnalyzer { 'config', '{ checkOnSave = true }' }
            end, '[c]heck on save')
            keymap('n','<leader>ce', ':RustLsp explainError', '[e]xplain error')
            keymap('n','<leader>cE', ':RustLsp expandMacro<cr>', '[e]xpand macros')
            keymap('n','K', '<cmd>RustLsp hover actions<cr>', '[h]over actions')
            keymap('n','J', '<cmd>RustLsp joinLines<cr>', 'join lines')
            keymap('n','<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
            keymap('n','<leader>co', ':RustLsp openCargo<cr>', '[o]pen cargo')
            keymap('n','<leader>cp', ':RustLsp parentModule<cr>', '[p]arent module')
            -- keymap('n','<leader>c.', ':RustLsp! testables<cr>', 'run previous [t]ests')
            -- keymap('n','<leader>ct', ':RustLsp testables<cr>', 'run [t]ests')
            -- rust_keymap('n','<leader>cw', ':RustLsp workspaceSymbol allSymbols ', '[w]orkspace symbol')
            keymap('n','<leader>cg', ':RustLsp crateGraph', 'crate [g]raph')
            -- :RustLsp syntaxTree
            -- :Rustc unpretty {hir|mir|...}
          end
        end,
      })
    end,
  },
}
