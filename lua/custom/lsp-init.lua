local M = {}

M.jsonls_capabilities = vim.lsp.protocol.make_client_capabilities()
M.jsonls_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- https://github.com/neovim/nvim-lspconfig/issues/2184
-- local offsetEncoding = { 'utf-16' }
-- local offsetEncoding = { 'utf-8', 'utf-16' }
local offsetEncoding = 'utf-16'
M.clangd_capabilities = vim.lsp.protocol.make_client_capabilities()
M.clangd_capabilities.offsetEncoding = offsetEncoding

M.servers = {

  -- clangd = {},
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
  powershell_es = {
    settings = {
      powershell = {
        -- https://github.com/PowerShell/PowerShellEditorServices/blob/main/docs/guide/getting_started.md
        -- https://github.com/PowerShell/PowerShellEditorServices/blob/main/src/PowerShellEditorServices/Services/Workspace/LanguageServerSettings.cs
        codeFormatting = { Preset = 'OTBS' },
      },
    },
  },
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
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  clangd = { filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }, capabilities = M.clangd_capabilities },
  biome = { filetypes = { 'typescript', 'json' }, init_options = { provideFormatter = true } },
  -- sqls = {},
  -- gopls = {},
  basedpyright = {}, -- pyright fork with inlay hints
  -- pyright = {},
  -- jsonls = {
  --   filetypes = { 'maxpat', 'json' },
  --   init_options = { provideFormatter = false },
  --   capabilities = M.jsonls_capabilities,
  -- },
  ruff_lsp = {},
  -- slint_lsp = { filetypes = { 'slint' }, capabilities = slint_capabilities },
  -- rust_analyzer = {
  --   ['rust-analyzer'] = {
  --     diagnostics = { enable = true },
  --     check = { command = 'check' }, -- can be clippy too
  --     cargo = { features = 'all' },
  --     checkOnSave = {
  --       assist = {
  --         importGranularity = 'module',
  --         importPrefix = 'by_self',
  --       },
  --       cargo = { loadOutDirsFromCheck = true },
  --       procMacro = { enable = true },
  --       command = 'clippy',
  --       inlayHints = true,
  --     },
  --     inlayHints = {
  --       enabled = true,
  --       chainingHints = { enable = false }, -- do not enable
  --       closingBraceHints = { enable = false },
  --       bindingModeHints = { enable = true },
  --       closureCaptureHints = { enable = true },
  --       closureReturnTypeHints = { enable = 'always' },
  --       expressionAdjustmentHints = { enable = 'always' },
  --       lifetimeElisionHints = { enable = 'always', useParameterNames = true },
  --       reborrowHints = { enable = 'always' },
  --       typeHints = { hideClosureInitialization = true, hideNamedConstructor = true },
  --       locationLinks = false,
  --     },
  --     completion = {
  --       completionItem = {
  --         commitCharactersSupport = true,
  --         deprecatedSupport = true,
  --         documentationFormat = { 'markdown', 'plaintext' },
  --         preselectSupport = true,
  --         snippetSupport = true,
  --       },
  --     },
  --     signatureHelp = {
  --       dynamicRegistration = true,
  --       signatureInformation = {
  --         activeParameterSupport = true,
  --         documentationFormat = { 'markdown', 'plaintext' },
  --         parameterInformation = {
  --           labelOffsetSupport = true,
  --         },
  --       },
  --     },
  --     procMacro = {
  --       enable = true,
  --       methodReference = true,
  --     },
  --     lens = {
  --       enable = true,
  --       methodReferences = true,
  --       references = true,
  --       implementations = false,
  --     },
  --   },
  -- },
  tsserver = {
    init_options = {
      provideFormatter = false,
    },
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayVariableTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayVariableTypeHints = true,

        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  omnisharp = {
    -- cmd = { 'dotnet', '~/bin/omnisharp/Microsoft.CodeAnalysis.ExternalAccess.OmniSharp.dll' },
    enable_editorconfig_support = true,
    enable_ms_build_load_projects_on_demand = false,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = false,
    sdk_include_prereleases = true,
    analyze_open_documents_only = false,
  },
}

return M
