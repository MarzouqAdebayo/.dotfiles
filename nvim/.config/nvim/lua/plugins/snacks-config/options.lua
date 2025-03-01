-- lua/plugins/snacks/options.lua
local M = {}

local layout_sm = {
	box = "vertical",
	backdrop = false,
	width = 0.9,
	height = 0.9,
	border = "none",
	{
		win = "preview",
		title = "{preview:Preview}",
		border = "rounded",
		title_pos = "center",
	},
	{
		box = "vertical",
		{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
		{ win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
	},
}

local layout_bg = {
	backdrop = false,
	width = 0.5,
	min_width = 80,
	height = 0.8,
	min_height = 30,
	box = "vertical",
	border = "rounded",
	title = "{title} {live} {flags}",
	title_pos = "center",
	{ win = "input", height = 1, border = "bottom" },
	{ win = "list", border = "none" },
	{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
}

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
	layout = {
		cycle = true,
		reverse = true,
		--- Use the default layout or vertical if the window is too narrow
		-- preset = function()
		-- 	return vim.o.columns >= 120 and "default" or "vertical"
		-- end,

		--- Use the default layout or vertical if the window is too narrow
		-- layout = function()
		-- 	return vim.o.columns >= 120 and layout_bg or layout_sm
		-- end,
		layout = layout_sm,
	},
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

local function dynamic_layout()
	return vim.o.columns >= 120 and layout_bg or layout_sm
end

return M
