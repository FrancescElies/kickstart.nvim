-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuOpen',
--   callback = function()
--     vim.b.copilot_suggestion_hidden = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuClose',
--   callback = function()
--     vim.b.copilot_suggestion_hidden = false
--   end,
-- })

return {
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `toggle()`.
      { 'folke/snacks.nvim', opts = { input = {}, picker = {} } },
    },
    config = function()
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`
      }

      -- Required for `vim.g.opencode_opts.auto_reload`
      vim.opt.autoread = true

    -- Recommended/example keymaps
    -- stylua: ignore start
    local oc = require("opencode")
    vim.keymap.set({ "n", "x" }, "<leader>oa", function() oc.ask("@this: ", { submit = true }) end, { desc = "Ask about this" })
    vim.keymap.set({ "n", "x" }, "<leader>o+", function() oc.prompt("@this") end, { desc = "Add this" })
    vim.keymap.set({ "n", "x" }, "<leader>os", function() oc.select() end, { desc = "Select prompt" })
    vim.keymap.set("n", "<leader>ot", function() oc.toggle() end, { desc = "Toggle embedded" })
    vim.keymap.set("n", "<leader>oc", function() oc.command() end, { desc = "Select command" })
    vim.keymap.set("n", "<leader>on", function() oc.command("session_new") end, { desc = "New session" })
    vim.keymap.set("n", "<leader>oi", function() oc.command("session_interrupt") end, { desc = "Interrupt session" })
    vim.keymap.set("n", "<leader>oA", function() oc.command("agent_cycle") end, { desc = "Cycle selected agent" })
    vim.keymap.set("n", "<S-C-u>",    function() oc.command("messages_half_page_up") end, { desc = "Messages half page up" })
    vim.keymap.set("n", "<S-C-d>",    function() oc.command("messages_half_page_down") end, { desc = "Messages half page down" })
      -- stylua: ignore end
    end,
  },
  -- {
  --   'olimorris/codecompanion.nvim',
  --   opts = {},
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  -- },
  -- {
  --   'github/copilot.vim',
  --   cmd = 'Copilot',
  --   -- event = 'InsertEnter',
  --   opts = {
  --     auto_activate = false,
  --   },
  -- },
  -- {
  --   'zbirenbaum/copilot.lua',
  --   dependencies = {
  --     {
  --       'copilotlsp-nvim/copilot-lsp',
  --       config = function()
  --         vim.g.copilot_nes_debounce = 500
  --       end,
  --     },
  --   },
  --   cmd = 'Copilot',
  --   event = 'InsertEnter',
  --   config = function()
  --     require('copilot').setup {
  --       nes = {
  --         enabled = true,
  --         keymap = {
  --           accept_and_goto = '<leader>p',
  --           accept = false,
  --           dismiss = '<Esc>',
  --         },
  --       },
  --     }
  --   end,
  -- },

  -- 'jackMort/ChatGPT.nvim',
  -- event = 'VeryLazy',
  -- config = function()
  --   require('chatgpt').setup()
  -- end,
  -- dependencies = {
  --   'MunifTanjim/nui.nvim',
  --   'nvim-lua/plenary.nvim',
  --   'folke/trouble.nvim', -- optional
  --   'nvim-telescope/telescope.nvim',
  -- },
  -- keys = {
  --   { '<leader>Cc', '<cmd>ChatGPT<CR>', desc = 'ChatGPT' },
  --   { '<leader>Ce', '<cmd>ChatGPTEditWithInstruction<CR>', desc = 'Edit with instruction', mode = { 'n', 'v' } },
  --   { '<leader>Cg', '<cmd>ChatGPTRun grammar_correction<CR>', desc = 'Grammar Correction', mode = { 'n', 'v' } },
  --   { '<leader>Ct', '<cmd>ChatGPTRun translate<CR>', desc = 'Translate', mode = { 'n', 'v' } },
  --   { '<leader>Ck', '<cmd>ChatGPTRun keywords<CR>', desc = 'Keywords', mode = { 'n', 'v' } },
  --   { '<leader>Cd', '<cmd>ChatGPTRun docstring<CR>', desc = 'Docstring', mode = { 'n', 'v' } },
  --   { '<leader>Ca', '<cmd>ChatGPTRun add_tests<CR>', desc = 'Add Tests', mode = { 'n', 'v' } },
  --   { '<leader>Co', '<cmd>ChatGPTRun optimize_code<CR>', desc = 'Optimize Code', mode = { 'n', 'v' } },
  --   { '<leader>Cs', '<cmd>ChatGPTRun summarize<CR>', desc = 'Summarize', mode = { 'n', 'v' } },
  --   { '<leader>Cf', '<cmd>ChatGPTRun fix_bugs<CR>', desc = 'Fix Bugs', mode = { 'n', 'v' } },
  --   { '<leader>Cx', '<cmd>ChatGPTRun explain_code<CR>', desc = 'Explain Code', mode = { 'n', 'v' } },
  --   { '<leader>Cr', '<cmd>ChatGPTRun roxygen_edit<CR>', desc = 'Roxygen Edit', mode = { 'n', 'v' } },
  --   { '<leader>Cl', '<cmd>ChatGPTRun code_readability_analysis<CR>', desc = 'Code Readability Analysis', mode = { 'n', 'v' } },
  -- },
}
