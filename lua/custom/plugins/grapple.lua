return {
  'cbochs/grapple.nvim',
  opts = {
    scope = 'git', -- also try out "git_branch"
  },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  keys = {
    { '<M-m>', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
    { 'M', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
    { '<M-k>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
    { '<M-j>', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
  },
}
