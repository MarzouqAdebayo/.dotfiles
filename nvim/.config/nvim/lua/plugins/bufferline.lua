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
				separator_style = "thin",
				always_show_bufferline = true,
				modified_icon = "",
			},
		}

		-- Make bufferline background transparent
		vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "none" })
		vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "none" })
		vim.api.nvim_set_hl(0, "BufferLineTabClose", { bg = "none" })
		vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = "none", bold = true })
		vim.api.nvim_set_hl(0, "BufferLineTabSelected", { bg = "none" })
		vim.api.nvim_set_hl(0, "BufferLineTab", { bg = "none" })
	end,
}
