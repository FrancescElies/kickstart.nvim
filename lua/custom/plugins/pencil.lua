-- pencil.lua
-- A minimal Lua re-implementation of vim-pencil's core behavior:
-- soft/hard wrap + autoformat blacklisting inside code blocks/tables.

local pencil_group = vim.api.nvim_create_augroup('Pencil', { clear = true })

-- Patterns that mark the start/end of a fenced code block in markdown.
local FENCE_PATTERN = '^%s*```'

-- Returns true if the cursor's current line is inside a fenced code block
-- or looks like a table row (starts with | or contains multiple |).
local function in_blacklisted_region()
  local buf = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(buf, 0, cursor_line, false)

  -- Table row check: current line itself looks tabular.
  local current = lines[#lines] or ''
  if current:match '^%s*|.*|%s*$' then return true end

  -- Code fence check: count fences above the cursor; odd count = inside one.
  local fence_count = 0
  for _, line in ipairs(lines) do
    if line:match(FENCE_PATTERN) then fence_count = fence_count + 1 end
  end

  return fence_count % 2 == 1
end

-- Turn hard-wrap autoformat on/off based on region, called on cursor move
-- and on entering insert mode.
local function refresh_autoformat(hard_textwidth)
  if in_blacklisted_region() then
    vim.opt_local.formatoptions:remove 't'
    vim.opt_local.formatoptions:remove 'a'
  else
    vim.opt_local.formatoptions:append 't'
    vim.opt_local.textwidth = hard_textwidth
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = pencil_group,
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function(args)
    local buf = args.buf
    local hard_textwidth = 80 -- change to taste, or make buffer-local var

    -- vim.cmd('setlocal spell wrap')
    vim.opt_local.spell = true
    vim.opt_local.wrap = true

    -- Base pencil options
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = hard_textwidth

    vim.keymap.set('n', 'j', 'gj', { buffer = buf })
    vim.keymap.set('n', 'k', 'gk', { buffer = buf })
    vim.keymap.set('n', '0', 'g0', { buffer = buf })
    vim.keymap.set('n', '$', 'g$', { buffer = buf })

    -- Re-evaluate blacklist on every cursor move / insert entry.
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter' }, {
      group = pencil_group,
      buffer = buf,
      callback = function() refresh_autoformat(hard_textwidth) end,
    })

    -- Set markdown-specific surrounding in 'mini.surround'
    vim.b.minisurround_config = {
      custom_surroundings = {
        -- Markdown link. Common usage:
        -- `saiwL` + [type/paste link] + <CR> - add link
        -- `sdL` - delete link
        -- `srLL` + [type/paste link] + <CR> - replace link
        L = {
          input = { '%[().-()%]%(.-%)' },
          output = function()
            local link = require('mini.surround').user_input 'Link: '
            return { left = '[', right = '](' .. link .. ')' }
          end,
        },
      },
    }
  end,
})

--
-- Markdown
--

local fn = require 'custom.fn'

local azure_org = vim.env.ADO_ORGANIZATION
local azure_project = vim.env.ADO_PROJECT

local function open_azure_devops_link_under_cursor()
  local number = vim.fn.expand '<cword>'
  if tonumber(number) then
    local url = string.format('https://dev.azure.com/%s/%s/_workitems/edit/%s', azure_org, azure_project, number)
    vim.ui.open(url)
  else
    print 'No valid number under cursor'
  end
end

vim.api.nvim_create_user_command('AzureDevOpsOpen', open_azure_devops_link_under_cursor, {})
vim.keymap.set('n', 'gX', open_azure_devops_link_under_cursor, { desc = 'Open Azure DevOps link' })

vim.pack.add {
  fn.gh 'MeanderingProgrammer/render-markdown.nvim',
  fn.gh 'iamcco/markdown-preview.nvim',
}
