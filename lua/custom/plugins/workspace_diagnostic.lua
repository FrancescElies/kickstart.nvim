-- good for getting lsp diagnostics accross the whole project
local function open_similar_files()
  local root = vim.fs.root(0, '.git')

  local files = vim.fn.split(vim.system({ 'git', 'ls-files' }, { text = true, cwd = root }):wait().stdout, '\n')
  for i, file in ipairs(files) do
    files[i] = vim.fs.joinpath(root, file)
  end

  local buf = vim.api.nvim_get_current_buf()
  local buffers = {}
  for _, buffer in pairs(vim.api.nvim_list_bufs()) do
    buffers[vim.fs.normalize(vim.api.nvim_buf_get_name(buffer))] = true
  end
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })

  files = vim.tbl_filter(function(path)
    return vim.fn.filereadable(path) == 1
  end, files)

  files = vim.tbl_map(function(path)
    return vim.fn.fnamemodify(path, ':p')
  end, files)

  for _, path in pairs(files) do
    if vim.fn.fnamemodify(path, ':e') == filetype then
      if not buffers[path] then
        local buffer = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(buffer, path)
        vim.api.nvim_buf_call(buffer, vim.cmd.edit)
      end
    end
  end
end

vim.api.nvim_create_user_command('OpenSimilarFiles', open_similar_files, {})

vim.keymap.set('n', '<leader>bs', '<cmd>OpenSimilarFiles<cr>', { desc = '[b]uffer open [s]imilar files' })

-- vim.api.nvim_set_keymap('n', '<leader>x', '', {
--   noremap = true,
--   desc = 'worksapce diagnostics',
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
--       require('workspace-diagnostics').populate_workspace_diagnostics(client, 0)
--     end
--   end,
-- })

return {
  -- 'artemave/workspace-diagnostics.nvim',
}
