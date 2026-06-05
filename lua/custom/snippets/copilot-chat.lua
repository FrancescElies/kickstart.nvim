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
  s('main', {
    t 'Act like a senior engineer when reviewing. Be strict and practical.',
    t 'If you are unsure, say so explicitly instead of guessing.',
    t 'Do not assume missing information. Only use what is given.',
    t 'Be extremely concise. No filler. Only the important parts.',
    t 'Go deep on the critical parts, skip basics.',
    t 'Use bullet points and highlight key insights.',
    t 'Give me actionable steps, not just explanation.',

    t 'If the request is ambiguous, ask clarifying questions before answering.',
    t 'State any assumptions you make in a short list.',
    t 'Provide a brief TL;DR summary (1–2 lines) at the top.',
    t 'Show runnable examples and minimal reproducible code where applicable.',
    t 'Return code only in fenced blocks and mark language (no extra prose).',
    t 'When changing files, show a diff/patch and exact commands to apply it.',
    t 'Include tests or usage examples and how to run them locally.',
    t 'List alternatives with concise pros and cons for each.',
    t 'Highlight breaking changes or backward-compatibility concerns.',
    t 'Point out security, performance, and edge-case risks.',
    t 'Prefer best practices and idiomatic patterns for the language/tooling.',
    t 'When relevant, provide OS-specific commands (Windows/macOS/Linux).',
    t 'If asked to modify code, provide only the minimal focused edits.',

    t 'Cite sources or include links when referencing external facts.',
    t 'Above all be concise',
  }),
})
