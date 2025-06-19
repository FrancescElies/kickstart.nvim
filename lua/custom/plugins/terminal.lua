--https://github.com/akinsho/toggleterm.nvim

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

local function reset_pane_size_mini_term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
end

local function mini_terminal()
  vim.cmd.new()
  reset_pane_size_mini_term()
  vim.wo.winfixheight = true
  vim.cmd.term()
  TERM_CHANNELNR = vim.bo.channel
end

local function send_line_to_mini_term()
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
vim.keymap.set({ 'n', 't' }, '<M-,>', '<cmd>Floaterminal<cr>', { desc = 'floating terminal' })

vim.keymap.set({ 'n', 't' }, '<M-s>', '<cmd>split|terminal<cr>', { desc = 'floating terminal' })
vim.keymap.set({ 'n', 't' }, '<M-v>', '<cmd>vsplit|terminal<cr>', { desc = 'floating terminal' })
vim.keymap.set({ 'n', 't' }, '<M-x>', '<cmd>bd!<cr>', { desc = 'close pane' })
vim.keymap.set('n', '<leader>tf', '<cmd>Floaterminal<cr>', { desc = 'floating terminal' })
vim.keymap.set('n', '<leader>th', '<cmd>split|terminal<cr>', { desc = 'floating terminal' })
vim.keymap.set('n', '<leader>tl', send_line_to_mini_term, { desc = 'mini[t]erm send [l]ine' })
vim.keymap.set('n', '<leader>tm', mini_terminal, { desc = '[m]ini[t]erm' }) -- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set('n', '<leader>tr', reset_pane_size_mini_term, { desc = 'mini[t]erm [r]esize' })
vim.keymap.set('n', '<leader>tv', '<cmd>vsplit|terminal<cr>', { desc = 'floating terminal' })

return {}
