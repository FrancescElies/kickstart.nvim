local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt


ls.add_snippets('zig', {
  -- File header / module template
  s("module", fmt([[
    const std = @import("std");

    pub const {} = struct {{
      {}
    }};
  ]], { i(1, "Name"), i(2, "// fields or functions") })),

  -- pub fn with optional return type and doc comment
  s("fn", fmt([[
    /// {}
    pub fn {}({}){} {{
      {}
    }}
  ]], {
    i(1, "Brief description"),
    i(2, "name"),
    i(3, "self: *MyType"),
    c(4, { t(""), t(": void"), t(": error!void"), t(": usize") }),
    i(0, "// body")
  })),

  -- simple function (non-pub)
  s("fnl", fmt([[
    fn {}({}){} {{
      {}
    }}
  ]], { i(1, "name"), i(2, ""), c(3, { t(""), t(": usize"), t(": void") }), i(0, "// body") })),

  -- comptime for loops / generics
  s("comptime", fmt([[
    comptime {{
      for ({}) |{}| {{
        {}
      }}
    }}
  ]], { i(1, "array"), i(2, "idx, val"), i(0, "// body") })),

  -- error union handling with try/if (useful pattern)
  s("try", fmt([[
    const {} = try {};
  ]], { i(1, "res"), i(2, "expr()") })),

  -- if (err) return pattern
  s("catch", fmt([[
    const {} = {};
    if ({}) |err| {{
      return err;
    }}
  ]], { i(1, "res"), i(2, "expr()"), i(3, "res") })),

  -- defer pattern
  s("defer", fmt([[
    defer {};
  ]], { i(1, "// cleanup") })),

  -- struct with init
  s("struct", fmt([[
    pub const {} = struct {{
      {}
      pub fn init({}) {} {{
        return {} {{
          {}
        }};
      }}
    }};
  ]], { i(1, "Name"), i(2, "// fields"), i(3, "args"), c(4, { t(""), t(": void") }), i(5, "Name"), i(0, "// init fields") })),

  -- enum (union) with sentinel
  s("enum", fmt([[
    pub const {} = enum(u8) {{
      {}
    }};
  ]], { i(1, "Name"), i(2, "A = 0, B = 1") })),

  -- error set
  s("errset", fmt([[
    pub const {} = error{{
      {}
    }};
  ]], { i(1, "MyError"), i(2, "SomeError, OtherError") })),

  -- test template
  s("test", fmt([[
    test "{}" {{
      {}
    }}
  ]], { i(1, "description"), i(0, "// assertions") })),

  -- std.testing example with expectEqual
  s("tst", fmt([[
    const std = @import("std");

    test "{}" {{
      const expect = std.testing.expectEqual;
      {}
    }}
  ]], { i(1, "description"), i(0, "// checks") })),

  -- main entry
  s("main", fmt([[
    pub fn main() void {{
      {}
    }}
  ]], { i(0, "// body") })),

  -- slice iteration
  s("for", fmt([[
    for ({}.*) |{}, i| {{
      {}
    }}
  ]], { i(1, "slice"), i(2, "elem"), i(0, "// body") })),

  -- fmt print
  s("print", fmt([[
    std.debug.print("{}", .{{ {}}});
  ]], { i(1, "fmt"), i(2, "vars") })),

  -- build.zig snippet
  s("build", fmt([[
    const Builder = @import("std").build.Builder;

    pub fn build(b: *Builder) void {{
      const mode = b.standardReleaseOptions();
      const exe = b.addExecutable(.{{ name = "{}", root_source_file = "src/main.zig" }});
      exe.setBuildMode(mode);
      exe.install();
    }}
  ]], { i(1, "myapp") })),
})


