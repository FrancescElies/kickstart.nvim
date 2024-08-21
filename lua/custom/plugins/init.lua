-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- local Util = require 'lazy.core.util'

vim.lsp.inlay_hint.enable(true)

-- Commodity function to print stuff
function p(v)
  print(vim.inspect(v))
end

-- https://www.reddit.com/r/neovim/comments/zhweuc/whats_a_fast_way_to_load_the_output_of_a_command/
-- Example:
-- :Redir =vim.lsp.get_active_clients()
vim.api.nvim_create_user_command('Redir', function(ctx)
  local result = vim.api.nvim_exec2(ctx.args, { output = true })
  local lines = vim.split(result.output, '\n', { plain = true })
  vim.cmd 'new'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

local function get_git_root()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  return vim.fn.fnamemodify(dot_git_path, ':h')
end

vim.api.nvim_create_user_command('CdCurrentBufferDir', function()
  vim.api.nvim_set_current_dir(vim.fn.expand '%:p:h')
end, {})

vim.api.nvim_create_user_command('CdGitRoot', function()
  vim.api.nvim_set_current_dir(get_git_root())
end, {})

return {
  -- automatically follow symlinks
  { 'aymericbeaumet/vim-symlink', dependencies = { 'moll/vim-bbye' } },
}
