local colors = require "oldtale.palette"
local normal_colors = { bg = colors.none }
local border_colors = { bg = colors.none, fg = colors.orange }
local none = { bg = colors.none, fg = colors.none }
local bright = { bg = colors.orange, fg = colors.black }

vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "NormalFloat", normal_colors)
vim.api.nvim_set_hl(0, "FloatBorder", border_colors)
vim.api.nvim_set_hl(0, "SignColumn", none)
