-- autopairs
-- https://github.com/windwp/nvim-autopairs

vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }
require('nvim-autopairs').setup {
  disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'snacks_picker_input', 'fff_input' },
}
