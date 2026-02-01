return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true, cmd = 'DB' },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1

      -- So that K on a word runs :DB EXPLAIN
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'sql',
        callback = function()
          vim.bo.keywordprg = ':DB'
        end,
      })
    end,
  },
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          sql = { 'snippets', 'dadbod', 'buffer' },
        },
        -- add vim-dadbod-completion to your completion providers
        providers = {
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
  },
}
