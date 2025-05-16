local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("go", {
  s("ife", {
    t "if ",
    i(1, "err"),
    t " != nil {",
    t { "", "\t" },
    t 'fmt.Errorf("%w", ',
    i(2, "err"),
    t ")",
    t { "", "\treturn" },
    t { "", "}" },
  }),
})
