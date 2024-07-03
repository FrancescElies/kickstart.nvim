return {
  --   disable rust-analyzer in lsp-init.lua if this plugin enabled
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  lazy = false, -- This plugin is already lazy

  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('my-rustaceanvim-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'rust: ' .. desc })
        end

        map('<leader>cD', ':RustLsp openDocs<cr>', '[o]pen docs')
        map('<leader>cE', ':RustLsp expandMacro<cr>', '[e]xpand macros')
        map('<leader>cP', ':RustLsp rebuildProcMacros<cr>', 'rebuild [p]roc macros')
        map('<leader>cR', ':RustLsp runnables', 'show [r]unnables')
        map('<leader>ca', ':RustLsp codeAction<cr>', 'code [a]ction')
        map('<leader>cd', ':RustLsp renderDiagnostic', '[e]xplain error') --  Useful for solving bugs around borrowing and generics, as it consolidates the important bits (sometimes across files) together.
        map('<leader>ce', ':RustLsp explainError', '[e]xplain error')
        map('<leader>cf', ':RustLsp flyCheck ', '[f]ly check')
        map('<leader>ch', ':RustLsp hover ', '[h]over actions|range')
        map('<leader>cj', ':RustLsp joinLines<cr>', 'join lines')
        map('<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
        map('<leader>co', ':RustLsp openCargo<cr>', '[o]pen cargo')
        map('<leader>cp', ':RustLsp parentModule', '[p]arent module')
        map('<leader>cr', ':RustLsp run', '[r]un target current position')
        map('<leader>cs', ':RustLsp ssr ', 'structural search and replace')
        map('<leader>ct', ':RustLsp testables', 'tests[!]')
        map('<leader>cv', ':RustLsp view ', '[v]iew hir|mir')
        map('<leader>cw', ':RustLsp workspaceSymbol ', '[w]orkspace symbol')
        -- :RustLsp crateGraph {backend {output}}
        -- :RustLsp syntaxTree
        -- :Rustc unpretty {hir|mir|...}
      end,
    })
  end,
}
