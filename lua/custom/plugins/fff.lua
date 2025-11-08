return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require('fff.download').download_or_build_binary()
  end,
  opts = {
    debug = {
      enabled = true, -- we expect your collaboration at least during the beta
      show_scores = true,
    },
  },
  -- No need to lazy-load with lazy.nvim.
  -- This plugin initializes itself lazily.
  lazy = false,
  keys = {
    {
      'ff',
      function()
        require('fff').find_files()
      end,
      desc = 'FFFind files',
    },
  },
}
