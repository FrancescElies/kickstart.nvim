-- Usage:
--   :UniqueWords                      -> default (case-insensitive, sorted)
--   :UniqueWords nosort               -> keep original first-seen order
--   :UniqueWords case                 -> case-sensitive
--   :UniqueWords minlen=3             -> ignore words shorter than 3
--   :UniqueWords buf                  -> replace current buffer with results
--   :UniqueWords reg=+                -> also copy results to register + (system clipboard)
--
-- Words are matched with [%w-_]+ (alnum + underscore).

local function unique_words(opts)
  -- Parse args (simple flags & key=value pairs)
  local args = {}
  for token in string.gmatch(opts.args or '', '%S+') do
    local k, v = string.match(token, '^(%w+)=([^%s]+)$')
    if k and v then
      args[k] = v
    else
      args[token] = true
    end
  end

  local case_sensitive = args.case and true or false
  local sort_output = args.nosort and false or true
  local write_to_buf = args.buf and true or false
  local minlen = tonumber(args.minlen) or 1
  local yank_reg = args.reg -- e.g. "+", "*", "a"

  -- Read buffer text
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, ' ')

  -- Choose normalization based on case sensitivity
  local normalize = function(w)
    return case_sensitive and w or string.lower(w)
  end

  -- Collect words
  local seen = {}
  local collected = {}
  for w in string.gmatch(text, '[%w-_]+') do
    if #w >= minlen then
      local key = normalize(w)
      if not seen[key] then
        seen[key] = true
        table.insert(collected, w) -- keep original casing in output
      end
    end
  end

  -- Sort if requested (case-aware natural-ish sort)
  if sort_output then
    table.sort(collected, function(a, b)
      if case_sensitive then
        return a < b
      else
        local la, lb = a:lower(), b:lower()
        if la == lb then
          return a < b
        end
        return la < lb
      end
    end)
  end

  -- Prepare output lines
  local out = collected

  if write_to_buf then
    -- Replace current buffer content (make it a scratch buffer)
    vim.api.nvim_buf_set_option(0, 'modifiable', true)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
    -- Optional: mark as nofile to avoid accidental writes
    pcall(vim.api.nvim_buf_set_option, 0, 'buftype', 'nofile')
    pcall(vim.api.nvim_buf_set_option, 0, 'bufhidden', 'wipe')
    pcall(vim.api.nvim_buf_set_option, 0, 'swapfile', false)
  else
    -- Open in a new scratch buffer (vertical split if you prefer: use 'vnew')
    vim.cmd 'new'
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
    pcall(vim.api.nvim_buf_set_option, buf, 'buftype', 'nofile')
    pcall(vim.api.nvim_buf_set_option, buf, 'bufhidden', 'wipe')
    pcall(vim.api.nvim_buf_set_option, buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  end

  -- Optionally yank to a register (e.g. system clipboard)
  if yank_reg and yank_reg ~= '' then
    local text_to_yank = table.concat(out, '\n')
    vim.fn.setreg(yank_reg, text_to_yank)
    vim.notify(('UniqueWords: yanked %d words to register %s'):format(#out, yank_reg), vim.log.levels.INFO)
  else
    vim.notify(('UniqueWords: %d words'):format(#out), vim.log.levels.INFO)
  end
end

vim.api.nvim_create_user_command('UniqueWords', function(opts)
  unique_words(opts)
end, { nargs = '*', desc = 'Extract unique words from current buffer' })

return {}
