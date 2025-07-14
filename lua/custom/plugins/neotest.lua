return {
  -- An extensible framework for interacting with tests within NeoVim
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-plenary',
      'rouge8/neotest-rust',
      -- "fredrikaverpil/neotest-golang",
      -- "leoluz/nvim-dap-go",
    },
    keys = {
      -- stylua: ignore start
      { '<localleader>tn', function() require('neotest').run.run() end, { desc = "run nearest test" } },
      { '<localleader>tb', function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "run tests current buf" } },
      { '<localleader>to', function() require('neotest').output.open { enter = true } end, { desc = "open result" }},
      { '<localleader>td', function() require("neotest").run.run {vim.fn.expand("%"), suite = false, strategy = "dap"} end, { desc = "run tests current buf" } },
      { "<localleader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, { desc = "Debug: Open test output" }},
      -- stylua: ignore end
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').setup {
        adapters = {
          require 'neotest-plenary',
          require 'neotest-rust' {
            args = { '--no-capture' },
          },
        },
      }
    end,
  },
}
