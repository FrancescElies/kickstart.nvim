vim.keymap.set('n', '<leader>vm', require("telescope.builtin").marks, { desc = '[v]im [m]arks' })
-- shadows register `l`, that's ok
vim.keymap.set('n', 'ml', require("telescope.builtin").marks, { desc = '[m]arks list' })

return {
    'chentoast/marks.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'renerocksai/calendar-vim' },
    config = true
}
