return {
  --   disable rust-analyzer in lsp-init.lua if this plugin enabled
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  lazy = false, -- This plugin is already lazy

  config = function()
    -- will run tests in the background, parse the results,
    -- and - if possible - display failed tests as diagnostics
    vim.g.rustaceanvim.tools.test_executor = 'background'

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('my-rustaceanvim-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'rust: ' .. desc })
        end

        map('<leader>cp', ':RustLsp rebuildProcMacros<cr>', 'rebuild proc macros')
        map('<leader>cE', ':RustLsp expandMacro<cr>', '[e]xpand macros')
        map('<leader>cR', ':RustLsp runnables', 'show [r]unnables')
        map('<leader>cr', ':RustLsp run', '[r]un target current position')
        map('<leader>ct', ':RustLsp testables', 'tests[!]')
        map('<leader>ca', ':RustLsp codeAction ', 'code [a]ction')
        map('<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
        map('<leader>ch', ':RustLsp hover ', '[h]over actions|range')
        map('<leader>ce', ':RustLsp explainError', '[e]xplain error')
        map('<leader>cd', ':RustLsp renderDiagnostic', '[e]xplain error') --  Useful for solving bugs around borrowing and generics, as it consolidates the important bits (sometimes across files) together.
        map('<leader>co', ':RustLsp openCargo<cr>', '[o]pen cargo')
        map('<leader>co', ':RustLsp openDocs<cr>', '[o]pen docs')
        map('<leader>cp', ':RustLsp parentModule', '[p]arent module')
        map('<leader>cw', ':RustLsp workspaceSymbol ', '[w]orkspace symbol')
        map('J', ':RustLsp joinLines', 'join lines')
        map('<leader>cs', ':RustLsp ssr ', 'structural search and replace')
        -- :RustLsp crateGraph {backend {output}}
        -- :RustLsp syntaxTree
        map('<leader>cf', ':RustLsp flyCheck ', '[f]ly check')
        map('<leader>cv', ':RustLsp view ', '[v]iew hir|mir')
        -- :Rustc unpretty {hir|mir|...}
      end,
    })
  end,
}
