local fn = require 'custom.fn'

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

function ask_region()
  local input = visual_region_to_text()
  if input ~= '' then require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer }) end
end

if vim.fn.has 'win32' then
  -- do
  --   vim.pack.add { 'https://github.com/CopilotC-Nvim/CopilotChat.nvim' }
  --   -- build = 'make tiktoken',
  --   -- make tiktoken will fail on windows, do the following manual stup instead
  --   -- cd ~/AppData/Local/nvim-data/lazy/CopilotChat.nvim
  --   -- mkdir build
  --   -- cd build
  --   -- http get https://github.com/gptlang/lua-tiktoken/releases/download/v0.2.6/tiktoken_core-windows-x86_64-luajit.dll | save tiktoken_core.dll
  --   -- http get https://github.com/gptlang/lua-tiktoken/releases/download/v0.2.6/tiktoken_core-windows-x86_64-lua51.dll | save tiktoken_core-lua51.dll
  --   require('CopilotChat').setup {
  --     debug = false,
  --     window = {
  --       layout = 'float', -- 'vertical', 'horizontal', 'float'
  --       width = 0.5, -- 50% of screen width
  --     },
  --   }
  --   vim.keymap.set('n', '<localleader>c', '<cmd>CopilotChatToggle<cr>', { desc = 'Toggle Copilot Chat' })
  --   vim.keymap.set('v', '<localleader>c', ask_region, { desc = 'CopilotChat - Send visual lines' })
  -- end

  do
    vim.pack.add { fn.gh 'nvim-lua/plenary.nvim' }
    vim.pack.add { fn.gh 'nvim-treesitter/nvim-treesitter' }

    --     vim.pack.add { fn.gh 'ravitemer/mcphub.nvim' }
    -- -- https://docs.mcp-hub.info/getting-started/installation/
    --     require('mcphub').setup {
    --       config = vim.fn.expand '~/.config/mcphub/servers.json',
    --     }

    vim.pack.add { { src = fn.gh 'olimorris/codecompanion.nvim', version = vim.version.range '^19.0.0' } }
    require('codecompanion').setup {
      interactions = {
        -- models:  'claude-haiku-4.5', 'gpt-5.3-codex', 'gpt-5-mini', 'claude-opus-4.7', 'claude-sonnet-4.6', 'claude-opus-4.6', 'gpt-5.4', 'claude-opus-4.8', 'gpt-5.4-mini', 'gpt-5.5',
        chat = { adapter = { name = 'copilot', model = 'claude-opus-4.8' } },
        inline = { adapter = 'copilot' },
        cmd = { adapter = 'copilot' },
        background = { adapter = 'copilot' },
      },
      extensions = {
        -- mcphub = {
        --   callback = 'mcphub.extensions.codecompanion',
        --   opts = {
        --     make_vars = true,
        --     make_slash_commands = true,
        --     show_result_in_chat = true,
        --   },
        -- },
      },
    }
    local opts = { noremap = true, silent = true }
    vim.keymap.set({ 'n', 'v' }, '<localleader>a', '<cmd>CodeCompanionActions<cr>', opts)
    vim.keymap.set({ 'n', 'v' }, '<localleader>c', '<cmd>CodeCompanionChat Toggle<cr>', opts)
    vim.keymap.set('v', '<localleader>A', '<cmd>CodeCompanionChat Add<cr>', opts)

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end

  do
    vim.pack.add { fn.gh 'HakonHarnes/img-clip.nvim' }
    require('img-clip').setup {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = '[Image]($FILE_PATH)',
          use_absolute_path = true,
        },
      },
    }
  end
end
