return {
  {
    "Saghen/blink.cmp",
    lazy = false,                     -- blink.cmp needs to load early
    dependencies = {
      "rafamadriz/friendly-snippets", -- For snippets
      "onsails/lspkind.nvim",         -- For icons
    },
    version = "1.*",
    build = "cargo build --release",
    config = function()
      local cmp = require "blink.cmp"
      cmp.setup {
        keymap     = {
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-Space>"] = { "show", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<C-u>"] = { "scroll_documentation_up", "fallback" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
          menu = {
            draw = {
              components = {
                kind_icon = {
                  text = function(ctx) return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' ' end
                }
              },
              columns = {
                { "label",     "label_description", gap = 1 },
                { "kind_icon", "kind" }
              }
            }
          },
          ghost_text = { enabled = true },
        },
        sources    = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        snippets   = {
          preset = "default",
        },
        signature  = { enabled = true },
      }

      local colors = require "oldtale.palette"
      -- Custom highlight groups for better appearance
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.none, fg = colors.fg })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.blend_orange })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = colors.blend_orange, fg = colors.orange })
      vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = colors.blend_orange })
      vim.api.nvim_set_hl(0, "BlinkCmpScrollBarGutter", { bg = colors.none })
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.none, fg = colors.fg })
      vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { bg = colors.none, fg = colors.blend_orange })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.blend_orange })
    end,
  },
}
