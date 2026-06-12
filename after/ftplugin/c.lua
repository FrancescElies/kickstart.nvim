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

