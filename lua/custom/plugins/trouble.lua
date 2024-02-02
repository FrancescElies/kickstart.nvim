return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    keys = {
      { "<leader>xt", ":TodoQuickFix", desc = "quickfi[x] [t]odo" },
    },
  },
  {
    "folke/trouble.nvim",
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>xx",
        function() require("trouble").open() end,
        desc = "quickfi[x] trouble all",
      },
      {
        "<leader>xw",
        function() require("trouble").open("workspace_diagnostics") end,
        desc = "quickfi[x] [w]orkspace diagnostics",
      },
      {
        "<leader>dx",
        function() require("trouble").open("document_diagnostics") end,
        desc = "[d]ocument diagnostics quickfi[x] ",
      },
      {
        "<leader>xd",
        function() require("trouble").open("document_diagnostics") end,
        desc = "quickfi[x] [d]ocument diagnostics",
      },
      {
        "<leader>xq",
        function() require("trouble").open("quickfix") end,
        desc = "[q]uickfi[x]",
      },
      {
        "<leader>xl",
        function() require("trouble").open("loclist") end,
        desc = "quickfi[x] loclist",
      },
      {
        "[x",
        function() require("trouble").previous({ skip_groups = true, jump = true }) end,
        desc = "[x]trouble previous",
      },
      {
        "]x",
        function() require("trouble").next({ skip_groups = true, jump = true }) end,
        desc = "[x]trouble next",
      },
      {
        "[X",
        function() require("trouble").first({ skip_groups = true, jump = true }) end,
        desc = "[x]trouble firstprevious",
      },
      {
        "]X",
        function() require("trouble").last({ skip_groups = true, jump = true }) end,
        desc = "[x]trouble last",
      },
    },
  },
}
