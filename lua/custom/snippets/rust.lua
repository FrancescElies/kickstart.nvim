local ls = require 'luasnip'
local f = ls.function_node
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local snippet_from_nodes = ls.sn

local function inside_impl()
   local node = vim.treesitter.get_node()
   while node do
     if node:type() == "impl_item" then return true end
     node = node:parent()
   end
   return false
 end
