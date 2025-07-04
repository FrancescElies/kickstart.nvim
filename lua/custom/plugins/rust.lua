-- local bufnr = vim.api.nvim_get_current_buf()
-- https://github.com/Canop/codesort
-- cargo install codesort
--https://github.com/dsully/nvim/blob/ddcd5971bc061440d3b0e798ffa15edfd6a7f77b/after/ftplugin/rust.lua#L1
-- if vim.fn.executable 'codesort' == 1 then
--   --
--   keys.bmap('<localleader>cs', function()
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
--   keys.xmap('<localleader>cs', function()
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
  version = '^6', -- Recommended
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
            checkOnSave = true, -- disables running clippy on save
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
          rust_keymap(',D', ':RustLsp openDocs<cr>', '[o]pen docs')
          rust_keymap(',E', ':RustLsp expandMacro<cr>', '[e]xpand macros')
          rust_keymap(',P', ':RustLsp rebuildProcMacros<cr>', 'rebuild [p]roc macros')
          rust_keymap(',R', ':RustLsp runnables', 'show [r]unnables')
          rust_keymap(',a', ':RustLsp codeAction<cr>', 'code [a]ction')
          rust_keymap(',d', ':RustLsp renderDiagnostic', 'render [d]iagnostic') --  Useful for solving bugs around borrowing and generics, as it consolidates the important bits (sometimes across files) together.
          rust_keymap(',e', ':RustLsp explainError', '[e]xplain error')
          rust_keymap(',f', ':RustLsp flyCheck ', '[f]ly check')
          rust_keymap(',h', ':RustLsp hover ', '[h]over actions|range')
          rust_keymap(',j', ':RustLsp joinLines<cr>', 'join lines')
          rust_keymap(',m', ':RustLsp moveItem ', '[m]ove up|down')
          rust_keymap(',o', ':RustLsp openCargo<cr>', '[o]pen cargo')
          rust_keymap(',p', ':RustLsp parentModule', '[p]arent module')
          rust_keymap(',r', ':RustLsp run', '[r]un target current position')
          rust_keymap(',s', ':RustLsp ssr ', 'structural search and replace')
          rust_keymap(',t', ':RustLsp testables', 'tests[!]')
          rust_keymap(',v', ':RustLsp view ', '[v]iew hir|mir')
          rust_keymap(',w', ':RustLsp workspaceSymbol ', '[w]orkspace symbol')
          -- :RustLsp crateGraph {backend {output}}
          -- :RustLsp syntaxTree
          -- :Rustc unpretty {hir|mir|...}
        end
      end,
    })
  end,
}
