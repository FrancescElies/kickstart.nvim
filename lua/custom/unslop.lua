--[[
  Strips common "AI-sounding" writing tics from text in the current
  buffer or visual selection.

  USAGE
    :Unslop                 -- clean the whole buffer
    :'<,'>Unslop            -- clean a visual selection
    <localleader>u          -- normal mode: clean whole buffer
    <localleader>u          -- visual mode: clean selection
]]

local M = {}

-- Ordered {pattern, replacement} rules. Order matters.
local RULES = {
  -- Dashes used as sentence connectors
  { '%s*—%s*', ', ' },
  { '%s*–%s*', ', ' },
  { '%-%-%-?', ', ' },

  -- Curly quotes -> straight quotes
  -- NOTE: each quote char is its own literal pattern, NOT bundled into a
  -- [...] class. Lua patterns are byte-based, and bracketing multi-byte
  -- UTF-8 chars together splits them into individual bytes, which can
  -- accidentally match stray bytes inside unrelated UTF-8 chars (e.g. the
  -- second byte of "Ü" collided with a byte from the quote set).
  { '“', '"' },
  { '”', '"' },
  { '‘', "'" },
  { '’', "'" },

  -- Throat-clearing openers
  { '^%s*Certainly!?%s*', '' },
  { '^%s*Of course!?%s*', '' },
  { '^%s*I hope this (helps|finds you well)!?%s*', '' },
  { '^%s*Great question!?%s*', '' },
  { '^%s*Sure,?%s*', '' },

  -- Stock filler / hedging phrases
  { "[Ii]t'?s not just [%w%s]+, it'?s ", '' },
  { "[Ii]n today'?s [%w%s]+, ", '' },
  { "[Ii]t'?s important to note that ", '' },
  { "[Ii]t'?s worth noting that ", '' },
  { '[Aa]t the end of the day, ', '' },
  { '[Ww]hen it comes to ', 'for ' },
  { '[Bb]oils down to ', 'comes down to ' },
  { '[Dd]elve into', 'look at' },
  { '[Nn]avigate the (complexities|landscape) of', 'handle' },
  { '[Uu]nlock the (full )?potential of', 'make better use of' },
  { '[Ff]oster a sense of', 'build' },
  { '[Ee]lev[a-z]+ your', 'improve your' },
  { '[Tt]estament to', 'example of' },
  { '[Ii]n conclusion,%s*', '' },
  { '[Oo]verall,%s*', '' },

  -- Closing filler
  { '%s*I hope this helps!?%s*$', '' },
  { '%s*Let me know if you have any (other |further )?questions!?%s*$', '' },
  { '%s*Feel free to reach out!?%s*$', '' },

  -- Whitespace cleanup
  { '  +', ' ' },
  { '%s+$', '' },
  { '^%s+', '' },
}

--- Clean a single string.
function M.clean(text, opts)
  opts = opts or {}
  local result = text
  for _, rule in ipairs(RULES) do
    local pattern = rule[1]
    if opts.keep_dashes and (pattern:find '—' or pattern:find '–' or pattern:find '%-%-') then
      -- skip
    else
      result = result:gsub(pattern, rule[2])
    end
  end
  return result
end

-- Clean a range of lines in a buffer (1-indexed, inclusive), preserving
-- line breaks by cleaning per-line (dash/quote/phrase rules are line-safe).
local function clean_lines(bufnr, start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
  for i, line in ipairs(lines) do
    lines[i] = M.clean(line)
  end
  vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, lines)
end

function M.setup(opts)
  opts = opts or {}

  vim.api.nvim_create_user_command('Unslop', function(cmd_opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local start_line, end_line

    if cmd_opts.range == 2 then
      start_line, end_line = cmd_opts.line1, cmd_opts.line2
    else
      start_line, end_line = 1, vim.api.nvim_buf_line_count(bufnr)
    end

    clean_lines(bufnr, start_line, end_line)
    vim.notify(string.format('Unslop: cleaned lines %d-%d', start_line, end_line))
  end, { range = true, desc = 'Strip AI writing tics from buffer or selection' })

  local keymap = opts.keymap
  vim.keymap.set('n', keymap, ':Unslop<CR>', { desc = 'Unslop buffer', silent = true })
  vim.keymap.set('v', keymap, ':Unslop<CR>', { desc = 'Unslop selection', silent = true })
end

return M
