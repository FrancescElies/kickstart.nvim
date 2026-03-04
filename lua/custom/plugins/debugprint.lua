return {
  'andrewferrier/debugprint.nvim',
  opts = {
    keymaps = {
      -- `yd` mnemonic: [y]ou [d]ebug
      normal = {
        plain_below = 'ydp',
        plain_above = 'ydP',
        variable_below = 'ydv',
        variable_above = 'ydV',
        variable_below_alwaysprompt = '',
        variable_above_alwaysprompt = '',
        surround_plain = 'ydsp',
        surround_variable = 'ydsv',
        surround_variable_alwaysprompt = '',
        textobj_below = 'ydo',
        textobj_above = 'ydO',
        textobj_surround = 'ydso',
        toggle_comment_debug_prints = 'ydt',
        delete_debug_prints = 'ydd',
      },
      insert = {
        -- plain = '<C-G>p',
        -- variable = '<C-G>v',
      },
      visual = {
        variable_below = 'ydv',
        variable_above = 'ydV',
      },
    },
  },
  dependencies = {
    'echasnovski/mini.nvim', -- Optional: Needed for line highlighting
    'nvim-telescope/telescope.nvim', -- Optional: If you want to use the :SearchDebugPrints command with telescope.nvim
  },

  lazy = false, -- Required to make line highlighting work before debugprint is first used
  version = '*', -- Remove if you DON'T want to use the stable version
}
