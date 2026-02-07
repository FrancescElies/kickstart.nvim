-- gqip   Reflow current paragraph to textwidth.
-- gqG    Reflow entire message.
-- gwip   Reflow without moving cursor (useful variant).

-- etiquette
vim.o.textwidth = 72
vim.o.wrap = true

-- wrap while typing, respect comments (">" quoting), auto-format paragraphs
vim.opt_local.formatoptions:append('t') -- auto-wrap text
vim.opt_local.formatoptions:append('c') -- auto-wrap comments (quoted emails)
vim.opt_local.formatoptions:append('r') -- insert comment leader on enter
vim.opt_local.formatoptions:append('o') -- continue comments when using 'o' or 'o'
vim.opt_local.formatoptions:append('l') -- do not break long lines automatically when editing existing text

-- recognize email quoting
vim.o.comments = 'b:>'

-- Spell check enabled
vim.o.spell = true
vim.o.spelllang = 'en'

-- highlight trailing whitespace
vim.o.list = true
vim.o.listchars = 'trail:·'

