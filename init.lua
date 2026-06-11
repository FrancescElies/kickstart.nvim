-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  --  See `:help vim.o`
  --  For more options, you can see `:help option-list`

  vim.o.number = true
  vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true

  -- [[ Basic Keymaps ]]

  -- Clear highlights on search when pressing <Esc> in normal mode
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config & Keymaps
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }


  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

local is_win32 = vim.fn.has 'win32' == 1
local is_unix = not is_win32

-- ============================================================
-- SECTION 2: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  --  See `:help vim.pack`, `:help vim.pack-examples` or the
  --  excellent blog post from the creator of vim.pack and mini.nvim:
  --
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'zig' == 1 then
        vim.system({ 'mkdir', 'build' }, { cwd = ev.data.path }):wait()
        local outfile = is_win32 and 'build/libfzf.dll' or 'build/libfzf.so'
        local cmd = {
          'zig',
          'cc',
          '-shared',
          '-O3',
          '-march=native',
          '-mtune=native',
          '-funroll-loops',
          '-fomit-frame-pointer',
          '-finline-functions',
          '-o',
          outfile,
          'src/fzf.c',
        }
        run_build(name, cmd, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if is_unix and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end

      if name == 'markdown-preview' then
        if vim.fn.executable 'npm' == 1 then run_build(name, { 'npm', 'install' }, ev.data.path) end
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Because lua is a real programming language, you can also have some logic to your installation -
  -- like only installing a plugin if a condition is met.
  --
  -- Here we only install `nvim-web-devicons` (which adds pretty icons) if we have a Nerd Font,
  -- since otherwise the icons won't display properly.
  if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

  -- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
  --
  -- See `:help gitsigns` to understand what each configuration key does.
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {

      { '<leader>C', group = '[C]hat' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>by', group = '[B]uffer [Y]ank' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
      { '<leader>g/', group = '[G]it [/]search', mode = { 'n', 'v' } },
      { '<leader>gd', group = '[G]it [D]iff', mode = { 'n', 'v' } },
      { '<leader>gdh', group = '[G]it [D]iff [H]istory', mode = { 'n', 'v' } },
      { '<leader>gw', group = '[G]it bro[w]se', mode = { 'n', 'v' } },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>l', group = '[L]ua' },
      { '<leader>n', group = '[N]otes' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]est' },
      -- { '<leader>t', group = '[T]oggle' },
      { '<leader>q', group = '[Q]uickfix' },
      { '<leader>v', group = '[V]im' },
      { 'Z', group = 'Session', mode = { 'n' } },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ Colorscheme ]]
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command under that to load whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = false }, -- Disable italics in comments
    },
    on_colors = function(color) color.comment = '#92b2d4' end,
    on_highlights = function(hl, color)
      hl.LineNr = { fg = color.green }
      hl.Comment = { fg = color.comment }
      hl.LineNrAbove = { fg = color.comment }
      hl.LineNrBelow = { fg = color.comment }
      hl.StatusLineNC = { fg = color.comment }
      hl.StatusLine = { fg = color.yellow }
      hl.DiagnosticUnnecessary = { fg = color.comment }
    end,
  }

  -- Load the colorscheme here.
  -- Like many other themes, this one has different styles, and you could load
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  vim.cmd.colorscheme 'tokyonight-night'

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup {
    signs = false,
    keywords = {
      ONHOLD = { icon = '🪝', color = '#ddbe0b', alt = { 'HALTED' } },
      WONT = { icon = '🛑', color = '#ab3e8f', alt = { 'HALTED' } },
      DONE = { icon = '', color = '#00a087', alt = { 'HALTED' } },
    },
  }

  -- [[ mini.nvim ]]
  --  A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sdb   - [S]urround [D]elete [B]alanced, either ], ) or }
  -- - sdq   - [S]urround [D]elete [q]uotes, either ' or "
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup {
    search_method = 'cover_or_next',
  }

  -- Simple and easy statusline.
  --  You could remove this setup call if you don't like it,
  --  and try some other statusline plugin
  local statusline = require 'mini.statusline'
  -- Set `use_icons` to true if you have a Nerd Font
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- You can configure sections in the statusline by overriding their
  -- default behavior. For example, here we set the section for
  -- cursor location to LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  -- ... and there is more!
  --  Check out: https://github.com/nvim-mini/mini.nvim
  require('mini.sessions').setup {}
  vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  vim.keymap.set('n', 'ZW', ':lua MiniSessions.write()<cr>', { desc = '[s]ession [w]rite' })
  vim.keymap.set('n', 'ZD', ':lua MiniSessions.delete()<cr>', { desc = '[s]ession [d]elete' })
  vim.keymap.set('n', 'ZS', ':lua MiniSessions.select()<cr>', { desc = '[s]ession [s]elect' })
  vim.keymap.set('n', 'ZR', ':lua MiniSessions.restart()<cr>', { desc = '[s]ession [r]estart' })

  require 'custom.mini-files'

  local mini_trailspace = require 'mini.trailspace'
  mini_trailspace.setup()
  vim.keymap.set('n', '<leader>bt', function() mini_trailspace.trim() end, { desc = '[b]uffer [t]railspaces' })

  -- - ga - [a]lign
  -- - gA - [a]lign with preview
  local mini_align = require 'mini.align'
  mini_align.setup()

  local hipatterns = require 'mini.hipatterns'

  local words = { red = '#aa0000', green = '#00aa00', blue = '#0000aa' }
  local word_color_group = function(_, match)
    local hex = words[match]
    if hex == nil then return nil end
    return hipatterns.compute_hex_color_group(hex, 'bg')
  end
  hipatterns.setup {
    highlighters = {
      fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
      hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
      todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
      note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
      hex_color = hipatterns.gen_highlighter.hex_color(),
      word_color = {
        pattern = '%S+',
        group = function(_, match)
          -- highlight words with certain colors
          local words = {
            red = '#c97c7c',
            green = '#7baf7b',
            blue = '#5b8db8',
            delegated = '#a0c4ff',
            waiting = '#a0a4dd',
            todo = '#ffd6a5',
            onhold = '#ddbe0b',
            inprogress = '#fdffb6',
            wont = '#ababab',
            done = '#caffbf',
          }
          local stripped = string.lower(match:gsub(':$', ''))
          local hex = words[stripped]
          if hex == nil then return nil end
          return hipatterns.compute_hex_color_group(hex, 'bg')
        end,
      },
      censor = {
        pattern = 'password: ()%S+()',
        group = '',
        extmark_opts = function(_, match, _)
          -- censors certain sensitive information
          local mask = string.rep('x', vim.fn.strchars(match))
          return {
            virt_text = { { mask, 'Comment' } },
            virt_text_pos = 'overlay',
            priority = 200,
            right_gravity = false,
          }
        end,
      },
    },
  }
