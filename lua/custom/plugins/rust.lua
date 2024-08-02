return {
  --   disable rust-analyzer in lsp-init.lua if this plugin enabled
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
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
          ['rust-analyzer'] = {
            -- see lsp-init.lua
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
          rust_keymap('<leader>cD', ':RustLsp openDocs<cr>', '[o]pen docs')
          rust_keymap('<leader>cE', ':RustLsp expandMacro<cr>', '[e]xpand macros')
          rust_keymap('<leader>cP', ':RustLsp rebuildProcMacros<cr>', 'rebuild [p]roc macros')
          rust_keymap('<leader>cR', ':RustLsp runnables', 'show [r]unnables')
          rust_keymap('<leader>ca', ':RustLsp codeAction<cr>', 'code [a]ction')
          rust_keymap('<leader>cd', ':RustLsp renderDiagnostic', '[e]xplain error') --  Useful for solving bugs around borrowing and generics, as it consolidates the important bits (sometimes across files) together.
          rust_keymap('<leader>ce', ':RustLsp explainError', '[e]xplain error')
          rust_keymap('<leader>cf', ':RustLsp flyCheck ', '[f]ly check')
          rust_keymap('<leader>ch', ':RustLsp hover ', '[h]over actions|range')
          rust_keymap('<leader>cj', ':RustLsp joinLines<cr>', 'join lines')
          rust_keymap('<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
          rust_keymap('<leader>co', ':RustLsp openCargo<cr>', '[o]pen cargo')
          rust_keymap('<leader>cp', ':RustLsp parentModule', '[p]arent module')
          rust_keymap('<leader>cr', ':RustLsp run', '[r]un target current position')
          rust_keymap('<leader>cs', ':RustLsp ssr ', 'structural search and replace')
          rust_keymap('<leader>ct', ':RustLsp testables', 'tests[!]')
          rust_keymap('<leader>cv', ':RustLsp view ', '[v]iew hir|mir')
          rust_keymap('<leader>cw', ':RustLsp workspaceSymbol ', '[w]orkspace symbol')
          -- :RustLsp crateGraph {backend {output}}
          -- :RustLsp syntaxTree
          -- :Rustc unpretty {hir|mir|...}
        end
      end,
    })
  end,
}
