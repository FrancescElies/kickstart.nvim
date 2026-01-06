vim.api.nvim_create_user_command('LspDetach', function(opts)
  local name = opts.args
  local clients = vim.lsp.get_clients { name = name }
  for _, client in ipairs(clients) do
    vim.lsp.buf_detach_client(0, client.id)
  end
end, {
  nargs = 1,
  desc = 'Detches lsp client from current buffer',
  complete = function(arg_lead, _, _)
    local unique_clients = {}
    local clients = {}
    for _, client in ipairs(vim.lsp.get_clients {}) do
      if unique_clients[client.name] ~= nil then
        table.insert(clients, client.name)
      end
      unique_clients[client.name] = true
    end

    if #arg_lead == 0 then
      return clients
    end

    local match = vim.fn.matchfuzzy(clients, arg_lead) -- Fuzzy filter based on partial input
    return match
  end,
})

return {}
