return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons", "rose-pine/neovim" },
	config = function()
		local status_ok, bufferline = pcall(require, "bufferline")
		if not status_ok then
			return
		end
		vim.opt.termguicolors = true
		bufferline.setup {
			options = {
				close_command = function()
					Snacks.bufdelete.delete()
				end,
				right_mouse_command = function()
					Snacks.bufdelete.delete()
				end,
				diagnostics = "nvim_lsp",
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = { "", "" },
				indicator = { style = "none" },
				always_show_bufferline = true,
				modified_icon = "",
			},
		}

		local colors = require "oldtale.palette"

		-- Transparent background for all tabs
		vim.api.nvim_set_hl(0, "BufferLineFill", { bg = colors.bg_dark })
		vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = colors.bg_dark })
		vim.api.nvim_set_hl(0, "BufferLineTab", { bg = colors.bg_dark })
		vim.api.nvim_set_hl(0, "BufferLineTabClose", { bg = colors.bg_dark })

		-- Highlight only the current tab text in purple
		vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = colors.bg_dark, fg = colors.orange, bold = true })
		vim.api.nvim_set_hl(0, "BufferLineTabSelected", { bg = colors.bg_dark, fg = colors.orange, bold = true })

		-- Separator
		vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = colors.bg_dark, bg = colors.bg_dark })
		vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = colors.bg_dark, bg = colors.bg_dark })
		vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = colors.bg_dark, bg = colors.bg_dark })
	end,
}
