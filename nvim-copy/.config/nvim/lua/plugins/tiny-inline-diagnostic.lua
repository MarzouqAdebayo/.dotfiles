return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy", -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first
	config = function()
		local tiny_inline = require "tiny-inline-diagnostic"
		tiny_inline.setup {
			preset = "ghost",
			-- transparent_bg = true,
			options = {
				multilines = {
					enabled = true,
					alway_show = true,
				},
				-- enable_on_insert = true,
			},
		}
		vim.diagnostic.config { virtual_text = false }
	end,
}
