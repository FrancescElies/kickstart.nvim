--https://github.com/akinsho/toggleterm.nvim

-- <C-r> doesn't work in terminal mode, it will perform `reverse search`
vim.keymap.set('t', '<A-r>', "'<C-\\><C-N>\"'.nr2char(getchar()).'pi'", { desc = '<C-r> fellow' })

-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-w><C-h>', '<cmd>wincmd h<cr>', { desc = 'go left window' })
vim.keymap.set('t', '<C-w><C-j>', '<cmd>wincmd j<cr>', { desc = 'go lower window' })
vim.keymap.set('t', '<C-w><C-k>', '<cmd>wincmd k<cr>', { desc = 'go upper window' })
vim.keymap.set('t', '<C-w><C-l>', '<cmd>wincmd l<cr>', { desc = 'go right window' })
vim.keymap.set('t', '<C-w><C-w>', '<cmd>wincmd w<cr>', { desc = 'go other window' })
-- vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
-- vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
-- vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
-- vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

local set = vim.opt_local

local function create_tgpt_window()
  vim.cmd.new()
  WIDTH = vim.api.nvim_get_option 'columns'
  HEIGHT = vim.api.nvim_get_option 'lines'
  vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    relative = 'editor',
    width = math.floor(WIDTH * 0.2),
    height = math.floor(HEIGHT * 0.9),
    col = WIDTH,
    row = 0,
    anchor = 'NE',
    style = 'minimal',
    border = 'single',
  })
end

--- Open a terminal at the bottom of the screen with a fixed height.
local function tgpt()
  create_tgpt_window()
  vim.wo.winfixheight = true
  vim.fn.termopen('tgpt -i', {
    on_exit = function()
      local win_id = vim.api.nvim_get_current_win()
      vim.api.nvim_win_close(win_id, true)
    end,
  })
end

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
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  pattern = { '*' },
  group = group,
  callback = function()
    if vim.opt.buftype:get() == 'terminal' then
      vim.cmd ':startinsert'
    end
  end,
})

local function small_term_reset_size()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
end

--- Open a terminal at the bottom of the screen with a fixed height.
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

-- <C-,> (open floaterm) feels right when combined with <C-p> (previous command) and <C-m> (enter)
vim.keymap.set({ 'n', 't' }, '<C-,>', '<cmd>SmallFloatTerm<cr>', { desc = 'float term' })
-- Binding for alacritty, check which char `=vim.fn.getchar()`
vim.keymap.set({ 'n', 't' }, '\u{f8ff}', '<cmd>SmallFloatTerm<cr>', { desc = 'float term' })
-- vim.keymap.set('', '\u{f8fe}', '<C-Space>')
-- vim.keymap.set('', '\u{f8fe}', function()
--   print 'Control-Space pressed!'
-- end, { noremap = true, silent = false })

vim.keymap.set('n', 'sh', tgpt, { desc = '[s]mallc[h]atgpt' })
vim.keymap.set({ 'n', 't' }, 'sl', '<cmd>SmallFloatTerm<cr>', { desc = '[s]mall f[l]oat term' }) -- sf taken by mini.surround
vim.keymap.set('n', 'sT', small_term_send_line, { desc = 'send line to [s]mall[t]erm' })
vim.keymap.set('n', 'st', small_term, { desc = '[s]mall[t]erm' })

vim.api.nvim_create_user_command('SmallFloatTerm', toggle_terminal, {}) -- Create a floating window with default dimensions
vim.api.nvim_create_user_command('SmallTermResetSize', small_term_reset_size, {}) -- Create a floating window with default dimensions

return {}
