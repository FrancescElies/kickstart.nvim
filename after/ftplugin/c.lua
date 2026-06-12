vim.keymap.set('n', 'gh', ':e %:r.h<cr>', { desc = 'goto [%.h] file' })
vim.keymap.set('n', 'gc', ':e %:r.c<cr>', { desc = 'goto [%.c] file' })

-- vim.bo.formatprg = "clang-format --assume-filename=" .. vim.fn.expand("%")
-- Then select lines and press gq — but plain formatprg reformats exactly the selected lines

vim.keymap.set('x', '<leader>f', function()
  local s = vim.fn.line 'v'
  local e = vim.fn.line '.'
  if s > e then
    s, e = e, s
  end
  vim.cmd(string.format('%d,%d!clang-format --assume-filename=%s --lines=%d:%d', s, e, vim.fn.expand '%:p', s, e))
end, { desc = 'clang [f]ormat selection' })

vim.api.nvim_create_user_command('FormatChangedLines', function()
  local buf = 0
  local file = vim.fn.expand '%:p'

  -- 1. Collect modified line ranges from gitsigns (buffer coordinates)
  local ok, gs = pcall(require, 'gitsigns')
  if not ok then
    vim.notify('gitsigns not available', vim.log.levels.ERROR)
    return
  end
  local hunks = gs.get_hunks(buf) or {}
  if vim.tbl_isempty(hunks) then
    vim.notify('No modified lines', vim.log.levels.INFO)
    return
  end

  -- 2. Build clang-format args: one --lines=start:end per added/changed hunk
  local args = { 'clang-format', '--assume-filename=' .. file }
  for _, h in ipairs(hunks) do
    if h.added and h.added.count > 0 then
      local s = h.added.start
      local e = s + h.added.count - 1
      table.insert(args, string.format('--lines=%d:%d', s, e))
    end
  end
  if #args == 2 then return end -- only deletions, nothing to format

  -- 3. Pipe current buffer through clang-format, replace in place (keeps undo)
  local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
  local out = vim.system(args, { stdin = input }):wait()
  if out.code ~= 0 then
    vim.notify('clang-format failed: ' .. (out.stderr or ''), vim.log.levels.ERROR)
    return
  end
  local lines = vim.split(out.stdout, '\n')
  if lines[#lines] == '' then table.remove(lines) end -- drop trailing newline
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end, { desc = 'clang-format only modified lines in current buffer' })
