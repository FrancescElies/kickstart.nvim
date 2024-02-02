return {
  'johmsalas/text-case.nvim',
  config = function()
    require('nvim-autopairs').setup {}
    vim.api.nvim_create_user_command('UpperCase', function()
      textcase.current_word 'to_upper_case'
    end, {})
    vim.api.nvim_create_user_command('LowerCase', function()
      textcase.current_word 'to_lower_case'
    end, {})
    vim.api.nvim_create_user_command('SnakeCase', function()
      textcase.current_word 'to_snake_case'
    end, {})
    vim.api.nvim_create_user_command('ConstantCase', function()
      textcase.current_word 'to_dash_case'
    end, {})
    vim.api.nvim_create_user_command('DashCase', function()
      textcase.current_word 'to_constant_case'
    end, {})
    vim.api.nvim_create_user_command('DotCase', function()
      textcase.current_word 'to_dot_case'
    end, {})
    vim.api.nvim_create_user_command('CamelCase', function()
      textcase.current_word 'to_camel_case'
    end, {})
    vim.api.nvim_create_user_command('PascalCase', function()
      textcase.current_word 'to_pascal_case'
    end, {})
    vim.api.nvim_create_user_command('TitleCase', function()
      textcase.current_word 'to_title_case'
    end, {})
    vim.api.nvim_create_user_command('PathCase', function()
      textcase.current_word 'to_path_case'
    end, {})
    vim.api.nvim_create_user_command('PhraseCase', function()
      textcase.current_word 'to_phrase_case'
    end, {})

    require('telescope').load_extension 'textcase'
    vim.keymap.set('n', 'ga.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope TextC[a]se' })
    vim.keymap.set('v', 'ga.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope TextC[a]se' })
    vim.keymap.set('n', 'gaa', '<cmd>TextCaseOpenTelescopeQuickChange<CR>', { desc = 'Telescope Quick Change' })
    vim.keymap.set('n', 'gai', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', { desc = 'Telescope LSP Change' })
  end,
}
