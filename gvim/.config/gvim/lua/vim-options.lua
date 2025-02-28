local opt = vim.opt
local o = vim.o
local g = vim.g

g.mapleader = " "

o.laststatus = 3
o.showmode = false

o.number = true -- line numbers enabled by default
o.relativenumber = true -- relative numbers enabled
o.spell = false -- spelling disabled by default
o.wrap = false -- disable line wrap
o.conceallevel = 0 -- for things like dimming

vim.opt.colorcolumn = "80"
vim.cmd [[ highlight ColorColumn guibg=#f0f0f0 ]]

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Number
o.number = true
-- o.numberWidth = 2
o.ruler = true

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.timeoutlen = 400
o.undofile = true

vim.opt.swapfile = false

vim.wo.number = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
