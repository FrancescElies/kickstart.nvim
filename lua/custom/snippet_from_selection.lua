--[[
  Creates a LuaSnip snippet from the visual selection.

  USAGE
    <localleader>S          -- visual mode: ask for a trigger, save the selection as snippet

  The snippet is appended to lua/custom/snippets/<filetype>.lua (the file that already registers
  snippets for the filetype, or a new <filetype>.lua) and is available right away.
  Edit the file afterwards to turn parts of the text into insert nodes, e.g. ls.insert_node(1).
]]

local M = {}

local SNIPPETS_DIR = vim.fn.stdpath 'config' .. '/lua/custom/snippets/'

-- Lua single quoted string literal
local function quote(line)
  local escaped = line:gsub('\\', '\\\\'):gsub("'", "\\'"):gsub('\t', '\\t')
  return "'" .. escaped .. "'"
end

-- remove the indentation shared by all lines; a charwise selection starts mid line, so its first
-- line is left alone
local function dedent(lines, linewise)
  local first = linewise and 1 or 2
  local min_indent
  for index = first, #lines do
    if lines[index]:match '%S' then
      local indent = #lines[index]:match '^%s*'
      min_indent = math.min(min_indent or indent, indent)
    end
  end
  if not min_indent or min_indent == 0 then return lines end
  for index = first, #lines do
    lines[index] = lines[index]:sub(min_indent + 1)
  end
  return lines
end

-- the file that already registers snippets for `filetype`, else <filetype>.lua
local function snippet_file(filetype)
  local pattern = "add_snippets%s*%(?%s*['\"]" .. vim.pesc(filetype) .. "['\"]"
  for _, path in ipairs(vim.fn.glob(SNIPPETS_DIR .. '*.lua', false, true)) do
    local file = io.open(path, 'r')
    if file then
      local content = file:read '*a'
      file:close()
      if content:find(pattern) then return path end
    end
  end
  return SNIPPETS_DIR .. filetype .. '.lua'
end

local function append_snippet(path, filetype, trigger, lines)
  local block = { '', "ls.add_snippets(" .. quote(filetype) .. ', {', '  ls.snippet(' .. quote(trigger) .. ', {', '    ls.text_node {' }
  for _, line in ipairs(lines) do
    table.insert(block, '      ' .. quote(line) .. ',')
  end
  vim.list_extend(block, { '    },', '    ls.insert_node(0),', '  }),', '})', '' })

  vim.fn.mkdir(SNIPPETS_DIR, 'p')
  local existing = vim.fn.filereadable(path) == 1 and vim.fn.readfile(path) or {}
  if not table.concat(existing, '\n'):find 'local ls = require' then
    table.insert(existing, 1, "local ls = require 'luasnip'")
  end
  vim.list_extend(existing, block)
  vim.fn.writefile(existing, path)
end

---Visual mode: save the selection as snippet.
function M.create()
  local mode = vim.fn.mode()
  local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = mode })
  vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'nx', false)
  if #lines == 0 then return end
  lines = dedent(lines, mode == 'V')

  local filetype = vim.bo.filetype ~= '' and vim.bo.filetype or 'all'
  vim.ui.input({ prompt = 'Snippet trigger (' .. filetype .. '): ' }, function(trigger)
    if not trigger or trigger == '' then return end
    local path = snippet_file(filetype)
    append_snippet(path, filetype, trigger, lines)

    -- available now, the file is loaded on the next start
    local ls = require 'luasnip'
    ls.add_snippets(filetype, { ls.snippet(trigger, ls.text_node(lines)) })
    vim.notify(("Snippet '%s' added to %s"):format(trigger, vim.fn.fnamemodify(path, ':~')))
  end)
end

return M
