local function json_key_path()
  local bufnr = 0
  local node = vim.treesitter.get_node()
  local root = node:tree():root()

  if not node then
    vim.notify('No Treesitter node', vim.log.levels.ERROR)
    return
  end

  local parts = {}

  local cur = root

  while cur do
    local child = cur:child_with_descendant(node)
    if not child or child:id() == cur:id() then break end
    local t = child:type()
    -- Seen types: array pair object string string_content

    if t == 'pair' then
      local key_node = node:child(0)
      if key_node then
        local key = vim.treesitter.get_node_text(key_node, bufnr)
        key = key:gsub('^"', ''):gsub('"$', '')
        table.insert(parts, 1, key)
      end
    elseif t == 'object' then
      print('DEBUGPRINT[232]: json.lua:28: t=' .. vim.inspect(t))
    else
      print('DEBUGPRINT[231]: json.lua:30: t= unhandled' .. vim.inspect(t))
    end

    cur = child
  end

  local path = table.concat(parts, '.')
  vim.fn.setreg('+', path)
  vim.notify('Yanked: ' .. path)
end

vim.api.nvim_create_user_command('JsonKeyPath', json_key_path, {})
vim.keymap.set('n', '<localleader>k', json_key_path, { buffer = 0, desc = '[k]ey path' })
