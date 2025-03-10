return {
	"topazape/oldtale.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local oldtale = require "oldtale"
		oldtale.setup {
			require("oldtale").setup {
				styles = {
					booleans = { italic = true, bold = true },
				},
				integrations = {
					blink = true,
					treesitter = true,
					cmp = true,
					gitsigns = true,
					lazy = true,
					lsp = true,
					markdown = true,
					mason = true,
					noice = true,
					notify = true,
					rainbow_delimiters = true,
					saga = true,
					telescope = true,
				},
				highlight_overrides = {
					-- Comment = { fg = "#78716c" },
					-- Comment = { bg = "#57534e" },
				},
			},
		}
		vim.cmd "colorscheme oldtale"
	end,
}
