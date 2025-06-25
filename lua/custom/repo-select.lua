local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local conf = require('telescope.config').values
local action_state = require 'telescope.actions.state'
local actions = require 'telescope.actions'
local builtin = require 'telescope.builtin'

local project_dirs = {
  vim.fn.expand '~/src',
  vim.fn.expand '~/src/oss/',
  vim.fn.expand '~/src/work',
}

local function get_dirs_in(dir)
  return coroutine.wrap(function()
    local handle = vim.loop.fs_scandir(dir)
    if handle then
      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then
          break
        end
        if type == 'directory' then
          local project_path = vim.fs.joinpath(dir, name)
          if vim.fn.isdirectory(project_path) then
            coroutine.yield {
              name = name,
              path = project_path,
            }
          end
        end
      end
    end
  end)
end

local function get_projects()
  local projects = {}
  for _, dir in ipairs(project_dirs) do
    for project in get_dirs_in(dir) do
      if string.find(project.name, 'worktree') then
        for worktree in get_dirs_in(project.path) do
          worktree.name = vim.fs.joinpath(project.name, worktree.name)
          table.insert(projects, worktree)
        end
      end
      table.insert(projects, project)
    end
  end

  return projects
end

local function project_file_picker(opts)
  opts = opts or {}

  local projects = get_projects()

  if #projects == 0 then
    print 'No projects found in configured directories'
    return
  end

  pickers
    .new(opts, {
      prompt_title = 'Select Project',
      finder = finders.new_table {
        results = projects,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local project = selection.value

          -- Handled by an autocommand
          -- vim.cmd('cd ' .. project.path)

          builtin.find_files {
            prompt_title = 'Files in ' .. project.name,
            cwd = project.path,
            hidden = true,
            no_ignore = false,
          }
        end)
        return true
      end,
    })
    :find()
end

vim.api.nvim_create_user_command('TelescopeProjectFiles', function()
  project_file_picker()
end, {})

return {
  project_file_picker = project_file_picker,
}
