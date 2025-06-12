local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local pickers = require 'telescope.pickers'

-- local flatten = vim.tbl_flatten

-- i would like to be able to do telescope
-- and have telescope do some filtering on files and some grepping
local pick_repo = function(opts)
  opts = opts or {}
  -- opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.cwd = vim.fn.expand '~/src'
  -- opts.pattern = opts.pattern or '%s'

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Select Repo',
      finder = finders.new_async_job {
        command_generator = function(prompt)
          if not prompt or prompt == '' then
            return nil
          end

          local cmd = { 'fd' }
          table.insert(cmd, '--type=d')
          table.insert(cmd, '--mapx-depth=1')
          table.insert(cmd, prompt)

          p(cmd)
          return cmd
        end,
        cwd = opts.cwd,
      },
      entry_maker = make_entry.gen_from_commands(opts),
      -- previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

-- pick_repo()

return pick_repo
