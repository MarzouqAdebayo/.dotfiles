local wk = require "which-key"
local lspsaga = require "lspsaga"

lspsaga.setup {
  -- keymaps for lspsaga
  wk.add {
    { "K",  "<CMD>Lspsaga hover_doc<CR>",             desc = "Hover documentation",   mode = "n" },
    { "KK", "<CMD>Lspsaga hover_doc ++keep<CR>",      desc = "Hover doc keep",        mode = "n" },
    { "gp", "<CMD>Lspsaga peek_definition<CR>",       desc = "Peek definition",       mode = "n" },
    { "gk", "<CMD>Lspsaga peek_type_definition<CR>",  desc = "Peek type definition",  mode = "n" },
    { "gf", "<CMD>Lspsaga finder<CR>",                desc = "LSPSaga finder",        mode = "n" },
    { "ga", "<CMD>Lspsaga code_action<CR>",           desc = "LSPSaga code action",   mode = "n" },
    -- { "gn", "<CMD>Lspsaga rename<CR>", desc = "", mode = "n" },
    { "E",  "<CMD>Lspsaga show_line_diagnostics<CR>", desc = "Show line diagnostics", mode = "n" },
    { "go", "<CMD>Lspsaga outline<CR>",               desc = "LSPSaga outline",       mode = "n" },
    { "g.", "<CMD>Lspsaga diagnostic_jump_next<CR>",  desc = "Diagnostics jump next", mode = "n" },
    { "g,", "<CMD>Lspsaga diagnostic_jump_prev<CR>",  desc = "Diagnostics jump prev", mode = "n" },
  },

  ui             = {
    border = "rounded",
    lines = { "└", "├", "│", "─", "┌" },
    imp_sign = " ",
    code_action = " ",
  },

  diagnostic     = {
    border_follow = true
  },

  lightbulb      = {
    virtual_text = false,
  },

  scroll_preview = {
    scroll_down = "<C-n>",
    scroll_up = "<C-p>",
  },

  finder         = {
    max_height = 0.8,
    left_width = 0.3,
    right_width = 0.6,
    default = "imp+tyd+def+ref",
    keys = {
      split = "s",
      toggle_or_open = "o",
      vsplit = "v",
    },
  },

  definition     = {
    width = 0.8,
    height = 0.7,
    keys = {
      close = "q",
      edit = "o",
      split = "s",
      vsplit = "v",
    },
  },

  implement      = {
    enable = true,
  },

  outline        = {
    layout = "normal"
  },
}
