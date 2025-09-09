return {
  {
    'smjonas/live-command.nvim',
    -- tag = "2.*",
    config = function()
      require('live-command').setup {

        commands = {
          S = { cmd = 'Subvert' }, -- must be defined before we import vim-abolish
        },
      }
    end,
  },
  { 'tpope/vim-abolish' },
}