end

-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
  -- [[ Fuzzy Finder (files, lsp, etc) ]]
  --
  -- Telescope is a fuzzy finder that comes with a lot of different things that
  -- it can fuzzy find! It's more than just a "file finder", it can search
  -- many different aspects of Neovim, your workspace, LSP, and more!
  --
  -- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
  -- so feel free to experiment and see what you like!
  --
  -- The easiest way to use Telescope, is to start by doing something like:
  --  :Telescope help_tags
  --
  -- After running this command, a window will open up and you're able to
  -- type in the prompt window. You'll see a list of `help_tags` options and
  -- a corresponding preview of the help.
  --
  -- Two important keymaps to use while in Telescope are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?
  --
  -- This opens a window that shows you all of the keymaps for the current
  -- Telescope picker. This is really useful to discover what Telescope can
  -- do as well as how to actually do it!

  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    -- It sets vim.ui.select to telescope. 
    -- That means for example that neovim core stuff can fill the telescope picker. 
    -- Example would be lua vim.lsp.buf.code_action().
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

  -- NOTE: You can install multiple plugins at once
  vim.pack.add(telescope_plugins)

  local function switch_to_grep(prompt_bufnr)
    local opts = {}
    local current_input = require('telescope.actions.state').get_current_line()
    local selected_entry = require('telescope.actions.state').get_selected_entry()
    local cwd = getmetatable(selected_entry).cwd
    require('telescope.actions').close(prompt_bufnr)
    -- live_multi_grep { default_text = current_input, cwd = cwd }
    -- require 'telescope._extensions.live-multi-grep' { default_text = current_input, cwd = cwd }
    require('telescope.builtin').live_grep { default_text = current_input, cwd = cwd }
  end

  local function cd_buffer_dir(prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    local dir = vim.fn.fnamemodify(selection.path, ':p:h')
    require('telescope.actions').close(prompt_bufnr)
    -- Depending on what you want put `cd`, `lcd`, `tcd`
    vim.cmd(string.format('silent lcd %s', dir))
  end

  require('telescope').setup {
    -- You can put your default mappings / updates / etc. in here
    --  All the info you're looking for is in `:help telescope.setup()`
    --
    defaults = {
      layout_strategy = 'vertical',
      path_display = {
        -- shorten = { len = 5, exclude = { -2, -1 } },
        -- filename_first = { reverse_directories = true },
        -- truncate = 1,
      },
      mappings = {
        i = {
          ['<M-?>'] = 'which_key', -- alacritty on Windows doesn't send <c-/>
          ['<M-/>'] = 'to_fuzzy_refine', -- alacritty on Windows doesn't send <c-enter>
          ['<c-enter>'] = 'to_fuzzy_refine',
          ['<c-space>'] = 'to_fuzzy_refine',
          ['<c-s>'] = switch_to_grep,
        },
        n = {
          -- <h,l> to cycle previewer for git commits to show full message
          ['gh'] = require('telescope.actions').cycle_previewers_prev,
          ['gl'] = require('telescope.actions').cycle_previewers_next,
          ['gc'] = cd_buffer_dir,
          ['gt'] = require('telescope.actions.layout').toggle_preview,
        },
      },
    },
    pickers = {
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        -- theme = 'dropdown',
        -- previewer = false,
        mappings = {
          -- i = { ['gd'] = require('telescope.actions').delete_buffer, },
          n = {
            ['D'] = require('telescope.actions').delete_buffer,
          },
        },
      },
      git_status = {
        mappings = {
          n = {
            ['c'] = { '<cmd>G commit<cr>', type = 'command' },
          },
        },
      },
      live_multi_grep = {
        attach_mappings = open_with_default_os_app,
      },
      live_grep = {
        attach_mappings = open_with_default_os_app,
      },
      find_files = {
        attach_mappings = open_with_default_os_app,
      },
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
      repo = {
        list = {
          fd_opts = { '--no-ignore-vcs' },
          search_dirs = { vim.fn.expand '~/src' },
        },
      },
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
      ['zf-native'] = {
        file = {
          initial_sort = function(line)
            -- prioritizes .lua files
            if line:match '%.lua$' then return 0 end
            return 1
          end,
        },
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      },
    },
  }

  --- Safely load telescope extension
  ---@param name string
  local function telescope_load_extension(name)
    if not pcall(require('telescope').load_extension, name) then vim.notify('telescope extension loading failed: ' .. name, vim.log.levels.WARN) end
  end

  -- Enable Telescope extensions if they are installed
  telescope_load_extension 'fzf'
  -- telescope_load_extension 'zf-native'
  -- telescope_load_extension 'fzy-native'
  telescope_load_extension 'live-multi-grep'
  telescope_load_extension 'ui-select'

  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  local function tele_find_all_files() builtin.find_files { no_ignore = true, no_ignore_parent = true, hidden = true } end
  local function find_files_buf_dir() builtin.find_files { cwd = vim.fn.expand '%:p:h' } end
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [d]iagnostics' })
  vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
  vim.keymap.set('n', '<leader>sM', builtin.man_pages, { desc = '[S]earch [M]an pages' })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sF', find_files_buf_dir, { desc = "[S]earch [F]iles in buf's dir" })
  vim.keymap.set('n', '<leader>sa', tele_find_all_files, { desc = '[S]earch [A]ll files' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', 'sg', builtin.git_status, { desc = '[s]witch git [s]tatus' })
  vim.keymap.set('n', '<leader>sg', ':Telescope live-multi-grep<cr>', { desc = '[S]earch by [G]rep' })
  -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sp', require('custom.repo-select').project_file_picker, { desc = '[S]earch [P]roject files' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[S]earch [T]reesitter' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', 'ls', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [e]moji' })
  vim.keymap.set(
    'n',
    '<leader>sl',
    function() require('telescope.builtin').find_files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data') } end,
    { desc = '[S]earch [l]ua packages' }
  )
  vim.keymap.set(
    'n',
    '<leader>su',
    function() require('telescope.builtin').find_files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data') } end,
    { desc = '[S]earch [l]ua packages' }
  )
  vim.keymap.set('n', '<leader>sz', builtin.spell_suggest, { desc = 'Spell suggest (Telescope)' })

  -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
  -- If you later switch picker plugins, this is where to update these mappings.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      -- Fuzzy find all the symbols in your current document.
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      -- Fuzzy find all the symbols in your current workspace.
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
      -- Jump to the type of the word under your cursor.
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

  -- Override default behavior and theme when searching
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set(
    'n',
    '<leader>s/',
    function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end,
    { desc = '[S]earch [/] in Open Files' }
  )

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
end

