-- ╭───────────────────────────────────────────────╮
-- │               General Settings                │
-- ╰───────────────────────────────────────────────╯
local opt = vim.opt
local o = vim.o
local g = vim.g

g.mapleader = " " -- Use <Space> as the leader key

o.laststatus = 3 -- Global statusline instead of per-window
o.showmode = false -- Hide "-- INSERT --" since it's in the statusline
o.scrolloff = 999 -- Alway center cursor to the middle of the screen

opt.termguicolors = true -- Enable true color support
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a" -- Enable mouse in all modes

opt.swapfile = false -- Disable swap files to reduce disk writes
opt.undofile = true -- Enable persistent undo history

-- Disable some default providers to speed up startup
g.loaded_node_provider = 0
g.loaded_python3_provider = 0

-- UI AND APPEARANCE
--
-- Line numbers & Cursor settings
o.number = true -- Show absolute line numbers
o.relativenumber = true -- Relative numbers for easier navigation
o.cursorline = true -- Highlight the current line
o.cursorlineopt = "number" -- Only highlight the line number

-- Column Guides
vim.opt.colorcolumn = "80" -- Highlight the 80th column for better formatting
vim.cmd [[ highlight ColorColumn guibg=#f0f0f0 ]]

-- Sign Column (for LSP, Git)
o.signcolumn = "yes"

-- Splitting behavior
o.splitbelow = true -- New horizontal splits appear below
o.splitright = true -- New vertical splits appear to the right

-- Reduces UI lag
opt.lazyredraw = true -- Prevent unnecessary UI redraws
opt.updatetime = 300 -- Faster UI refresh (default is 4000ms)
opt.redrawtime = 10000 -- Prevent lag spikes when handling large files

-- Miscellaneous UI
opt.fillchars = { eob = " " } -- Hide `~` symbols on empty lines
opt.shortmess:append "sI" -- Disable startup message
o.timeoutlen = 400 -- Reduce key timeout delay for faster mappings

-- TEXT EDIDTING AND INDENTATION
--
-- Indentation settings (2 spaces, no tabs)
o.expandtab = true -- Use spaces instead of tabs
o.shiftwidth = 2 -- Auto-indent shifts by 2 spaces
o.smartindent = true -- Auto-indent new lines
o.tabstop = 2 -- A tab counts as 2 spaces
o.softtabstop = 2 -- Backspace deletes in steps of 2 spaces

-- Text wrapping
o.wrap = true -- Disable line wrap
o.conceallevel = 0 -- Prevent text from hiding (useful for Markdown)

-- SEARCH SETTINGS
--
-- Search settings
o.ignorecase = true -- Ignore case when searching
o.smartcase = true -- Case-sensitive if uppercase letters are used

-- Cursor movement at line boundaries
opt.whichwrap:append "<>[]hl" -- Allow moving past line boundaries with arrow keys

-- PERFORMANCE OPTIMIZATIONS
--
-- Reduce redraw issues and improve performance
opt.lazyredraw = true -- Avoid redundant screen redraws
opt.updatetime = 300 -- Speed up CursorHold events (useful for LSP, Git)
opt.redrawtime = 10000 -- Prevent lag when opening large files

-- Reduce delay in rendering Neovim UI
vim.opt.ttimeoutlen = 0

-- Add binaries installed by mason.nvim to PATH
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- Avoid flickering in Neovim inside Tmux
vim.cmd [[ set termguicolors ]]
vim.cmd [[ set notermguicolors ]] -- Some users report this helps
