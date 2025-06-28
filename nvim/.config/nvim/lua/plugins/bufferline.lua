-- Pretty bufferline.
return {
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    config = function()
      local bufferline = require("bufferline")
      local colors = require "oldtale.palette" -- Assuming this correctly returns your color table

      -- Define your color variables from your palette for clarity
      local bg = "#000000"                  -- Black is transparent for some reason
      local modified_fg = colors.fg
      local fg_unselected = colors.subtext3 -- Muted foreground for unselected
      local fg_selected = colors.orange     -- Bright foreground for selected

      local fg_diag_error = colors.bright_red
      local fg_diag_warning = colors.bright_yellow
      local fg_diag_info = colors.bright_cyan
      local fg_diag_hint = colors.bright_purple

      -- Helper table to ensure transparent background is consistently applied
      local transparent = { bg = bg, fg = bg }
      local fg_only = { bg = bg, fg = fg_unselected }
      local selected = { bg = bg, fg = fg_selected, bold = true }
      local fg_special = { fg = colors.bright_red, bg = bg, bold = true }

      bufferline.setup({
        options = {
          mode = "buffers",
          style_preset = bufferline.style_preset.minimal,
          themable = true, -- ESSENTIAL for highlight overrides to work
          numbers = "none",
          show_close_icon = false,
          show_buffer_close_icons = false,
          auto_toggle_bufferline = true,
          truncate_names = true,
          indicator = { style = 'none' }, -- Let highlights control indicator color
          color_icon = true,              -- Uses diagnostic colors for icons
          separator_style = false,        -- Or "thin", "padded_slant", "none", or false
          close_command = function(bufnr)
            Snacks.bufdelete(bufnr)
          end,
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(_, _, diag)
            local icons = require('icons').diagnostics -- Assuming this exists and provides icons
            local indicator = (diag.error and icons.ERROR .. ' ' or '') .. (diag.warning and icons.WARN or '')
            return vim.trim(indicator)
          end,
          -- offsets = {
          --   {
          --     filetype = "NvimTree",
          --     text = "File Explorer",
          --     text_align = "left",
          --     separator = true,
          --   }
          -- },
        },
        highlights = {
          -- Main background for the entire bufferline (empty space)
          -- Matches the unselected buffer text color for consistency
          background = fg_only,
          fill = transparent,

          -- --- Buffer States ---
          -- Unselected (visible) buffers
          buffer_visible = fg_only,

          -- numbers
          numbers = fg_only,
          numbers_visible = fg_only,
          numbers_selected = fg_only,

          -- Selected buffer
          buffer_selected = selected,
          tab_selected = selected,

          -- modified
          modified = { bg = bg, fg = modified_fg, bold = true },
          modified_visible = { bg = bg, fg = modified_fg, bold = true },
          modified_selected = { bg = bg, fg = modified_fg, bold = true },

          -- duplicate

          -- --- Diagnostics ---
          -- General diagnostic indicator colors
          diagnostic = fg_only,
          diagnostic_visible = fg_only,
          diagnostic_selected = { fg = fg_selected, bg = bg, bold = true },

          hint = { fg = fg_diag_hint, bg = bg },
          hint_visible = { fg = fg_diag_hint, bg = bg },
          hint_selected = { fg = fg_diag_hint, bg = bg, bold = true },
          hint_diagnostic = { fg = fg_diag_hint, bg = bg },
          hint_diagnostic_visible = { fg = fg_diag_hint, bg = bg },
          hint_diagnostic_selected = { fg = fg_diag_hint, bg = bg, bold = true },

          info = { fg = fg_diag_info, bg = bg },
          info_visible = { fg = fg_diag_info, bg = bg },
          info_selected = { fg = fg_diag_info, bg = bg, bold = true },
          info_diagnostic = { fg = fg_diag_info, bg = bg },
          info_diagnostic_visible = { fg = fg_diag_info, bg = bg },
          info_diagnostic_selected = { fg = fg_diag_info, bg = bg, bold = true },

          warning = { fg = fg_diag_warning, bg = bg },
          warning_visible = { fg = fg_diag_warning, bg = bg },
          warning_selected = { fg = fg_diag_warning, bg = bg, bold = true },
          warning_diagnostic = { fg = fg_diag_warning, bg = bg },
          warning_diagnostic_visible = { fg = fg_diag_warning, bg = bg },
          warning_diagnostic_selected = { fg = fg_diag_warning, bg = bg, bold = true },

          error = { fg = fg_diag_error, bg = bg },
          error_visible = { fg = fg_diag_error, bg = bg },
          error_selected = { fg = fg_diag_error, bg = bg, bold = true },
          error_diagnostic = { fg = fg_diag_error, bg = bg },
          error_diagnostic_visible = { fg = fg_diag_error, bg = bg },
          error_diagnostic_selected = { fg = fg_diag_error, bg = bg, bold = true },

          -- --- Separators and Indicators ---
          separator = transparent,
          separator_selected = transparent,
          tab_separator = transparent,
          tab_separator_selected = transparent,
          indicator_selected = transparent,
          indicator_visible = transparent,

          -- Offset separator (e.g., for NvimTree)
          offset_separator = transparent,

          -- Truncation marker (e.g., '...')
          trunc_marker = { fg = fg_unselected, bg = bg },

          -- Picker-related highlights
          pick = fg_special,
          pick_visible = fg_special,
          pick_selected = fg_special,
        }
      })
    end,
  },
}
