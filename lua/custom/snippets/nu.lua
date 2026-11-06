local ls = require 'luasnip'

ls.add_snippets('nu', {
  ls.snippet('def-step', {
    ls.text_node {
      'def step [name: string, body: closure] {',
      '    print $"(ansi green_bold)==> ($name)(ansi reset)"',
      '    try { do -c $body } catch { |e|',
      '        print $"(ansi red_bold)FAILED: ($name)(ansi reset)"',
      '        error make --unspanned { msg: $"step failed: ($name): ($e.msg)" }',
      '    }',
      '}',
    },
    ls.insert_node(0),
  }),
})

