return {
  {
    "Saghen/blink.cmp",
    lazy = false,                     -- blink.cmp needs to load early
    dependencies = {
      "rafamadriz/friendly-snippets", -- For snippets
      "onsails/lspkind.nvim",         -- For icons
      'Kaiser-Yang/blink-cmp-avante',
    },
    version = "1.*",
    build = "cargo +nightly build --release",
    config = function()
      local cmp = require "blink.cmp"
      cmp.setup {
        keymap     = {
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev" },
          ["<C-Space>"] = { "show", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<C-u>"] = { "scroll_documentation_up", "fallback" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        },
        appearance = {
          nerd_font_variant = "mono",
          kind_icons = require('icons').symbol_kinds,
        },
        completion = {
          list = {
            selection = { preselect = false, auto_insert = true },
            max_items = 12
          },
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
          -- Disable some sources in comments and strings.
          default = function()
            local sources = { 'lsp', 'buffer', 'avante' }
            local ok, node = pcall(vim.treesitter.get_node)

            if ok and node then
              if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                table.insert(sources, 'path')
              end
              if node:type() ~= 'string' then
                table.insert(sources, 'snippets')
              end
            end

            return sources
          end,
          providers = {
            avante = {
              module = 'blink-cmp-avante',
              name = 'Avante',
              opts = {
                -- options for blink-cmp-avante
              }
            }
          },
          per_filetype = {
            -- codecompanion = { 'codecompanion', 'buffer' },
          },
        },
        snippets   = {
          preset = "default",
        },
        signature  = { enabled = true },
      }
    end,
  },
}
