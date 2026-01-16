local azure_org = vim.env.ADO_ORGANIZATION
local azure_project = vim.env.ADO_PROJECT

local function open_azure_devops_link_under_cursor()
  local number = vim.fn.expand '<cword>'
  if tonumber(number) then
    local url = string.format('https://dev.azure.com/%s/%s/_workitems/edit/%s', azure_org, azure_project, number)
    vim.ui.open(url)
  else
    print 'No valid number under cursor'
  end
end

vim.api.nvim_create_user_command('AzureDevOpsOpen', open_azure_devops_link_under_cursor, {})
vim.keymap.set('n', 'gX', open_azure_devops_link_under_cursor, { desc = 'Open Azure DevOps link' })

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
