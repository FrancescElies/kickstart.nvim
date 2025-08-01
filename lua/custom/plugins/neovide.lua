--
-- Neovide
--
if vim.g.neovide then
  -- https://www.nerdfonts.com/font-downloads
  vim.o.guifont = 'IntoneMono Nerd Font:h12'
  -- vim.o.guifont = 'FiraCode Nerd Font:h12'
  -- vim.o.guifont = 'JetBrainsMono Nerd Font:h12'
  -- vim.g.neovide_cursor_vfx_mode = 'torpedo' -- railgun, torpedo, sonicboom, ripple, wireframe
  vim.keymap.set('n', '<f11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)
  -- vim.g.neovide_antialiasing = true

  local copy_key = '<C-S-C>'
  local paste_key = '<C-S-V>'

  vim.keymap.set('v', copy_key, '"+y') -- Copy
  vim.keymap.set('n', paste_key, '"+P') -- Paste normal mode
  vim.keymap.set('v', paste_key, '"+P') -- Paste visual mode
  vim.keymap.set('c', paste_key, '<C-R>+') -- Paste command mode
  vim.keymap.set('i', paste_key, '<ESC>l"+Pli') -- Paste insert mode

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set('n', '<M-=>', function()
    change_scale_factor(1.10)
  end)
  vim.keymap.set('n', '<M-->', function()
    change_scale_factor(1 / 1.10)
  end)
  vim.keymap.set('n', '<M-0>', function()
    vim.g.neovide_scale_factor = 1.0
  end)

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', paste_key, '+p<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('!', paste_key, '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', paste_key, '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', paste_key, '<C-R>+', { noremap = true, silent = true })
end

return {}
