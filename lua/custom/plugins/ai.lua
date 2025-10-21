local is_windows = string.lower(vim.loop.os_uname().sysname) == 'windows_nt'
if is_windows then
  vim.g.copilot_filetypes = { ['*'] = false, cpp = true, c = true, typescript = true, python = true }
  vim.g.copilot_node_command = '~/AppData/Local/fnm_multishells/2760_1761048716755/node.exe'
  return {
    {
      'github/copilot.vim',
      cmd = 'Copilot',
      event = 'BufWinEnter',
      init = function()
        vim.g.copilot_no_maps = true
      end,
      config = function()
        -- Block the normal Copilot suggestions
        vim.api.nvim_create_augroup('github_copilot', { clear = true })
        vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
          group = 'github_copilot',
          callback = function(args)
            vim.fn['copilot#On' .. args.event]()
          end,
        })
        vim.fn['copilot#OnFileType']()
      end,
    },
    {
      'saghen/blink.cmp',
      dependencies = { 'fang2hou/blink-copilot' },
      opts = {
        sources = {
          default = { 'copilot' },
          providers = {
            copilot = {
              name = 'copilot',
              module = 'blink-copilot',
              score_offset = 100,
              async = true,
            },
          },
        },
      },
    },
  }
  -- just copilot
  -- return {
  --   'github/copilot.vim',
  --   cmd = 'Copilot',
  --   -- event = 'InsertEnter',
  --   opts = {
  --     auto_activate = false,
  --   },
  -- }
  -- copilot + blink
else
  return {
    -- {
    --   'NickvanDyke/opencode.nvim',
    --   dependencies = {
    --     -- Recommended for `ask()` and `select()`.
    --     -- Required for `toggle()`.
    --     { 'folke/snacks.nvim', opts = { input = {}, picker = {} } },
    --   },
    --   config = function()
    --     vim.g.opencode_opts = {
    --       -- Your configuration, if any — see `lua/opencode/config.lua`
    --     }
    --
    --     -- Required for `vim.g.opencode_opts.auto_reload`
    --     vim.opt.autoread = true
    --
    --   -- Recommended/example keymaps
    --   -- stylua: ignore start
    --   local oc = require("opencode")
    --   vim.keymap.set({ "n", "x" }, "<leader>oa", function() oc.ask("@this: ", { submit = true }) end, { desc = "Ask about this" })
    --   vim.keymap.set({ "n", "x" }, "<leader>o+", function() oc.prompt("@this") end, { desc = "Add this" })
    --   vim.keymap.set({ "n", "x" }, "<leader>os", function() oc.select() end, { desc = "Select prompt" })
    --   vim.keymap.set("n", "<leader>ot", function() oc.toggle() end, { desc = "Toggle embedded" })
    --   vim.keymap.set("n", "<leader>oc", function() oc.command() end, { desc = "Select command" })
    --   vim.keymap.set("n", "<leader>on", function() oc.command("session_new") end, { desc = "New session" })
    --   vim.keymap.set("n", "<leader>oi", function() oc.command("session_interrupt") end, { desc = "Interrupt session" })
    --   vim.keymap.set("n", "<leader>oA", function() oc.command("agent_cycle") end, { desc = "Cycle selected agent" })
    --   vim.keymap.set("n", "<S-C-u>",    function() oc.command("messages_half_page_up") end, { desc = "Messages half page up" })
    --   vim.keymap.set("n", "<S-C-d>",    function() oc.command("messages_half_page_down") end, { desc = "Messages half page down" })
    --     -- stylua: ignore end
    --   end,
    -- },
    -- {
    -- TODO: check [lewis6991/dotfiles](https://github.com/lewis6991/dotfiles/blob/main/config/nvim/lua/lewis6991/codecompanion.lua)
    --   'olimorris/codecompanion.nvim',
    --   opts = {},
    --   dependencies = {
    --     'nvim-lua/plenary.nvim',
    --   },
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
end
