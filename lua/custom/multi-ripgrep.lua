-- https://github.com/tjdevries/config.nvim/blob/master/lua/custom/telescope/multi-ripgrep.lua

local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local pickers = require 'telescope.pickers'

local flatten = vim.tbl_flatten

-- i would like to be able to do telescope
-- and have telescope do some filtering on files and some grepping
return function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.shortcuts = opts.shortcuts
    or {
      ['c'] = '*.c',
      ['g'] = '*.go',
      ['j'] = '*.{js,ts,tsx,svelte,json}',
      ['l'] = '*.lua',
      ['max'] = '*.{maxpat,json}',
      ['m'] = '*.md',
      ['n'] = '*.{vim,lua}',
      ['p'] = '*.python',
      ['r'] = '*.{rs,toml}',
      ['v'] = '*.vim',
    }
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

      return flatten {
        args,
        { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Live Grep (with shortcuts (c,g,j,l,m,max,n.p.r.v))',
      finder = custom_grep,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end
