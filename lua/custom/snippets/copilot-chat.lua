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

ls.add_snippets('copilot-chat', {
  s('main', {
    t {
      'Act like a senior engineer when reviewing. Be strict and practical.',
      'If you are unsure, say so explicitly instead of guessing.',
      'Do not assume missing information. Only use what is given.',
      'Be extremely concise. No filler. Only the important parts.',
      'Go deep on the critical parts, skip basics.',
      'Use bullet points and highlight key insights.',
      'Give me actionable steps, not just explanation.',

      'If the request is ambiguous, ask clarifying questions before answering.',
      'State any assumptions you make in a short list.',
      'Provide a brief TL;DR summary (1–2 lines) at the top.',
      'Show runnable examples and minimal reproducible code where applicable.',
      'Return code only in fenced blocks and mark language (no extra prose).',
      'When changing files, show a diff or patch and exact commands to apply it.',
      'Include tests or usage examples and how to run them locally.',
      'List alternatives with concise pros and cons for each.',
      'Highlight breaking changes or backward-compatibility concerns.',
      'Point out security, performance, and edge-case risks.',
      'Prefer best practices and idiomatic patterns for the language and tooling.',
      'When relevant, provide OS-specific commands (Windows, macOSor Linux).',
      'If asked to modify code, provide only the minimal focused edits.',

      'Cite sources or include links when referencing external facts.',
      'Above all be concise',
    },
  }),
})
