-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

local set = vim.opt_local

local group = vim.api.nvim_create_augroup('custom-term-open', {})
-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = group,
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0

    vim.bo.filetype = 'terminal'
  end,
})

-- make sure we are on insert mode when entering the terminal
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  pattern = { '*' },
  group = group,
  callback = function()
    if vim.opt.buftype:get() == 'terminal' then
      vim.cmd ':startinsert'
    end
  end,
})

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set('n', ',st', function()
  vim.cmd.new()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
  TERM_CHANNELNR = vim.bo.channel
end, { desc = 'small terminal' })

vim.keymap.set('n', ',sc', function()
  vim.fn.chansend(TERM_CHANNELNR, { vim.api.nvim_get_current_line() .. '\r\n' })
end, { desc = 'send command to term' })

return {}
