return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>xx', function() require('trouble').open() end,               desc = 'quickfi[x] trouble all' },
    {
      '<leader>xw',
      function() require('trouble').open 'workspace_diagnostics' end,
      desc = 'quickfi[x] [w]orkspace diagnostics',
    },
    {
      '<leader>dx',
      function() require('trouble').open 'document_diagnostics' end,
      desc = '[d]ocument diagnostics quickfi[x] ',
    },
    {
      '<leader>xd',
      function() require('trouble').open 'document_diagnostics' end,
      desc = 'quickfi[x] [d]ocument diagnostics',
    },
    { '<leader>xq', function() require('trouble').open 'quickfix' end,      desc = '[q]uickfi[x]' },
    { '<leader>xl', function() require('trouble').open 'loclist' end,       desc = 'quickfi[x] loclist' },
    { 'gR',         function() require('trouble').open 'lsp_references' end },
  },
}
