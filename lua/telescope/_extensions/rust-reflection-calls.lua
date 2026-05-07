local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

-- WIP: TODO
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')

local async_picker = function()
  local results = {} -- Table to hold results

  -- Define your async function
  local function async_function(prompt)
    -- Simulate a long-running task
    vim.defer_fn(function()
      local qf = rust_functions_and_reflection_calls(prompt)
      table.insert(results, "Result for: " .. prompt)
    end, 5000)
  end

  pickers.new({}, {
    prompt_title = "Async Picker",
    finder = finders.new_table {
      results = results,
    },
    sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local selection = actions.get_selected_entry()
        async_function(selection.value)
        actions.close(prompt_bufnr)
      end)
      return true
    end,
  }):find()
end
vim.api.nvim_create_user_command("TelescopeRustFunctionsAndReflectionCalls", async_picker, { nargs = 0 })
