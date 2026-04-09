--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
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
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true,   -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  -- NOTE: Plugins can be added via a link or github org/name. To run setup automatically, use `opts = {}`
  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>C',  group = '[C]hat' },
        { '<leader>b',  group = '[B]uffer' },
        { '<leader>c',  group = '[c]ode' },
        { '<leader>g',  group = 'git',                  mode = { 'n', 'v' } },
        { '<leader>g/', group = '[g]it [/]search',      mode = { 'n', 'v' } },
        { '<leader>d',  group = 'git [D]iff',           mode = { 'n', 'v' } },
        { '<leader>dh', group = 'git [D]iff [H]istory', mode = { 'n', 'v' } },
        { '<leader>h',  group = 'git [H]unk',           mode = { 'n', 'v' } },
        { '<leader>l',  group = '[l]oclist' },
        { '<leader>n',  group = '[n]otes' },
        { '<leader>s',  group = '[s]earch' },
        { '<leader>t',  group = '[t]est' },
        { '<leader>q',  group = '[q]uickfix' },
        { '<leader>v',  group = '[v]im' },
        { 's',          group = '[s]urround' },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    -- By default, Telescope is included and acts as your picker for everything.

    -- If you would like to switch to a different picker (like snacks, or fzf-lua)
    -- you can disable the Telescope plugin by setting enabled to false and enable
    -- your replacement picker by requiring it explicitly (e.g. 'custom.plugins.snacks')

    -- Note: If you customize your config for yourself,
    -- it’s best to remove the Telescope plugin config entirely
    -- instead of just disabling it here, to keep your config clean.
    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- { 'FrancescElies/telescope-zf-native.nvim', build = 'just build' },
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = string.lower(vim.loop.os_uname().sysname) == 'windows_nt'
            and 'zig cc -shared -O3  -march=native -mtune=native -funroll-loops -fomit-frame-pointer -finline-functions -o build/libfzf.dll src/fzf.c'
            or 'zig cc -shared -O3  -march=native -mtune=native -funroll-loops -fomit-frame-pointer -finline-functions -o build/libfzf.so src/fzf.c',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
    config = function()
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

      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
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

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          layout_strategy = 'vertical',
          path_display = {
            -- shorten = { len = 5, exclude = { -2, -1 } },
            filename_first = { reverse_directories = true },
            -- truncate = 1,
          },
          mappings = {
            i = {
              ['<M-?>'] = 'which_key',       -- alacritty on Windows doesn't send <c-/>
              ['<M-/>'] = 'to_fuzzy_refine', -- alacritty on Windows doesn't send <c-enter>
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<c-space>'] = 'to_fuzzy_refine',
              ['<c-g>'] = switch_to_grep,
              ['<c-s-g>'] = switch_to_grep,
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
        if not pcall(require('telescope').load_extension, name) then
          vim.notify(
            name .. 'telescope extension loading failed', vim.log.levels.WARN)
        end
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
      vim.keymap.set('n', '<leader>sG', builtin.git_status, { desc = '[s]witch git [s]tatus' })
      vim.keymap.set('n', '<leader>sg', ':Telescope live-multi-grep<cr>', { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sp', require('custom.repo-select').project_file_picker,
        { desc = '[S]earch [P]roject files' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[S]earch [T]reesitter' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', 'ls', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [e]moji' })
      vim.keymap.set(
        'n',
        '<leader>sl',
        function() require('telescope.builtin').find_files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data') } end,
        { desc = '[S]earch [l]ua packages' }
      )

      vim.keymap.set('n', '<leader>sz', builtin.spell_suggest, { desc = 'Spell suggest (Telescope)' })

      -- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
      -- it is better explained there). This allows easily switching between pickers if you prefer using something else!
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

          -- Jump to the implementation of the word under your cursor.
          -- Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

          -- Fuzzy find all the symbols in your current document.
          -- Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          -- Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols,
            { buffer = buf, desc = 'Open Workspace Symbols' })

          -- Jump to the type of the word under your cursor.
          -- Useful when you're not sure what type a variable is and you want to see
          -- the definition of its *type*, not where it was *defined*.
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
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end,
        { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      -- Maps LSP server names between nvim-lspconfig and Mason package names.
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- 'saghen/blink.cmp', -- allows extra capabilities

      'b0o/schemastore.nvim',
    },
    config = function()
      local schemastore = require 'schemastore'
      vim.lsp.config.jsonls = {
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      }
      vim.lsp.config.yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemas = schemastore.yaml.schemas(),
          },
        },
      }

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
            map('<leader>th',
              function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end,
              '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --  See `:help lsp-config` for information about keys and how to configure
      ---@type table<string, vim.lsp.Config>
      local servers = require 'custom.lsp-servers'

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
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
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
          local finfo = function(formatter, buf)
            return require('conform').get_formatter_info(formatter, buf).available and
                formatter or nil
          end
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
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
          },
        },
        opts = {},
        config = function()
          local ls = require 'luasnip'
          -- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
          ls.filetype_set('cpp', { 'c' })

          vim.keymap.set({ 'i' }, '<c-s>', function() ls.expand {} end, { silent = true })
          vim.keymap.set({ 'i', 's' }, '<c-s>;', function() ls.jump(1) end, { silent = true })
          vim.keymap.set({ 'i', 's' }, '<c-s>,', function() ls.jump(-1) end, { silent = true })

          vim.keymap.set({ 'i', 's' }, '<c-e>', function()
            if ls.choice_active() then ls.change_choice(1) end
          end, { silent = true })

          -- see `nvim/lazy/LuaSnip/Examples/snippets.lua`

          for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/custom/snippets/*.lua', true)) do
            loadfile(ft_path)()
          end
          require('luasnip.loaders.from_lua').lazy_load { include = { 'all', 'cpp', 'c' } }
        end,
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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
        -- See :h blink-cmp-config-keymap for defining your own keymap
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
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        -- on_colors = function(color) color.comment = '#82a2c4' end,
        -- on_highlights = function(hl, color)
        --   hl.LineNr = { fg = color.green }
        --   hl.LineNrAbove = { fg = color.comment }
        --   hl.LineNrBelow = { fg = color.comment }
        --   hl.StatusLineNC = { fg = color.comment }
        --   hl.StatusLine = { fg = color.yellow }
        --   hl.DiagnosticUnnecessary = { fg = color.comment }
        -- end,
      }

      vim.o.background = 'dark' -- workaround for zellij, otherwise tokyonight selects light background
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = false,
      keywords = {
        ONHOLD = { icon = '🪝', color = '#ddbe0b', alt = { 'HALTED' } },
        WONT = { icon = '🛑', color = '#ab3e8f', alt = { 'HALTED' } },
        DONE = { icon = '', color = '#00a087', alt = { 'HALTED' } },
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sdb   - [S]urround [D]elete [B]alanced, either ], ) or }
      -- - sdq   - [S]urround [D]elete [q]uotes, either ' or "
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
      -- using persistence instead
      require('mini.sessions').setup {
        autoread = true,
        autowrite = true,
        verbose = { read = true, write = true, delete = true },
      }
      vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
      vim.keymap.set('n', '<leader>pw', ':lua MiniSessions.write()<cr>', { desc = 'persist session' })
      vim.keymap.set('n', '<leader>pd', ':lua MiniSessions.delete()<cr>', { desc = 'persist session delete' })
      vim.keymap.set('n', '<leader>ps', ':lua MiniSessions.select()<cr>', { desc = 'persist session select' })

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
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      -- ensure basic parser are installed
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'python',
        'rust', 'nu', 'vim', 'vimdoc', 'yaml' }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
  --
  --   -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  --   -- init.lua. If you want these files, they are in the repository, so you can just download them and
  --   -- place them in the correct locations.
  --
  --   -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --   --
  --   --  Here are some example plugins that I've included in the Kickstart repository.
  --   --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --   --
  --   -- require 'kickstart.plugins.debug',
  --   -- require 'kickstart.plugins.indent_line',
  --   -- require 'kickstart.plugins.lint',
  --   -- require 'kickstart.plugins.autopairs',
  --   -- require 'kickstart.plugins.neo-tree',
  --   -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommended keymaps
  --
  --   -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --   --    This is the easiest way to modularize your config.
  --   --
  --   --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'custom.plugins' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
