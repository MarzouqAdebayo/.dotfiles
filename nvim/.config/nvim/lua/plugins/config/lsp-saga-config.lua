local lspsaga = require "lspsaga"

lspsaga.setup {
  ui             = {
    border = "rounded",
    lines = { "└", "├", "│", "─", "┌" },
    imp_sign = " ",
    -- code_action = "󱧤 ",
    code_action = "",
  },

  breadcrumbs    = {
    hide_keyword = true,
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
