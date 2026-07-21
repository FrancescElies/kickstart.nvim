local function json_key_path()
  local bufnr = 0
  local node = vim.treesitter.get_node()

  if not node then
    vim.notify('No Treesitter node', vim.log.levels.ERROR)
    return
  end

  local parts = {}

  while node do
    local t = node:type()

    if t == 'pair' then
      local key_node = node:child(0)
      if key_node then
        local key = vim.treesitter.get_node_text(key_node, bufnr)
        key = key:gsub('^"', ''):gsub('"$', '')
        table.insert(parts, 1, key)
      end
    end

    node = node:parent()
  end

  local path = table.concat(parts, '.')
  vim.fn.setreg('+', path)
  vim.notify('Yanked: ' .. path)
end

vim.keymap.set('n', '<localleader>k', json_key_path, { desc = '[k]ey path' })
