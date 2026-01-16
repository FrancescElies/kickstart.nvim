-- https://github.com/neovim/neovim/pull/13896
-- Usage:
--   local r = vim.region(0, "'<", "'>", vim.fn.visualmode(), true)
--   vim.print(visual_region_to_text(r))
function visual_region_to_text(region)
  local text = ''
  local maxcol = vim.v.maxcol
  for line, cols in vim.spairs(region) do
    local endcol = cols[2] == maxcol and -1 or cols[2]
    local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
    text = ('%s%s\n'):format(text, chunk)
  end
  return text
end

local is_windows = string.lower(vim.loop.os_uname().sysname) == 'windows_nt'
if is_windows then
  return {
    -- {
    --   'github/copilot.vim',
    --   event = 'VeryLazy',
    --   init = function()
    --     vim.g.copilot_filetypes = { ['*'] = false, cpp = true, c = true, typescript = true, python = true, rust = true }
    --     vim.g.copilot_enabled = false
    --     vim.g.copilot_node_command = '~/AppData/Local/fnm_multishells/2760_1761048716755/node.exe'
    --     vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
    --       expr = true,
    --       replace_keycodes = false,
    --     })
    --     vim.g.copilot_no_tab_map = true
    --   end,
    -- },
    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      config = function()
        require('copilot').setup {
          suggestion = {
            enabled = true,
            auto_trigger = false,
            debounce = 75,
            keymap = {
              accept = '<tab>',
              accept_word = '<C-Right>',
              accept_line = false,
              next = '<M-]>',
              prev = '<M-[>',
              dismiss = '<C-]>',
            },
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            ['.'] = false,
          },
        }
      end,
    },

    -- {
    --   'CopilotC-Nvim/CopilotChat.nvim',
    --   dependencies = {
    --     { 'nvim-lua/plenary.nvim', branch = 'master' },
    --   },
    --   build = 'make tiktoken',
    --   opts = {
    --     debug = false,
    --     question_header = '## User ',
    --     answer_header = '## Copilot ',
    --     error_header = '## Error ',
    --   },
    --   keys = {
    --     { '<leader>Cc', ':CopilotChat<cr>', desc = 'CopilotChat - Quick chat' },
    --     {
    --       '<leader>Cv',
    --       function()
    --         local input = visual_region_to_text()
    --         if input ~= '' then
    --           require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
    --         end
    --       end,
    --       desc = 'CopilotChat - Send visual lines',
    --       mode = 'v',
    --     },
    --     { '<leader>Cc', '<cmd>CopilotChatToggle<cr>', desc = 'Toggle Copilot Chat' },
    --     { '<leader>Cf', '<cmd>CopilotChatFix<cr>', desc = 'Fix code' },
    --     { '<leader>Ce', ':CopilotChatExplain<cr>', desc = 'Explain code' },
    --     { '<leader>Ct', ':CopilotChatTests<cr>', desc = 'Generate tests' },
    --     { '<leader>Cv', ':CopilotChatVisual', mode = 'x', desc = 'Open in vertical split' },
    --     { '<leader>Cx', ':CopilotChatInPlace<cr>', mode = 'x', desc = 'Run in-place code' },
    --     { '<leader>Cf', ':CopilotChatFixDiagnostic<cr>', desc = 'Fix diagnostic' },
    --     { '<leader>Cr', ':CopilotChatReset<cr>', desc = 'Reset chat history and clear buffer' },
    --   },
    -- },
  }
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
