return {
        -- harper_ls = { -- typos
        --   settings = {
        --     ['harper-ls'] = {
        --       userDictPath = vim.fn.expand '~/src/kickstart.nvim/dict.txt',
        --       linters = {
        --         SentenceCapitalization = false,
        --         SpellCheck = false,
        --       },
        --     },
        --   },
        -- },
        clangd = {
          cmd = {
            'clangd',
            '--background-index', -- persist index on disk
            '--clang-tidy', -- enables tidy
            '--fallback-style="{BasedOnStyle: LLVM, IndentWidth: 4}"',
            '--log=verbose',
            '--enable-config',
            --- NOTE: see .clang-tidy in repo for example
          },
        },
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --
        -- powershell_es = {
        --   settings = {
        --     powershell = {
        --       -- https://github.com/PowerShell/PowerShellEditorServices/blob/main/docs/guide/getting_started.md
        --       -- https://github.com/PowerShell/PowerShellEditorServices/blob/main/src/PowerShellEditorServices/Services/Workspace/LanguageServerSettings.cs
        --       codeFormatting = { Preset = 'OTBS' },
        --     },
        --   },
        -- },
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        -- biome = { filetypes = { 'typescript', 'json', 'maxpat', 'json' }, init_options = { provideFormatter = true } },
        -- sqls = {},
        -- gopls = {},
        basedpyright = {}, -- pyright fork with inlay hints
        -- pyright = {},
        yamlls = {},
        jsonls = {
          filetypes = { 'maxpat', 'json' },
          init_options = { provideFormatter = true },
        },
        --   capabilities = M.jsonls_capabilities,
        -- },
        ruff = {},

        -- ts_ls = {
        --   init_options = {
        --     provideFormatter = false,
        --   },
        --   typescript = {
        --     inlayHints = {
        --       includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
        --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --       includeInlayVariableTypeHints = true,
        --       includeInlayFunctionParameterTypeHints = true,
        --       includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        --       includeInlayPropertyDeclarationTypeHints = true,
        --       includeInlayFunctionLikeReturnTypeHints = true,
        --       includeInlayEnumMemberValueHints = true,
        --     },
        --   },
        --   javascript = {
        --     inlayHints = {
        --       includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
        --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --       includeInlayVariableTypeHints = true,
        --
        --       includeInlayFunctionParameterTypeHints = true,
        --       includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        --       includeInlayPropertyDeclarationTypeHints = true,
        --       includeInlayFunctionLikeReturnTypeHints = true,
        --       includeInlayEnumMemberValueHints = true,
        --     },
        --   },
        -- },

        -- html = { filetypes = { 'html', 'twig', 'hbs' } },

        -- omnisharp = {
        --   -- cmd = { 'dotnet', '~/bin/omnisharp/Microsoft.CodeAnalysis.ExternalAccess.OmniSharp.dll' },
        --   enable_editorconfig_support = true,
        --   enable_ms_build_load_projects_on_demand = false,
        --   enable_roslyn_analyzers = true,
        --   organize_imports_on_format = true,
        --   enable_import_completion = false,
        --   sdk_include_prereleases = true,
        --   analyze_open_documents_only = false,
        -- },

        -- zls = {
        --   -- https://zigtools.org/zls/editors/vim/nvim-lspconfig/
        --   -- Whether to enable build-on-save diagnostics
        --   --
        --   -- Further information about build-on save:
        --   -- https://zigtools.org/zls/guides/build-on-save/
        --   enable_build_on_save = true,
        --
        --   -- Neovim already provides basic syntax highlighting
        --   semantic_tokens = 'partial',
        --
        --   -- omit the following line if `zig` is in your PATH
        --   zig_exe_path = vim.fn.exepath 'zig',
        --   enable_snippets = true,
        --   enable_autofix = true,
        --   enable_ast_check_diagnostics = true,
        -- },
      }
