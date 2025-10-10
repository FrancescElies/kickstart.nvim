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
  version = '^6', -- Recommended
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
          -- https://rust-analyzer.github.io/book/configuration.html
          -- https://github.com/BurntSushi/dotfiles/blob/a6c516e6c4c7f7afae4f3171be4c5404d367ffbe/.config/ag/nvim/default#L16
          -- see `lsp-init.lua` too
          ['rust-analyzer'] = {
            check = { allTargets = true, features = 'all' },
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
            -- checkOnSave = true,
            checkOnSave = { command = 'clippy', enable = false },
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
          -- rust_keymap('<leader>ca', ':RustLsp codeAction<cr>', 'code [a]ction')
          -- rust_keymap('<leader>ce', ':RustLsp explainError', '[e]xplain error')
          -- rust_keymap('<leader>cE', ':RustLsp expandMacro<cr>', '[e]xpand macros')
          rust_keymap('<leader>cc', ':RustLsp flyCheck run<cr>', '[c]ode [c]lippy')
          -- rust_keymap('<leader>ch', ':RustLsp hover ', '[h]over actions|range')
          -- rust_keymap('<leader>cj', ':RustLsp joinLines<cr>', 'join lines')
          -- rust_keymap('<leader>cm', ':RustLsp moveItem ', '[m]ove up|down')
          -- rust_keymap('<leader>co', ':RustLsp openCargo<cr>', '[o]pen cargo')
          -- rust_keymap('<leader>cp', ':RustLsp parentModule<cr>', '[p]arent module')
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
}
