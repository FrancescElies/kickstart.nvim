--https://github.com/akinsho/toggleterm.nvim

-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', 'jk', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-w><C-h>', '<cmd>wincmd h<cr>', { desc = 'go left window' })
vim.keymap.set('t', '<C-w><C-j>', '<cmd>wincmd j<cr>', { desc = 'go lower window' })
vim.keymap.set('t', '<C-w><C-k>', '<cmd>wincmd k<cr>', { desc = 'go upper window' })
vim.keymap.set('t', '<C-w><C-l>', '<cmd>wincmd l<cr>', { desc = 'go right window' })
vim.keymap.set('t', '<C-w><C-w>', '<cmd>wincmd w<cr>', { desc = 'go other window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

local set = vim.opt_local

--
-- https://github.com/tjdevries/advent-of-nvim/blob/master/nvim/plugin/floaterminal.lua
--
local state = {
  tgpt = {
    buf = -1,
    win = -1,
  },
  bottomterm = {
    buf = -1,
    win = -1,
  },
  floatterm = {
    buf = -1,
    win = -1,
  },
}

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
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = { '*' },
  group = group,
  callback = function()
    if vim.opt.buftype:get() == 'terminal' then
      vim.cmd ':startinsert'
    end
  end,
})

local function win_stick_to_bottom(opts)
  opts = opts or {}
  local win = opts.win or 0
  vim.api.nvim_set_current_win(win)
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(win, 15)
end

--- Open a terminal at the bottom of the screen with a fixed height.
local function bottom_term(opts)
  opts = opts or {}
  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  -- Create  window
  local win_config = {
    split = 'left',
    win = 0,
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  win_stick_to_bottom { win = win }

  return { buf = buf, win = win }
end

local function send_line_to_bottom_term()
  vim.fn.chansend(TERM_CHANNELNR, { vim.api.nvim_get_current_line() .. '\r\n' })
end

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
    buf = vim.api.nvim_create_buf(false, true)
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

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floatterm.win) then
    state.floatterm = create_floating_window { buf = state.floatterm.buf }
    if vim.bo[state.floatterm.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floatterm.win)
  end
end

local function toggle_tgpt()
  if not vim.api.nvim_win_is_valid(state.tgpt.win) then
    state.tgpt = create_floating_window { buf = state.tgpt.buf }
    if vim.bo[state.tgpt.buf].buftype ~= 'terminal' then
      vim.fn.jobstart('tgpt -i', { term = true })
    end
  else
    vim.api.nvim_win_hide(state.tgpt.win)
  end
end

local function toggle_bottomterm()
  if not vim.api.nvim_win_is_valid(state.bottomterm.win) then
    state.bottomterm = bottom_term { buf = state.bottomterm.buf }
    if vim.bo[state.bottomterm.buf].buftype ~= 'terminal' then
      vim.wo.winfixheight = true
      vim.cmd.terminal()
      TERM_CHANNELNR = vim.bo.channel
    end
  else
    vim.api.nvim_win_hide(state.bottomterm.win)
  end
end

vim.api.nvim_create_user_command('FloatTerm', toggle_terminal, {}) -- Create a floating window with default dimensions
vim.api.nvim_create_user_command('SmallTermResetSize', win_stick_to_bottom, {}) -- Create a floating window with default dimensions

-- <C-,><C-p><C-m> feels right <open floaterm> then get <previous command> and <enter> without releasing CTRL
vim.keymap.set({ 'n', 't' }, '<C-,>', '<cmd>FloatTerm<cr>', { desc = 'float term' })
-- Binding for alacritty, check which char `=vim.fn.getchar()`
vim.keymap.set({ 'n', 't' }, '\u{f8ff}', '<cmd>FloatTerm<cr>', { desc = 'float term' })
vim.keymap.set({ 'n', 't' }, ',.', '<cmd>:startinsert<cr><C-p><cr>', { desc = '[r]epeat last comamnd' })
vim.keymap.set({ 'n', 't' }, ',f', '<cmd>FloatTerm<cr>', { desc = '[f]loat term' })
vim.keymap.set({ 'n', 't' }, ',v', '<cmd>vsplit|term<cr>')
vim.keymap.set({ 'n', 't' }, ',s', '<cmd>split|term<cr>')
vim.keymap.set({ 'n', 't' }, ',b', toggle_bottomterm, { desc = '[b]ottom term' })
vim.keymap.set({ 'n', 't' }, ',b', win_stick_to_bottom, { desc = '[b]ottom term' })
vim.keymap.set({ 'n', 't' }, ',l', send_line_to_bottom_term, { desc = '[l]ine to bottom term' })
vim.keymap.set({ 'n', 't' }, ',q', '<cmd>bd!<cr>')
-- <C-r> doesn't work in terminal mode, it will perform `reverse search`
-- vim.keymap.set('t','sr', "'<C-\\><C-N>\"'.nr2char(getchar()).'pi'", { desc = '<C-r> fellow' })

vim.keymap.set({ 'n', 't' }, ',c', toggle_tgpt, { desc = 'c[h]atgpt' })

return {}
