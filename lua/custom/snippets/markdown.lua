---@diagnostic disable: undefined-global, unused-local
local ls = require 'luasnip'

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require 'luasnip.extras.conditions'
local conds_expand = require 'luasnip.extras.conditions.expand'
local types = require 'luasnip.util.types'

ls.add_snippets('markdown', {
  s('details', fmt('<details>\n<summary>{} (Click me)👈</summary>\n\n{}\n\n</details>', { i(1, 'Summary'), i(2, '*markdown content*') })),

  s(
    'img-width',
    fmt('<img src="{}" alt="{}" width={}>', {
      i(1, './image.png'),
      i(2, 'alt text'),
      i(3, '300'),
    })
  ),

  s(
    'video',
    fmt('<video src="{}" width={} controls></video> ', {
      i(1, 'https://website.com/video.mp4'),
      i(2, '300'),
    })
  ),

  s(
    'code',
    fmt('```{}\n{}\n```', {
      i(1, 'lang'),
      i(2, 'code'),
    })
  ),
})
