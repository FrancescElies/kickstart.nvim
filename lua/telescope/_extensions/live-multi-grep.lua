-- https://github.com/tjdevries/config.nvim/blob/master/lua/custom/telescope/multi-ripgrep.lua

local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local pickers = require 'telescope.pickers'

-- i would like to be able to do telescope
-- and have telescope do some filtering on files and some grepping
local function find(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  local default_shortcuts = {
    ['c'] = '*.{c,h,cpp,hpp}',
    ['h'] = '*.{h,hpp}',
    ['go'] = '*.go',
    ['js'] = '*.{js,ts,tsx,svelte,json}',
    ['lua'] = '*.lua',
    ['max'] = '*.{maxpat,json}',
    ['md'] = '*.md',
    ['py'] = '*.py',
    ['rs'] = '*.{rs,toml}',
    ['toml'] = '*.toml',
    ['ts'] = '*.{js,ts,tsx,svelte,json}',
    ['v'] = '*.vim',
    ['vl'] = '*.{vim,lua}',
    ['yaml'] = '*.{yml,yaml}',
  }

  opts.shortcuts = opts.shortcuts or default_shortcuts
  opts.pattern = opts.pattern or '%s'

  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local prompt_split = vim.split(prompt, '  ')

      local filter_pattern = prompt_split[1]
      local filter_shortcuts = prompt_split[2]

      local args = { 'rg' }
      if filter_pattern then
        table.insert(args, '-e')
        table.insert(args, filter_pattern)
      end

      if filter_shortcuts then
        table.insert(args, '-g')

        local pattern
        if opts.shortcuts[filter_shortcuts] then
          pattern = opts.shortcuts[filter_shortcuts]
        else
          pattern = filter_shortcuts
        end

        table.insert(args, string.format(opts.pattern, pattern))
      end

      -- local flatten = vim.tbl_flatten older vim versions
      return vim
        .iter({
          args,
          { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  local shortcuts_keys = {}
  local n = 1
  for k, _ in pairs(opts.shortcuts) do
    shortcuts_keys[n] = k
    n = n + 1
  end
  table.sort(shortcuts_keys)

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Live Grep (' .. table.concat(shortcuts_keys, ',') .. ')',
      finder = custom_grep,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

return require('telescope').register_extension {
  exports = {
    ['live-multi-grep'] = find,
  },
}
