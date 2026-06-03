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

if vim.fn.has 'win32' then
  vim.pack.add { 'https://github.com/CopilotC-Nvim/CopilotChat.nvim' }
  -- build = 'make tiktoken',
  -- make tiktoken will fail on windows, do the following manual stup instead
  -- cd ~/AppData/Local/nvim-data/lazy/CopilotChat.nvim
  -- mkdir build
  -- cd build
  -- http get https://github.com/gptlang/lua-tiktoken/releases/download/v0.2.6/tiktoken_core-windows-x86_64-luajit.dll | save tiktoken_core.dll
  -- http get https://github.com/gptlang/lua-tiktoken/releases/download/v0.2.6/tiktoken_core-windows-x86_64-lua51.dll | save tiktoken_core-lua51.dll
  require('CopilotChat').setup {
    debug = false,
    question_header = '## User ',
    answer_header = '## Copilot ',
    error_header = '## Error ',
  }
  -- keys = {
  --   { '<localleader>co', ':CopilotChat<cr>',              desc = 'CopilotChat - Quick chat' },
  --   {
  --     '<localleader>cv',
  --     function()
  --       local input = visual_region_to_text()
  --       if input ~= '' then
  --         require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
  --       end
  --     end,
  --     desc = 'CopilotChat - Send visual lines',
  --     mode = 'v',
  --   },
  --   { '<localleader>cc', '<cmd>CopilotChatToggle<cr>',    desc = 'Toggle Copilot Chat' },
  --   { '<localleader>cf', '<cmd>CopilotChatFix<cr>',       desc = 'Fix code' },
  --   { '<localleader>ce', ':CopilotChatExplain<cr>',       desc = 'Explain code' },
  --   { '<localleader>ct', ':CopilotChatTests<cr>',         desc = 'Generate tests' },
  --   { '<localleader>cv', ':CopilotChatVisual',            mode = 'x',                                  desc = 'Open in vertical split' },
  --   { '<localleader>cx', ':CopilotChatInPlace<cr>',       mode = 'x',                                  desc = 'Run in-place code' },
  --   { '<localleader>cf', ':CopilotChatFixDiagnostic<cr>', desc = 'Fix diagnostic' },
  --   { '<localleader>cr', ':CopilotChatReset<cr>',         desc = 'Reset chat history and clear buffer' },
  -- },
end
