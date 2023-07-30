local opts = { noremap = true, silent = true }
return {
  "mrjones2014/smart-splits.nvim",
  keys = {

    { "<A-h>", ":lua require('smart-splits').resize_left<CR>", desc = "resize left", opts },
    { "<A-j>", ":lua require('smart-splits').resize_down<CR>", desc = "resize down", opts },
    { "<A-k>", ":lua require('smart-splits').resize_up<CR>", desc = "resize up", opts },
    { "<A-l>", ":lua require('smart-splits').resize_right<CR>", desc = "resize left", opts },
    -- move between panes/splits
    { "<C-h>", ":lua require('smart-splits').move_cursor_left<CR>", desc = "move cursor left", opts },
    { "<C-j>", ":lua require('smart-splits').move_cursor_down<CR>", desc = "move cursor down", opts },
    { "<C-k>", ":lua require('smart-splits').move_cursor_up<CR>", desc = "move cursor up", opts },
    { "<C-l>", ":lua require('smart-splits').move_cursor_right<CR>", desc = "move cursor left", opts },
  },
}

