local map = vim.keymap.set
local wk = require "which-key"
local oil = require "oil"
local snipe = require "snipe"
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
map("n", "<C-u>", "<C-u>zz", merge {})
map("n", "<C-d>", "<C-d>zz", merge {})
map("n", ",", ";", { desc = "Repeat last f/t search" })
map("n", "<Esc>", "<Esc> <cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "Q", "<nop>")

-- Redo -----------------------------------------------------------------------
map("n", "U", "<C-r>", { desc = "Redo" })

-- QOL ------------------------------------------------------------------------
map({ "n", "v" }, "<leader>y", [["+y]], merge { desc = "Copy to system clipboard" })
map("n", "<leader>Y", [["+Y]], merge { desc = "Copy line to system clipboard" })

-- Replace highlighed word
map(
    "n",
    "<leader>R",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    merge { desc = "Replace current selection" }
)

-- Center mark position after jump
map("n", "'", function()
    return "'" .. vim.fn.nr2char(vim.fn.getchar()) .. "zz"
end, { expr = true, noremap = true, desc = "Jump to mark and center screen" })
map("n", "`", function()
    return "`" .. vim.fn.nr2char(vim.fn.getchar()) .. "zz"
end, { expr = true, noremap = true, desc = "Jump to exact mark position and center screen" })
-- Toggle scroll on or off
map("n", "<leader>tS", function()
    if vim.o.scrolloff == 8 then
        vim.o.scrolloff = 999
        print "Scrolloff set to 999"
    else
        vim.o.scrolloff = 8
        print "Scrolloff disabled"
    end
end, { desc = "Toggle scrolloff" })

-- Window Navigation ----------------------------------------------------------
map("n", "<C-h>", "<C-w>h", merge { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", merge { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", merge { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", merge { desc = "Window right" })

-- Buffer Navigation ----------------------------------------------------------
map({ "n", "v", "x", "o" }, "H", "g^", merge { desc = "First visible char in line" })
map({ "n", "v", "x", "o" }, "L", "g_", merge { desc = "Last visible char in line" })

-- Line Movement --------------------------------------------------------------
map("n", "<A-j>", ":m .+1<CR>==", merge { desc = "Move line up (N)" })
map("n", "<A-k>", ":m .-2<CR>==", merge { desc = "Move line down (N)" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", merge { desc = "Move line/block up (I)" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", merge { desc = "Move line/block down (I)" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", merge { desc = "Move line up (V)" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", merge { desc = "Move line down (V)" })

-- Blackhole delete -----------------------------------------------------------
map({ "n", "x", "v", "o" }, "<leader>d", '"_d', merge { desc = "Delete without yanking" })

-- File Explorer (Oil.nvim) ----------------------------------------------------
map("n", "<leader>e", oil.toggle_float, merge { desc = "Oil" })
-- Snipe -----------------------------------------------------------------------
snipe.setup()
map("n", "<leader><leader>", snipe.open_buffer_menu, merge { desc = "[P]Snipe" })

-- Tab Navigation (Alt+Number) -------------------------------------------------
for i = 1, 9 do
    map("n", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to Tab " .. i })
end

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- global lsp mappings
map("n", "<leader>cd", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Global Which-Key Groups ----------------------------------------------------
wk.add {
    { "<leader>Q",  group = "[Q]uickfix" },
    { "<leader>D",  group = "[D]ebug" },
    { "<leader>b",  group = "[B]ufferLine" },
    { "<leader>t",  group = "[T]abs" },
    { "<leader>f",  group = "[F]ind" },
    { "<leader>g",  group = "[G]it" },
    { "<leader>c",  group = "[C]ode" },
    { "<leader>Nt", group = "[N]o[t]es" },
    { "<leader>G",  group = "[G]it DiffView" },
    { "<leader>s",  group = "[S]nacks" },
    { "<leader>ss", group = "[S]nacks [S]earch" },
    { "<leader>st", group = "[s]nacks [t]oggle" },
}

wk.add { { "<leader>w", proxy = "<c-w>", group = "windows" } }
-- Treesitter context
map("n", "[c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end)

-- Tab Management -------------------------------------------------------------
wk.add {
    { "<leader>tn", "<Cmd>tabnew<CR>",     desc = "New Tab" },
    { "<leader>tc", "<Cmd>tabclose<CR>",   desc = "Close Tab" },
    { "<leader>to", "<Cmd>tabonly<CR>",    desc = "Only Current" },
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
            conform.format {
                lsp_fallback = true,
                async = true,
                timeout_ms = 500,
            }
        end,
        desc = "Format file",
        mode = { "n", "v" },
    },
}

-- bufferline
wk.add {
    { "<leader>bb", "<cmd>BufferLinePick<cr>",        desc = 'pick a buffer to open' },
    { '<leader>bx', '<cmd>BufferLinePickClose<cr>',   desc = 'select a buffer to close' },
    { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>',   desc = 'close buffers to the left' },
    { '<leader>br', '<cmd>BufferLineCloseRight<cr>',  desc = 'close buffers to the right' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'close other buffers' },
    { '<leader>bp', '<cmd>BufferLineTogglePin<cr>',   desc = 'toggle pin' },
    { '<leader>bM', '<cmd>BufferLineMovePrev<cr>',    desc = 'move buffer left' },
    { '<leader>bm', '<cmd>BufferLineMoveNext<cr>',    desc = 'move buffer right' },
    { "<s-tab>",    "<cmd>BufferLineCyclePrev<cr>",   { noremap = true, silent = true } },
    { "<tab>",      "<cmd>BufferLineCycleNext<cr>",   { noremap = true, silent = true } },
}

-- undotrue -------------------------------------------------------------------
wk.add {
    {
        "<leader>U",
        function()
            vim.cmd.undotreetoggle()
            vim.cmd.undotreefocus()
        end,
        desc = "Toggle [U]ndo tree",
        mode = { "n" },
    },
}

wk.add {
    { "<leader>Qo", "<cmd>copen<cr>",  desc = "Open Quickfix List" },
    { "<leader>Qc", "<cmd>cclose<cr>", desc = "Close Quickfix List" },
    { "<leader>Qn", "<cmd>cnext<cr>",  desc = "Next Quickfix Item" },
    { "<leader>Qp", "<cmd>cprev<cr>",  desc = "Previous Quickfix Item" },
    { "<leader>Ql", "<cmd>clist<cr>",  desc = "Show Quickfix List" },
    {
        "<leader>Qr",
        function()
            remove_current_qf_entry()
        end,
        desc = "Remove Current Quickfix Entry",
    },
    {
        "<leader>Qx",
        function()
            clear_qf_list()
        end,
        desc = "CLear Quickfix List",
    },
    {
        "<leader>Qj",
        function()
            jump_to_qf_index_input()
        end,
        desc = "Jump to Specific Quickfix Index",
    },
}

-- Debugging (DAP) ------------------------------------------------------------
wk.add {
    { "<leader>D",  group = "Debug" },
    { "<leader>Dt", "<Cmd>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
    { "<leader>Dc", "<Cmd>DapContinue<CR>",         desc = "Continue" },
    { "<leader>Dx", "<Cmd>DapTerminate<CR>",        desc = "Terminate" },
    { "<leader>Do", "<Cmd>DapStepOver<CR>",         desc = "Step Over" },
    { "<leader>Di", "<Cmd>DapStepInto<CR>",         desc = "Step Into" },
    { "<leader>Du", "<Cmd>DapStepOut<CR>",          desc = "Step Out" },
}

-- Notes key mappings
wk.add {
    {
        "<leader>Ntd",
        "<cmd>Tdo<cr>",
        desc = "Today's Todo",
    },
    {
        "<leader>Nte",
        "<cmd>TdoEntry<cr>",
        desc = "Today's Entry",
    },
    {
        "<leader>Ntf",
        "<cmd>TdoFiles<cr>",
        desc = "All Notes",
    },
    {
        "<leader>Ntg",
        "<cmd>TdoFind<cr>",
        desc = "Find Notes",
    },
    {
        "<leader>Nty",
        "<cmd>Tdo -1<cr>",
        desc = "Yesterday's Todo",
    },
    {
        "<leader>Ntj",
        "<cmd>put =strftime('%a %d %b %r')<cr>",
        desc = "Insert Human Date",
    },
    {
        "<leader>NtJ",
        "<cmd>put =strftime('%F')<cr>",
        desc = "Insert Date",
    },
    {
        "<leader>Ntk",
        "<cmd>put =strftime('%r')<cr>",
        desc = "Insert Human Time",
    },
    {
        "<leader>NtK",
        "<cmd>put =strftime('%F-%H-%M')<cr>",
        desc = "Insert Time",
    },
    {
        "<leader>Ntl",
        "<cmd>Tdo 1<cr>",
        desc = "Tomorrow's Todo",
    },
    {
        "<leader>Ntn",
        "<cmd>TdoNote<cr>",
        desc = "New Note",
    },
    {
        "<leader>Nts",
        '<cmd>lua require("tdo").run_with("commit " .. vim.fn.expand("%:p")) vim.notify("Commited!")<cr>',
        desc = "Commit Note",
    },
    {
        "<leader>Nti",
        "<cmd>TdoTodos<cr>",
        desc = "Incomplete Todos",
    },
    {
        "<leader>Ntx",
        "<cmd>TdoToggle<cr>",
        desc = "Toggle Todo",
    },
}