-- ============================================================
-- SECTION 5: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  -- [[ LSP Configuration ]]
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  -- Useful status updates for LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  local servers = require 'custom.lsp-servers'

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Automatically install LSPs and related tools to stdpath for Neovim
  require('mason').setup {}

  -- Ensure the servers and tools above are installed
  --
  -- To check the current status of installed tools and/or manually install
  -- other tools, you can run
  --    :Mason
  --
  -- You can press `g?` for help in this menu.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- You can add other tools here that you want Mason to install
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SECTION 6: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = false,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      xml = { 'xmlformatter' },
      sh = { 'shfmt' },
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      go = { 'goimports', 'gofmt' },
      -- You can also customize some of the format options for the filetype
      rust = { 'rustfmt', lsp_format = 'fallback' },
      toml = { 'taplo', lsp_format = 'fallback' },
      -- You can use a function here to determine the formatters dynamically
      python = function(bufnr)
        vim.api.nvim_get_current_buf()

        ---@param formatter string The name of the formatter
        ---@param buf? integer
        local finfo = function(formatter, buf) return require('conform').get_formatter_info(formatter, buf).available and formatter or nil end
        local formatters = {
          finfo('ruff_format', bufnr),
          finfo('ruff_fix', bufnr),
          finfo('ruff_organize_imports', bufnr),
          finfo('black', bufnr),
        }
        local available = vim.tbl_filter(function(x) return x ~= nil end, formatters)
        return available
      end,
      typescript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'fallback' },
      json = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'fallback' },
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'fallback' },
      --
      -- Use the "*" filetype to run formatters on all filetypes.
      -- ['*'] = { 'typos' },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace' },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 7: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
  -- [[ Snippet Engine ]]

  -- NOTE: You can also specify plugin using a version range for its git tag.
  --  See `:help vim.version.range()` for more info
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  local ls = require 'luasnip'
  -- -- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
  ls.filetype_set('cpp', { 'c' })
  --
  -- vim.keymap.set({ 'i' }, '<c-s>', function() ls.expand {} end, { silent = true })
  -- vim.keymap.set({ 'i', 's' }, '<c-s>;', function() ls.jump(1) end, { silent = true })
  -- vim.keymap.set({ 'i', 's' }, '<c-s>,', function() ls.jump(-1) end, { silent = true })
  --
  -- vim.keymap.set({ 'i', 's' }, '<c-e>', function()
  --   if ls.choice_active() then ls.change_choice(1) end
  -- end, { silent = true })

  -- see `nvim/lazy/LuaSnip/Examples/snippets.lua`

  for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/custom/snippets/*.lua', true)) do
    loadfile(ft_path)()
  end
  require('luasnip.loaders.from_lua').lazy_load { include = { 'all', 'cpp', 'c' } }

  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'default',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 8: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
  -- [[ Configure Treesitter ]]
  --  Used to highlight, edit, and navigate code
  --
  --  See `:help nvim-treesitter-intro`

  -- NOTE: You can also specify a branch or a specific commit
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Ensure basic parsers are installed
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SECTION 9: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'
  -- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  require 'custom.plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
