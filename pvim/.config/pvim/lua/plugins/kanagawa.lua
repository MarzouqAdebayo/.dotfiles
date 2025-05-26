return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1200,
	config = function()
		local kanagawa = require "kanagawa"
		kanagawa.setup {
			theme = "dragon",
			background = {
				dark = "dragon",
			},
		}
		-- vim.cmd "colorscheme kanagawa"
	end,
}
