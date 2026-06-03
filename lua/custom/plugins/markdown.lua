local fn = require 'custom.fn'

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

vim.pack.add {
  fn.gh 'MeanderingProgrammer/render-markdown.nvim',
  fn.gh 'iamcco/markdown-preview.nvim',
}
