-- local bufnr = vim.api.nvim_get_current_buf()
-- https://github.com/Canop/codesort
-- cargo install codesort
--https://github.com/dsully/nvim/blob/ddcd5971bc061440d3b0e798ffa15edfd6a7f77b/after/ftplugin/rust.lua#L1
-- if vim.fn.executable 'codesort' == 1 then
--   --
--   keys.bmap('<leader>cs', function()
--     --
--     local result = vim
--       .system({
--         'codesort',
--         '--around',
--         tostring(vim.api.nvim_win_get_cursor(0)[1]),
--         '--detect',
--         vim.fs.normalize(vim.fs.basename(vim.api.nvim_buf_get_name(0))),
--       }, {
--         stdin = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false),
--       })
--       :wait()
--
--     if result.code == 0 and result.stdout then
--       vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(result.stdout, '\n', { trimempty = true }))
--     else
--       vim.notify('Error running codesort: ' .. (result.stderr or ''), vim.log.levels.ERROR)
--     end
--   end, 'Sort code', bufnr)
--
--   keys.xmap('<leader>cs', function()
--     local start_line = vim.api.nvim_buf_get_mark(0, '<')[1]
--     local end_line = vim.api.nvim_buf_get_mark(0, '>')[1]
--
--     local result = vim.system({ 'codesort' }, { stdin = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false) }):wait()
--
--     if result.code == 0 and result.stdout then
--       vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, vim.split(result.stdout, '\n', { trimempty = true }))
--     else
--       vim.notify('Error running codesort: ' .. (result.stderr or ''), vim.log.levels.ERROR)
--     end
--   end, 'Sort code', bufnr)
-- end

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
          -- https://rust-analyzer.github.io/manual.html
          -- see `lsp-init.lua` too
          ['rust-analyzer'] = {
            diagnostics = { experimental = { enable = true } },
            checkOnSave = false, -- disables running clippy on save
            -- checkOnSave = { command = 'clippy', enable = true },
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
          rust_keymap('<leader>cd', ':RustLsp renderDiagnostic', 'render [d]iagnostic') --  Useful for solving bugs around borrowing and generics, as it consolidates the important bits (sometimes across files) together.
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
