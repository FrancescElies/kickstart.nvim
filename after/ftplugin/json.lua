local function json_path_at_cursor()
  local node = vim.treesitter.get_node()
  if not node then
    vim.notify('No treesitter node at cursor (run :TSInstall json)', vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local parts = {}

  while node do
    local parent = node:parent()
    if not parent then break end

    local ptype = parent:type()

    if ptype == 'pair' then
      local key_field = parent:field('key')[1]
      local val_field = parent:field('value')[1]
      if node == key_field or node == val_field then
        local key_text = vim.treesitter.get_node_text(key_field, bufnr)
        key_text = key_text:gsub('^"(.*)"$', '%1')
        table.insert(parts, 1, '.' .. key_text)
      end
    elseif ptype == 'array' then
      local idx = 0
      for i = 0, parent:named_child_count() - 1 do
        if parent:named_child(i) == node then
          idx = i
          break
        end
      end
      table.insert(parts, 1, '[' .. idx .. ']')
    end

    node = parent
  end

  local path = '$' .. table.concat(parts)
  vim.fn.setreg('+', path)
  vim.notify('JSONPath: ' .. path, vim.log.levels.INFO)
  return path
end

vim.keymap.set('n', '<localleader>p', json_path_at_cursor, { desc = 'Yank JSONPath under cursor' })
