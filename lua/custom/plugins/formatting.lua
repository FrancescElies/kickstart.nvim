return {
  'stevearc/conform.nvim',
  opts = {
    lua = { 'stylua' },
    -- Conform will run multiple formatters sequentially
    python = { 'ruff_fix', 'isort', 'black' },
    -- Use a sub-list to run only the first available formatter
    -- javascript = { { 'prettierd', 'prettier' } },
    javascript = { 'biome' },
    json = { 'biome' },
    markdown = { 'taplo' },
  },
  config = function()
    require("conform").setup({
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
  end
}
