-- etiquette
vim.o.textwidth = 72
vim.o.wrap = true

-- wrap while typing, respect comments (">" quoting), auto-format paragraphs
vim.o.formatoptions = vim.o.formatoptions
  + 't' -- auto-wrap text
  + 'c' -- auto-wrap comments (quoted emails)
  + 'r' -- insert comment leader on enter
  + 'o' -- continue comments when using 'o' or 'o'
  - 'l' -- do not break long lines automatically when editing existing text

-- recognize email quoting
vim.o.comments = 'b:>'

-- Spell check enabled
vim.o.spell = true
vim.o.spelllang = 'en'

-- highlight trailing whitespace
vim.o.list = true
vim.o.listchars = 'trail:·'
