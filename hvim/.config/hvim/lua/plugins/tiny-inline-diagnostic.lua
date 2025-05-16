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
					alway_show = false,
				},
				enable_on_insert = false,
				severity = {
					min = vim.diagnostic.severity.WARN,
				},
			},
			signs = {
				enabled = true,
			},
			underline = {
				enabled = true,
			},
		}
		vim.diagnostic.config { virtual_text = false }
		vim.lsp.buf_request_debounce = 250
	end,
}
