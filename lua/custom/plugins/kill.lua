M = {}

---@param name string
local function kill_by_name(name)
  if vim.fn.has("win32") == 1 then
    vim.system({ "taskkill", "/IM", name, "/F" })
  else
    vim.system({ "pkill", "-f", name })
  end
end


if vim.fn.has("win32") == 1 then
  vim.keymap.set("n", "<leader>km", function() kill_by_name("Max.exe") end, { desc = "[k]ill [m]ax" })
end

return M
