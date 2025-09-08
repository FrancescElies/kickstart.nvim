--https://github.com/akinsho/toggleterm.nvim

-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-w><C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-w><C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-w><C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-w><C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
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

-- NOTE: forces term every time to scroll to the bottom
-- -- make sure we are on insert mode when entering the terminal
-- vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
--   pattern = { '*' },
--   group = group,
--   callback = function()
--     if vim.opt.buftype:get() == 'terminal' then
--       vim.cmd ':startinsert'
--     end
--   end,
-- })

local function small_term_reset_size()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
end

local function small_term()
  vim.cmd.new()
  small_term_reset_size()
  vim.wo.winfixheight = true
  vim.cmd.term()
  TERM_CHANNELNR = vim.bo.channel
end

local function small_term_send_line()
  vim.fn.chansend(TERM_CHANNELNR, { vim.api.nvim_get_current_line() .. '\r\n' })
end

--
-- https://github.com/tjdevries/advent-of-nvim/blob/master/nvim/plugin/floaterminal.lua
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal', -- No borders or extra UI elements
    border = 'rounded',
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {}) -- Create a floating window with default dimensions

-- <C-,> (open floaterm) feels right when combined with <C-p> (previous command) and <C-m> (enter)
vim.keymap.set({ 'n', 't' }, '<C-,>', '<cmd>SmallFloatTerm<cr>', { desc = 'float term' })
vim.keymap.set({ 'n', 't' }, 'sf', '<cmd>Floaterminal<cr>', { desc = 'float term' })
-- Binding for alacritty, check which char `=vim.fn.getchar()`
vim.keymap.set({ 'n', 't' }, '\u{f8ff}', '<cmd>Floaterminal<cr>', { desc = 'float term' })
vim.keymap.set('n', '<M-f>', '<cmd>Floaterminal<cr>', { desc = '[f]loat term' })
vim.keymap.set('n', '<leader>tf', '<cmd>Floaterminal<cr>', { desc = '[f]loat term' })

vim.keymap.set('n', 'sl', small_term_send_line, { desc = '[l]ine to smallterm' })
vim.keymap.set('n', 'st', small_term, { desc = '[s]mallterm' }) -- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set('n', 'sr', small_term_reset_size, { desc = '[r]eset size smallterm' })

return {}
