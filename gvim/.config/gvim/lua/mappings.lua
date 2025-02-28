local map = vim.keymap.set
local wk = require "which-key"
local oil = require "oil"
local harpoon = require "harpoon"
local conform = require "conform"
local options = { noremap = true, silent = true }

local merge = function(a)
	local c = {}
	for k, v in pairs(a) do
		c[k] = v
	end
	for k, v in pairs(options) do
		c[k] = v
	end

	return c
end

-- Quickfix util functions lists
local clear_qf_list = function()
	vim.fn.setqflist {}
	vim.cmd "cclose"
end

local remove_qf_entry = function(index)
	local qflist = vim.fn.getqflist()
	table.remove(qflist, index)
	vim.fn.setqflist(qflist)
	vim.cmd "copen"
end

local remove_current_qf_entry = function()
	local current_qf_index = vim.fn.getqflist({ idx = 0 }).idx
	remove_qf_entry(current_qf_index)
end

local jump_to_qf_index_input = function()
	local index = vim.fn.input "Enter Quickfix Index: "
	vim.cmd("cc " .. index)
end

-- General Mappings -----------------------------------------------------------
map("n", ";", ":", merge { desc = "Enter command mode" })
map("v", "p", '"_dp', merge { desc = "Paste without yanking" })
map("n", "YY", "va{Vy", merge { desc = "Copy block" })
map("n", "YY", "va{Vy", merge { desc = "copy {} block" })

