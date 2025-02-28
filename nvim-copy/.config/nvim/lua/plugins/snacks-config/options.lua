-- lua/plugins/snacks/options.lua
local M = {}

M.animate = { enabled = false }
M.git = { enabled = true }
M.dashboard = {
	sections = {
		{ section = "header" },
		{ section = "keys", gap = 0.5, padding = 2 },
		{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
		{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
		{ section = "startup" },
	},
}
M.image = { enabled = true, force = true }
M.explorer = { enabled = false }
M.indent = { enabled = true }
M.input = { enabled = true }
M.notifier = { enabled = true, timeout = 3000 }
M.picker = {
	files = {
		mappings = {
			["<M-q>"] = function(prompt_bufnr)
				require("snacks.actions").send_to_qf(prompt_bufnr)
			end,
		},
	},
	matcher = {
		cwd_bonus = true,
	},
	formatters = {
		file = {
			filename_first = true,
		},
		severity = {
			level = true,
		},
	},
	win = {
		input = {
			keys = {
				["<M-q>"] = { "qflist", mode = { "i", "n" } },
			},
		},
		list = {
			keys = {
				["<M-q>"] = "qflist",
			},
		},
	},
}
M.quickfile = { enabled = true }
M.scope = { enabled = true }
M.scroll = { enabled = false }
M.statuscolumn = { enabled = true }
M.words = { enabled = true }
M.styles = {
	notification = {
		-- wo = { wrap = true }
	},
}

return M
