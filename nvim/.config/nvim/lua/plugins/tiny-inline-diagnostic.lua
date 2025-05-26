return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000,    -- needs to be loaded in first
  config = function()
    local tiny_inline = require "tiny-inline-diagnostic"
    tiny_inline.setup {
      preset = "ghost",
      -- transparent_bg = true,
      options = {
        show_source = {
          enabled = false,
          if_many = false,
        },
        throttle = 20,
        use_icons_from_diagnostics = true,
        softwrap = 30,
        enable_on_insert = false,
        multilines = {
          enabled = true,
          alway_show = true,
        },
        break_line = {
          enabled = true,
        },
      },
    }
    vim.diagnostic.config { virtual_text = false }
  end,
}