-- Window Navigation ----------------------------------------------------------
map("n", "<C-h>", "<C-w>h", merge { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", merge { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", merge { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", merge { desc = "Window right" })

-- Line Movement --------------------------------------------------------------
map("n", "<A-j>", ":m .+1<CR>==", merge { desc = "Move line up (N)" })
map("n", "<A-k>", ":m .-2<CR>==", merge { desc = "Move line down (N)" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", merge { desc = "Move line/block up (I)" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", merge { desc = "Move line/block down (I)" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", merge { desc = "Move line up (V)" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", merge { desc = "Move line down (V)" })

-- Show diagnostics ------------------------------------------------------------
map("n", "E", function()
	vim.diagnostic.open_float()
end, merge { desc = "Move line up (N)" })

-- Blackholde delete -----------------------------------------------------------
map({ "n", "x", "v", "o" }, "<leader>d", '"_d', merge { desc = "Delete without yanking" })

-- File Explorer (Oil.nvim) ----------------------------------------------------
map("n", "<leader>e", "<Cmd>Oil<CR>", { desc = "Oil File Explorer" })
map('n', '<leader>e', oil.toggle_float, merge { desc = "Oil" })

-- Tab Navigation (Alt+Number) -------------------------------------------------
for i = 1, 9 do
	map("n", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to Tab " .. i })
end

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Navigate vim panes better
map("n", "<c-k>", ":wincmd k<CR>")
map("n", "<c-j>", ":wincmd j<CR>")
map("n", "<c-h>", ":wincmd h<CR>")
map("n", "<c-l>", ":wincmd l<CR>")

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Global Which-Key Groups ----------------------------------------------------
wk.add {
	{ "<leader>q", group = "Quickfix" },
	{ "<leader>d", group = "Debug" },
	{ "<leader>h", group = "Harpoon" },
	{ "<leader>t", group = "Tabs" },
	{ "<leader>f", group = "Find" },
	{ "<leader>s", group = "Search" },
	{ "<leader>g", group = "Git" },
	{ "<leader>c", group = "Code" },
}

wk.add {
	{ "<leader>w", proxy = "<c-w>", group = "windows" },
}

-- Tab Management -------------------------------------------------------------
wk.add {
	{ "<leader>t", group = "Tabs" },
	{ "<leader>tn", "<Cmd>tabnew<CR>", desc = "New Tab" },
	{ "<leader>tc", "<Cmd>tabclose<CR>", desc = "Close Tab" },
	{ "<leader>to", "<Cmd>tabonly<CR>", desc = "Only Current" },
	{ "<leader>tm", "<Cmd>tabmove -1<CR>", desc = "Move Left" },
	{ "<leader>tM", "<Cmd>tabmove +1<CR>", desc = "Move Right" },
}

-- Tab Navigation (Alt+Number) ------------------------------------------------
for i = 1, 9 do
	map("n", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to Tab " .. i })
end

-- Conform
wk.add {
	{
		"<leader>fm",
		function()
			conform.format {}
		end,
		desc = "Format file",
		mode = { "n", "v" },
	},
}

-- Undotrue -------------------------------------------------------------------
wk.add {
	{
		"<leader>U",
		function()
			vim.cmd.UndotreeToggle()
			vim.cmd.UndotreeFocus()
		end,
		desc = "Toggle Undo Tree",
		mode = { "n" },
	},
}

-- Harpoon Mappings -----------------------------------------------------------
harpoon.setup()

wk.add {
	{ "<leader>h", group = "Harpoon" },
	{
		"<leader>ha",
		function()
			harpoon:list():add()
		end,
		desc = "Add Buffer to List",
	},
	{
		"<leader>hr",
		function()
			harpoon:list():remove()
		end,
		desc = "Remove Buffer from List",
	},
	{
		"<leader>hc",
		function()
			harpoon:list():clear()
		end,
		desc = "Clear List",
	},
	{
		"<leader>hl",
		function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Show List",
	},
	{
		"<Tab>",
		function()
			harpoon:list():next { ui_nav_wrap = true }
		end,
		desc = "Next Buffer",
	},
	{
		"<S-Tab>",
		function()
			harpoon:list():prev { ui_nav_wrap = true }
		end,
		desc = "Prev Buffer",
	},
}

for i = 1, 9 do
	wk.add {
		{
			"<leader>h" .. i,
			function()
				harpoon:list():select(i)
			end,
			desc = "Select Buffer " .. i,
		},
	}
end

harpoon:extend {
	UI_CREATE = function(cx)
		-- Add all harpoon key mappings via which-key
		wk.add {
			{
				{ buffer = cx.bufnr },
				{
					"<C-v>",
					function()
						harpoon.ui:select_menu_item { vsplit = true }
					end,
					desc = "Open harpoon buffer in V split",
					mode = { "n" },
				},
				{
					"<C-h>",
					function()
						harpoon.ui:select_menu_item { split = true }
					end,
					desc = "Open harpoon buffer in H split",
					mode = { "n" },
				},
				{
					"<C-t>",
					function()
						harpoon.ui:select_menu_item { tabedit = true }
					end,
					desc = "Open harpoon buffer in new tab",
					mode = { "n" },
				},
			},
		}

		-- -- Optionally, also set these keymaps explicitly
		-- vim.keymap.set("n", "<C-v>", function()
		-- 	harpoon.ui:select_menu_item { vsplit = true }
		-- end, { buffer = cx.bufnr })
		-- vim.keymap.set("n", "<C-x>", function()
		-- 	harpoon.ui:select_menu_item { split = true }
		-- end, { buffer = cx.bufnr })
		-- vim.keymap.set("n", "<C-t>", function()
		-- 	harpoon.ui:select_menu_item { tabedit = true }
		-- end, { buffer = cx.bufnr })
	end,
}

wk.add {
	{ "<leader>q", group = "+quickfix" },
	{ "<leader>qo", "<cmd>copen<cr>", desc = "Open Quickfix List" },
	{ "<leader>qc", "<cmd>cclose<cr>", desc = "Close Quickfix List" },
	{ "<leader>qn", "<cmd>cnext<cr>", desc = "Next Quickfix Item" },
	{ "<leader>qp", "<cmd>cprev<cr>", desc = "Previous Quickfix Item" },
	{ "<leader>ql", "<cmd>clist<cr>", desc = "Show Quickfix List" },
	{
		"<leader>qr",
		function()
			remove_current_qf_entry()
		end,
		desc = "Remove Current Quickfix Entry",
	},
	{
		"<leader>qx",
		function()
			clear_qf_list()
		end,
		desc = "Clear Quickfix List",
	},
	{
		"<leader>qj",
		function()
			jump_to_qf_index_input()
		end,
		desc = "Jump to Specific Quickfix Index",
	},
}

-- Debugging (DAP) ------------------------------------------------------------
wk.add {
	{ "<leader>D", group = "Debug" },
	{ "<leader>Dt", "<Cmd>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
	{ "<leader>Dc", "<Cmd>DapContinue<CR>", desc = "Continue" },
	{ "<leader>Dx", "<Cmd>DapTerminate<CR>", desc = "Terminate" },
	{ "<leader>Do", "<Cmd>DapStepOver<CR>", desc = "Step Over" },
	{ "<leader>Di", "<Cmd>DapStepInto<CR>", desc = "Step Into" },
	{ "<leader>Du", "<Cmd>DapStepOut<CR>", desc = "Step Out" },
}

-- Notes key mappings
wk.add {
	{ "<leader>T", group = "Notes" },
	{
		"<leader>Td",
		"<cmd>Tdo<cr>",
		desc = "Today's Todo",
	},
	{
		"<leader>Te",
		"<cmd>TdoEntry<cr>",
		desc = "Today's Entry",
	},
	{
		"<leader>Tf",
		"<cmd>TdoFiles<cr>",
		desc = "All Notes",
	},
	{
		"<leader>Tg",
		"<cmd>TdoFind<cr>",
		desc = "Find Notes",
	},
	{
		"<leader>Ty",
		"<cmd>Tdo -1<cr>",
		desc = "Yesterday's Todo",
	},
	{
		"<leader>Tj",
		"<cmd>put =strftime('%a %d %b %r')<cr>",
		desc = "Insert Human Date",
	},
	{
		"<leader>TJ",
		"<cmd>put =strftime('%F')<cr>",
		desc = "Insert Date",
	},
	{
		"<leader>Tk",
		"<cmd>put =strftime('%r')<cr>",
		desc = "Insert Human Time",
	},
	{
		"<leader>TK",
		"<cmd>put =strftime('%F-%H-%M')<cr>",
		desc = "Insert Time",
	},
	{
		"<leader>Tl",
		"<cmd>Tdo 1<cr>",
		desc = "Tomorrow's Todo",
	},
	{
		"<leader>Tn",
		"<cmd>TdoNote<cr>",
		desc = "New Note",
	},
	{
		"<leader>Ts",
		'<cmd>lua require("tdo").run_with("commit " .. vim.fn.expand("%:p")) vim.notify("Commited!")<cr>',
		desc = "Commit Note",
	},
	{
		"<leader>Ti",
		"<cmd>TdoTodos<cr>",
		desc = "Incomplete Todos",
	},
	{
		"<leader>Tx",
		"<cmd>TdoToggle<cr>",
		desc = "Toggle Todo",
	},
}
