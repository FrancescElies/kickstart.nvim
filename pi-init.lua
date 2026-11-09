-- Minimal nvim for pi's externalEditor: LuaSnip + markdown ftplugin only.
-- Used via: nvim -u <this file>
local cfg = vim.fn.stdpath 'config'
vim.opt.runtimepath:prepend(cfg) -- lua/custom/*, after/ftplugin/markdown.lua
for _, p in ipairs { 'LuaSnip', 'plenary.nvim', 'telescope.nvim' } do
  vim.opt.runtimepath:append(vim.fn.stdpath 'data' .. '/site/pack/core/opt/' .. p)
end
vim.cmd 'filetype plugin indent on'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local ls = require 'luasnip'
ls.setup {}
for _, p in ipairs(vim.api.nvim_get_runtime_file('lua/custom/snippets/*.lua', true)) do
  loadfile(p)()
end
require('luasnip.loaders.from_lua').lazy_load { include = { 'all', 'markdown' } }

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  callback = function() vim.bo.filetype = 'markdown' end,
})

require('custom.at_file_mention').setup {
  filetypes = { 'markdown', 'markdown.mdx' },
  picker = { hidden = true, follow = true },
}
