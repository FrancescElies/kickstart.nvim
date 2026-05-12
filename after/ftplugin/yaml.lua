-- Enable syntax highlighting
vim.cmd("syntax on")
-- Enable spellcheck
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us" }
vim.opt_local.spelloptions:append "camel"
vim.opt_local.spellcapcheck = "" -- disable checking for capital letters at the start of sentences
