local function get_todos(dir, states)
  require('telescope.builtin').live_grep { cwd = dir }
  vim.fn.feedkeys('^ *([*]+|[-]+) +[(]' .. states .. '[)]')
end

return {
  'nvim-neorg/neorg',
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = '*', -- Pin Neorg to the latest stable release
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neorg/neorg-telescope',
  },
  -- build = ":Neorg sync-parsers",
  -- enabled = false,
  ft = 'norg',
  keys = {
    { '<leader>sz', '<Plug>(neorg.telescope.search_headings)' },
    { '<leader>jn', ':Neorg workspace notes<CR>:Neorg journal today<CR>', desc = '[J]ournal [N]owday ' },
    { '<leader>jy', ':Neorg workspace notes<CR>:Neorg journal yesterday<CR>', desc = '[J]ournal [Y]esterday' },
    { '<leader>jt', ':Neorg workspace notes<CR>:Neorg journal tomorrow<CR>', desc = '[J]ournal [T]omorrow ' },
    {
      '<c-t>',
      function()
        get_todos('~/neorg/notes', '[^x_]')
      end,
    },
  },
  opts = {
    load = {
      ['core.keybinds'] = {
        config = {
          default_keybinds = true,
        },
      },
      ['core.defaults'] = {}, -- Load all default modules
      ['core.concealer'] = {}, -- Icons and pretty output
      ['core.dirman'] = {
        config = {
          workspaces = {
            notes = '~/neorg/notes',
            journal = '~/neorg/journal',
          },
          default_workspace = 'notes',
        },
      },
      ['core.integrations.telescope'] = {},
      ['core.journal'] = {
        config = {
          workspace = 'journal',
        },
      },
    },
  },
  -- config = true,
}
